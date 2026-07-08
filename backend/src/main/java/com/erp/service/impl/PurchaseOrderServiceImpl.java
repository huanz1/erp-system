package com.erp.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.erp.common.BusinessException;
import com.erp.common.PageResult;
import com.erp.dto.PageQueryDTO;
import com.erp.dto.PurchaseOrderDTO;
import com.erp.entity.*;
import com.erp.mapper.*;
import com.erp.service.PurchaseOrderService;
import com.erp.vo.PurchaseOrderVO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PurchaseOrderServiceImpl extends ServiceImpl<PurchaseOrderMapper, PurchaseOrder> implements PurchaseOrderService {

    private final PurchaseOrderItemMapper itemMapper;
    private final SupplierMapper supplierMapper;
    private final InventoryMapper inventoryMapper;
    private final InventoryRecordMapper inventoryRecordMapper;

    public PurchaseOrderServiceImpl(PurchaseOrderItemMapper itemMapper, SupplierMapper supplierMapper,
                                    InventoryMapper inventoryMapper, InventoryRecordMapper inventoryRecordMapper) {
        this.itemMapper = itemMapper;
        this.supplierMapper = supplierMapper;
        this.inventoryMapper = inventoryMapper;
        this.inventoryRecordMapper = inventoryRecordMapper;
    }

    @Override
    public PageResult<PurchaseOrderVO> getPage(PageQueryDTO dto) {
        LambdaQueryWrapper<PurchaseOrder> wrapper = new LambdaQueryWrapper<PurchaseOrder>()
                .like(org.springframework.util.StringUtils.hasText(dto.getKeyword()),
                        PurchaseOrder::getOrderNo, dto.getKeyword())
                .orderByDesc(PurchaseOrder::getCreateTime);
        Page<PurchaseOrder> page = this.page(new Page<>(dto.getPageNum(), dto.getPageSize()), wrapper);
        List<PurchaseOrderVO> voList = page.getRecords().stream().map(this::convertToVO).collect(Collectors.toList());
        return new PageResult<>(page.getTotal(), voList);
    }

    @Override
    public PurchaseOrderVO getDetail(Long id) {
        PurchaseOrder order = this.getById(id);
        if (order == null) {
            throw new BusinessException("采购单不存在");
        }
        PurchaseOrderVO vo = convertToVO(order);
        List<PurchaseOrderItem> items = itemMapper.selectList(
                new LambdaQueryWrapper<PurchaseOrderItem>().eq(PurchaseOrderItem::getOrderId, id));
        vo.setItems(items);
        return vo;
    }

    @Override
    @Transactional
    public PurchaseOrderVO create(PurchaseOrderDTO dto) {
        PurchaseOrder order = new PurchaseOrder();
        order.setOrderNo(generateOrderNo());
        order.setSupplierId(dto.getSupplierId());
        order.setRemark(dto.getRemark());
        order.setOperator(dto.getOperator());
        order.setOrderDate(dto.getOrderDate());
        order.setStatus(0);
        this.save(order);

        BigDecimal total = BigDecimal.ZERO;
        List<PurchaseOrderItem> items = new ArrayList<>();
        for (PurchaseOrderDTO.Item itemDto : dto.getItems()) {
            PurchaseOrderItem item = new PurchaseOrderItem();
            item.setOrderId(order.getId());
            item.setProductId(itemDto.getProductId());
            item.setQuantity(itemDto.getQuantity());
            item.setUnitPrice(itemDto.getUnitPrice());
            item.setTotalPrice(itemDto.getUnitPrice().multiply(BigDecimal.valueOf(itemDto.getQuantity())));
            item.setRemark(itemDto.getRemark());
            items.add(item);
            total = total.add(item.getTotalPrice());
        }
        for (PurchaseOrderItem item : items) {
            itemMapper.insert(item);
        }

        order.setTotalAmount(total);
        this.updateById(order);

        PurchaseOrderVO vo = convertToVO(order);
        vo.setItems(items);
        return vo;
    }

    @Override
    @Transactional
    public void updateStatus(Long id, Integer status) {
        PurchaseOrder order = this.getById(id);
        if (order == null) {
            throw new BusinessException("采购单不存在");
        }
        if (status == 1) {
            if (order.getStatus() != 0) {
                throw new BusinessException("当前状态不允许入库");
            }
            List<PurchaseOrderItem> items = itemMapper.selectList(
                    new LambdaQueryWrapper<PurchaseOrderItem>().eq(PurchaseOrderItem::getOrderId, id));
            for (PurchaseOrderItem item : items) {
                Inventory inv = inventoryMapper.selectOne(
                        new LambdaQueryWrapper<Inventory>().eq(Inventory::getProductId, item.getProductId()));
                int beforeQty = 0;
                if (inv == null) {
                    inv = new Inventory();
                    inv.setProductId(item.getProductId());
                    inv.setQuantity(item.getQuantity());
                    inventoryMapper.insert(inv);
                } else {
                    beforeQty = inv.getQuantity();
                    inv.setQuantity(inv.getQuantity() + item.getQuantity());
                    inventoryMapper.updateById(inv);
                }
                InventoryRecord record = new InventoryRecord();
                record.setProductId(item.getProductId());
                record.setType(1);
                record.setQuantity(item.getQuantity());
                record.setBeforeQuantity(beforeQty);
                record.setAfterQuantity(inv.getQuantity());
                record.setReferenceNo(order.getOrderNo());
                record.setRemark("采购入库");
                inventoryRecordMapper.insert(record);
            }
        }
        order.setStatus(status);
        this.updateById(order);
    }

    private PurchaseOrderVO convertToVO(PurchaseOrder order) {
        PurchaseOrderVO vo = new PurchaseOrderVO();
        vo.setId(order.getId());
        vo.setOrderNo(order.getOrderNo());
        vo.setSupplierId(order.getSupplierId());
        vo.setTotalAmount(order.getTotalAmount());
        vo.setStatus(order.getStatus());
        vo.setRemark(order.getRemark());
        vo.setOperator(order.getOperator());
        vo.setOrderDate(order.getOrderDate());
        vo.setCreateTime(order.getCreateTime());
        if (order.getSupplierId() != null) {
            Supplier supplier = supplierMapper.selectById(order.getSupplierId());
            if (supplier != null) {
                vo.setSupplierName(supplier.getSupplierName());
            }
        }
        return vo;
    }

    private String generateOrderNo() {
        return "PO" + LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS"));
    }
}