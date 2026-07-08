package com.erp.controller;

import com.erp.common.PageResult;
import com.erp.common.Result;
import com.erp.dto.PageQueryDTO;
import com.erp.service.InventoryService;
import com.erp.vo.InventoryVO;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/inventory")
public class InventoryController {

    private final InventoryService inventoryService;

    public InventoryController(InventoryService inventoryService) {
        this.inventoryService = inventoryService;
    }

    @GetMapping("/page")
    public Result<PageResult<InventoryVO>> getPage(PageQueryDTO dto) {
        return Result.success(inventoryService.getPage(dto));
    }

    @PostMapping("/adjust")
    public Result<Void> adjust(@RequestParam Long productId, @RequestParam Integer quantity,
                                @RequestParam(required = false) String remark) {
        inventoryService.adjust(productId, quantity, remark);
        return Result.success();
    }

    @GetMapping("/stats")
    public Result<Map<String, Object>> getStats() {
        return Result.success(inventoryService.getStats());
    }
}