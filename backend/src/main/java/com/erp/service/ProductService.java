package com.erp.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.erp.common.PageResult;
import com.erp.dto.PageQueryDTO;
import com.erp.entity.Product;

public interface ProductService extends IService<Product> {
    PageResult<Product> getPage(PageQueryDTO dto);
    void add(Product product);
    void update(Product product);
}