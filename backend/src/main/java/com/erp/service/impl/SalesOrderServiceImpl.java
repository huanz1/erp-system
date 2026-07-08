package com.erp.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.erp.common.BusinessException;
import com.erp.common.PageResult;
import com.erp.dto.PageQueryDTO;
import com.erp.dto.SalesOrderDTO;
import com.erp.entity.*;
import com.erp.mapper.*;
import com.erp.service.SalesOrderService;
import com.erp.vo.SalesOrderVO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class SalesOrderServiceImpl extends ServiceImpl<SalesOrderMapper, SalesOrder> implements SalesOrderService {

    private final SalesOrderItemMapper itemMapper;
    private final CustomerMapper customerMapper;
    private final InventoryMapper inventoryMapper;
    private final InventoryRecordMapper inventoryRecordMapper;

    public SalesOrderServiceImpl(SalesOrderItemMapper itemMapper, CustomerMapper customerMapper,
                                  InventoryMapper inventoryMapper, InventoryRecordMapper inventoryRecordMapper) {
        this.itemMapper = itemMapper;
        this.customerMapper = customerMapper;
        this.inventoryMapper = inventoryMapper;
        this.inventoryRecordMapper = inventoryRecordMapper;
    }

    @Override
    public PageResult<SalesOrderVO> getPage(PageQueryDTO dto) {
        LambdaQueryWrapper<SalesOrder> wrapper = new LambdaQueryWrapper<SalesOrder>()
                .like(org.springframework.util.StringUtils.hasText(dto.getKeyword()),
                        SalesOrder::getOrderNo, dto.getKeyword())
                .orderByDesc(SalesOrder::getCreateTime);
        Page<SalesOrder> page = this.page(new Page<>(dto.getPageNum(), dto.getPageSize()), wrapper);
        List<SalesOrderVO> voList = page.getRecords().stream().map(this::convertToVO).collect(Collectors.toList());
        return new PageResult<>(page.getTotal(), voList);
    }

    @Override
    public SalesOrderVO getDetail(Long id) {
        SalesOrder order = this.getById(id);
        if (order == null) {
            throw new BusinessException("销售单不存在");
        }
        SalesOrderVO vo = convertToVO(order);
        List<SalesOrderItem> items = itemMapper.selectList(
                new LambdaQueryWrapper<SalesOrderItem>().eq(SalesOrderItem::getOrderId, id));
        vo.setItems(items);
        return vo;
    }

    @Override
    @Transactional
    public SalesOrderVO create(SalesOrderDTO dto) {
        SalesOrder order = new SalesOrder();
        order.setOrderNo(generateOrderNo());
        order.setCustomerId(dto.getCustomerId());
        order.setRemark(dto.getRemark());
        order.setOperator(dto.getOperator());
        order.setOrderDate(dto.getOrderDate());
        order.setStatus(0);
        this.save(order);

        BigDecimal total = BigDecimal.ZERO;
        List<SalesOrderItem> items = new ArrayList<>();
        for (SalesOrderDTO.Item itemDto : dto.getItems()) {
            SalesOrderItem item = new SalesOrderItem();
            item.setOrderId(order.getId());
            item.setProductId(itemDto.getProductId());
            item.setQuantity(itemDto.getQuantity());
            item.setUnitPrice(itemDto.getUnitPrice());
            item.setTotalPrice(itemDto.getUnitPrice().multiply(BigDecimal.valueOf(itemDto.getQuantity())));
            item.setRemark(itemDto.getRemark());
            items.add(item);
            total = total.add(item.getTotalPrice());
        }
        for (SalesOrderItem item : items) {
            itemMapper.insert(item);
        }

        order.setTotalAmount(total);
        this.updateById(order);

        SalesOrderVO vo = convertToVO(order);
        vo.setItems(items);
        return vo;
    }

    @Override
    @Transactional
    public void updateStatus(Long id, Integer status) {
        SalesOrder order = this.getById(id);
        if (order == null) {
            throw new BusinessException("销售单不存在");
        }
        if (status == 1) {
            if (order.getStatus() != 0) {
                throw new BusinessException("当前状态不允许出库");
            }
            List<SalesOrderItem> items = itemMapper.selectList(
                    new LambdaQueryWrapper<SalesOrderItem>().eq(SalesOrderItem::getOrderId, id));
            for (SalesOrderItem item : items) {
                Inventory inv = inventoryMapper.selectOne(
                        new LambdaQueryWrapper<Inventory>().eq(Inventory::getProductId, item.getProductId()));
                if (inv == null || inv.getQuantity() < item.getQuantity()) {
                    throw new BusinessException("商品ID " + item.getProductId() + " 库存不足");
                }
                int beforeQty = inv.getQuantity();
                inv.setQuantity(inv.getQuantity() - item.getQuantity());
                inventoryMapper.updateById(inv);

                InventoryRecord record = new InventoryRecord();
                record.setProductId(item.getProductId());
                record.setType(2);
                record.setQuantity(-item.getQuantity());
                record.setBeforeQuantity(beforeQty);
                record.setAfterQuantity(inv.getQuantity());
                record.setReferenceNo(order.getOrderNo());
                record.setRemark("销售出库");
                inventoryRecordMapper.insert(record);
            }
        }
        order.setStatus(status);
        this.updateById(order);
    }

    private SalesOrderVO convertToVO(SalesOrder order) {
        SalesOrderVO vo = new SalesOrderVO();
        vo.setId(order.getId());
        vo.setOrderNo(order.getOrderNo());
        vo.setCustomerId(order.getCustomerId());
        vo.setTotalAmount(order.getTotalAmount());
        vo.setStatus(order.getStatus());
        vo.setRemark(order.getRemark());
        vo.setOperator(order.getOperator());
        vo.setOrderDate(order.getOrderDate());
        vo.setCreateTime(order.getCreateTime());
        if (order.getCustomerId() != null) {
            Customer customer = customerMapper.selectById(order.getCustomerId());
            if (customer != null) {
                vo.setCustomerName(customer.getCustomerName());
            }
        }
        return vo;
    }

    private String generateOrderNo() {
        return "SO" + LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS"));
    }
}