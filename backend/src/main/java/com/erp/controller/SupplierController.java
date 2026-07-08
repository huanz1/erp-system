package com.erp.controller;

import com.erp.common.PageResult;
import com.erp.common.Result;
import com.erp.dto.PageQueryDTO;
import com.erp.entity.Supplier;
import com.erp.service.SupplierService;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/supplier")
public class SupplierController {

    private final SupplierService supplierService;

    public SupplierController(SupplierService supplierService) {
        this.supplierService = supplierService;
    }

    @GetMapping("/page")
    public Result<PageResult<Supplier>> getPage(PageQueryDTO dto) {
        return Result.success(supplierService.getPage(dto));
    }

    @GetMapping("/list")
    public Result<List<Supplier>> getList() {
        return Result.success(supplierService.list());
    }

    @PostMapping
    public Result<Void> add(@RequestBody Supplier supplier) {
        supplierService.add(supplier);
        return Result.success();
    }

    @PutMapping
    public Result<Void> update(@RequestBody Supplier supplier) {
        supplierService.update(supplier);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        supplierService.removeById(id);
        return Result.success();
    }

    @GetMapping("/{id}")
    public Result<Supplier> getById(@PathVariable Long id) {
        return Result.success(supplierService.getById(id));
    }
}