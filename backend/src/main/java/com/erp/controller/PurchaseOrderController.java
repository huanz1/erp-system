package com.erp.controller;

import com.erp.common.PageResult;
import com.erp.common.Result;
import com.erp.dto.PageQueryDTO;
import com.erp.dto.PurchaseOrderDTO;
import com.erp.service.PurchaseOrderService;
import com.erp.vo.PurchaseOrderVO;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/purchase-order")
public class PurchaseOrderController {

    private final PurchaseOrderService purchaseOrderService;

    public PurchaseOrderController(PurchaseOrderService purchaseOrderService) {
        this.purchaseOrderService = purchaseOrderService;
    }

    @GetMapping("/page")
    public Result<PageResult<PurchaseOrderVO>> getPage(PageQueryDTO dto) {
        return Result.success(purchaseOrderService.getPage(dto));
    }

    @GetMapping("/{id}")
    public Result<PurchaseOrderVO> getDetail(@PathVariable Long id) {
        return Result.success(purchaseOrderService.getDetail(id));
    }

    @PostMapping
    public Result<PurchaseOrderVO> create(@RequestBody PurchaseOrderDTO dto) {
        return Result.success(purchaseOrderService.create(dto));
    }

    @PutMapping("/{id}/status")
    public Result<Void> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        purchaseOrderService.updateStatus(id, status);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        purchaseOrderService.removeById(id);
        return Result.success();
    }
}