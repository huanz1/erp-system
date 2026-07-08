package com.erp.controller;

import com.erp.common.PageResult;
import com.erp.common.Result;
import com.erp.dto.PageQueryDTO;
import com.erp.entity.Category;
import com.erp.service.CategoryService;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/category")
public class CategoryController {

    private final CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping("/page")
    public Result<PageResult<Category>> getPage(PageQueryDTO dto) {
        return Result.success(categoryService.getPage(dto));
    }

    @GetMapping("/tree")
    public Result<List<Category>> getTree() {
        return Result.success(categoryService.getTree());
    }

    @GetMapping("/list")
    public Result<List<Category>> getList() {
        return Result.success(categoryService.list());
    }

    @PostMapping
    public Result<Void> add(@RequestBody Category category) {
        categoryService.add(category);
        return Result.success();
    }

    @PutMapping
    public Result<Void> update(@RequestBody Category category) {
        categoryService.update(category);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        categoryService.removeById(id);
        return Result.success();
    }

    @GetMapping("/{id}")
    public Result<Category> getById(@PathVariable Long id) {
        return Result.success(categoryService.getById(id));
    }
}