package com.erp.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.erp.common.PageResult;
import com.erp.dto.PageQueryDTO;
import com.erp.entity.Inventory;
import com.erp.entity.InventoryRecord;
import com.erp.entity.Product;
import com.erp.mapper.InventoryMapper;
import com.erp.mapper.InventoryRecordMapper;
import com.erp.mapper.ProductMapper;
import com.erp.service.InventoryService;
import com.erp.vo.InventoryVO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class InventoryServiceImpl implements InventoryService {

    private final InventoryMapper inventoryMapper;
    private final InventoryRecordMapper inventoryRecordMapper;
    private final ProductMapper productMapper;

    public InventoryServiceImpl(InventoryMapper inventoryMapper, InventoryRecordMapper inventoryRecordMapper,
                                 ProductMapper productMapper) {
        this.inventoryMapper = inventoryMapper;
        this.inventoryRecordMapper = inventoryRecordMapper;
        this.productMapper = productMapper;
    }

    @Override
    public PageResult<InventoryVO> getPage(PageQueryDTO dto) {
        LambdaQueryWrapper<Inventory> wrapper = new LambdaQueryWrapper<Inventory>()
                .orderByDesc(Inventory::getUpdateTime);
        Page<Inventory> page = inventoryMapper.selectPage(new Page<>(dto.getPageNum(), dto.getPageSize()), wrapper);
        List<InventoryVO> voList = page.getRecords().stream().map(this::convertToVO).collect(Collectors.toList());
        return new PageResult<>(page.getTotal(), voList);
    }

    @Override
    @Transactional
    public void adjust(Long productId, Integer quantity, String remark) {
        Product product = productMapper.selectById(productId);
        if (product == null) {
            throw new RuntimeException("商品不存在");
        }

        Inventory inv = inventoryMapper.selectOne(
                new LambdaQueryWrapper<Inventory>().eq(Inventory::getProductId, productId));
        int beforeQty = 0;
        if (inv == null) {
            inv = new Inventory();
            inv.setProductId(productId);
            inv.setQuantity(quantity);
            inventoryMapper.insert(inv);
        } else {
            beforeQty = inv.getQuantity();
            inv.setQuantity(inv.getQuantity() + quantity);
            if (inv.getQuantity() < 0) {
                throw new RuntimeException("库存不足，调整后库存为负数");
            }
            inventoryMapper.updateById(inv);
        }

        InventoryRecord record = new InventoryRecord();
        record.setProductId(productId);
        record.setType(3);
        record.setQuantity(quantity);
        record.setBeforeQuantity(beforeQty);
        record.setAfterQuantity(inv.getQuantity());
        record.setRemark(remark);
        inventoryRecordMapper.insert(record);
    }

    @Override
    public Map<String, Object> getStats() {
        Map<String, Object> stats = new HashMap<>();
        List<Inventory> all = inventoryMapper.selectList(null);
        int totalProducts = all.size();
        int totalStock = all.stream().mapToInt(Inventory::getQuantity).sum();
        int lowStockCount = 0;

        for (Inventory inv : all) {
            Product product = productMapper.selectById(inv.getProductId());
            if (product != null && product.getMinStock() > 0 && inv.getQuantity() <= product.getMinStock()) {
                lowStockCount++;
            }
        }

        stats.put("totalProducts", totalProducts);
        stats.put("totalStock", totalStock);
        stats.put("lowStockCount", lowStockCount);
        return stats;
    }

    private InventoryVO convertToVO(Inventory inv) {
        InventoryVO vo = new InventoryVO();
        vo.setId(inv.getId());
        vo.setProductId(inv.getProductId());
        vo.setQuantity(inv.getQuantity());
        vo.setUpdateTime(inv.getUpdateTime());

        Product product = productMapper.selectById(inv.getProductId());
        if (product != null) {
            vo.setProductName(product.getProductName());
            vo.setProductCode(product.getProductCode());
            vo.setSpec(product.getSpec());
            vo.setUnit(product.getUnit());
            vo.setMinStock(product.getMinStock());
            vo.setMaxStock(product.getMaxStock());
        }
        return vo;
    }
}