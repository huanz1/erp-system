package com.erp.controller;

import com.erp.common.PageResult;
import com.erp.common.Result;
import com.erp.dto.PageQueryDTO;
import com.erp.entity.Product;
import com.erp.service.ProductService;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/product")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/page")
    public Result<PageResult<Product>> getPage(PageQueryDTO dto) {
        return Result.success(productService.getPage(dto));
    }

    @GetMapping("/list")
    public Result<List<Product>> getList() {
        return Result.success(productService.list());
    }

    @PostMapping
    public Result<Void> add(@RequestBody Product product) {
        productService.add(product);
        return Result.success();
    }

    @PutMapping
    public Result<Void> update(@RequestBody Product product) {
        productService.update(product);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        productService.removeById(id);
        return Result.success();
    }

    @GetMapping("/{id}")
    public Result<Product> getById(@PathVariable Long id) {
        return Result.success(productService.getById(id));
    }
}