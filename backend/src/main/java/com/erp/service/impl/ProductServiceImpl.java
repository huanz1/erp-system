package com.erp.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.erp.common.BusinessException;
import com.erp.common.PageResult;
import com.erp.dto.PageQueryDTO;
import com.erp.entity.Product;
import com.erp.mapper.ProductMapper;
import com.erp.service.ProductService;
import org.springframework.stereotype.Service;

@Service
public class ProductServiceImpl extends ServiceImpl<ProductMapper, Product> implements ProductService {

    @Override
    public PageResult<Product> getPage(PageQueryDTO dto) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<Product>()
                .like(org.springframework.util.StringUtils.hasText(dto.getKeyword()),
                        Product::getProductName, dto.getKeyword())
                .or(org.springframework.util.StringUtils.hasText(dto.getKeyword()),
                        w -> w.like(Product::getProductCode, dto.getKeyword()))
                .orderByDesc(Product::getCreateTime);
        Page<Product> page = this.page(new Page<>(dto.getPageNum(), dto.getPageSize()), wrapper);
        return PageResult.of(page);
    }

    @Override
    public void add(Product product) {
        product.setId(null);
        this.save(product);
    }

    @Override
    public void update(Product product) {
        if (product.getId() == null) {
            throw new BusinessException("ID不能为空");
        }
        this.updateById(product);
    }
}