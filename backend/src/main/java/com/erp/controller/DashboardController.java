package com.erp.controller;

import com.erp.common.Result;
import com.erp.entity.Customer;
import com.erp.entity.Product;
import com.erp.entity.Supplier;
import com.erp.mapper.CustomerMapper;
import com.erp.mapper.ProductMapper;
import com.erp.mapper.SupplierMapper;
import com.erp.service.InventoryService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/dashboard")
public class DashboardController {

    private final ProductMapper productMapper;
    private final SupplierMapper supplierMapper;
    private final CustomerMapper customerMapper;
    private final InventoryService inventoryService;

    public DashboardController(ProductMapper productMapper, SupplierMapper supplierMapper,
                                CustomerMapper customerMapper, InventoryService inventoryService) {
        this.productMapper = productMapper;
        this.supplierMapper = supplierMapper;
        this.customerMapper = customerMapper;
        this.inventoryService = inventoryService;
    }

    @GetMapping("/stats")
    public Result<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("productCount", productMapper.selectCount(null));
        stats.put("supplierCount", supplierMapper.selectCount(null));
        stats.put("customerCount", customerMapper.selectCount(null));
        stats.putAll(inventoryService.getStats());
        return Result.success(stats);
    }
}