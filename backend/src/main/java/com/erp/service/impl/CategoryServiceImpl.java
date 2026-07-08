package com.erp.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.erp.common.BusinessException;
import com.erp.common.PageResult;
import com.erp.dto.PageQueryDTO;
import com.erp.entity.Category;
import com.erp.mapper.CategoryMapper;
import com.erp.service.CategoryService;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CategoryServiceImpl extends ServiceImpl<CategoryMapper, Category> implements CategoryService {

    @Override
    public PageResult<Category> getPage(PageQueryDTO dto) {
        LambdaQueryWrapper<Category> wrapper = new LambdaQueryWrapper<Category>()
                .like(org.springframework.util.StringUtils.hasText(dto.getKeyword()),
                        Category::getCategoryName, dto.getKeyword())
                .orderByAsc(Category::getSort);
        Page<Category> page = this.page(new Page<>(dto.getPageNum(), dto.getPageSize()), wrapper);
        return PageResult.of(page);
    }

    @Override
    public List<Category> getTree() {
        return this.list(new LambdaQueryWrapper<Category>().orderByAsc(Category::getSort));
    }

    @Override
    public void add(Category category) {
        category.setId(null);
        this.save(category);
    }

    @Override
    public void update(Category category) {
        if (category.getId() == null) {
            throw new BusinessException("ID不能为空");
        }
        this.updateById(category);
    }
}