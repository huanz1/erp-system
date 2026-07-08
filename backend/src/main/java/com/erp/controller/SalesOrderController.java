package com.erp.controller;

import com.erp.common.PageResult;
import com.erp.common.Result;
import com.erp.dto.PageQueryDTO;
import com.erp.dto.SalesOrderDTO;
import com.erp.service.SalesOrderService;
import com.erp.vo.SalesOrderVO;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/sales-order")
public class SalesOrderController {

    private final SalesOrderService salesOrderService;

    public SalesOrderController(SalesOrderService salesOrderService) {
        this.salesOrderService = salesOrderService;
    }

    @GetMapping("/page")
    public Result<PageResult<SalesOrderVO>> getPage(PageQueryDTO dto) {
        return Result.success(salesOrderService.getPage(dto));
    }

    @GetMapping("/{id}")
    public Result<SalesOrderVO> getDetail(@PathVariable Long id) {
        return Result.success(salesOrderService.getDetail(id));
    }

    @PostMapping
    public Result<SalesOrderVO> create(@RequestBody SalesOrderDTO dto) {
        return Result.success(salesOrderService.create(dto));
    }

    @PutMapping("/{id}/status")
    public Result<Void> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        salesOrderService.updateStatus(id, status);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        salesOrderService.removeById(id);
        return Result.success();
    }
}