package com.erp.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.erp.common.PageResult;
import com.erp.dto.PageQueryDTO;
import com.erp.entity.Category;
import java.util.List;

public interface CategoryService extends IService<Category> {
    PageResult<Category> getPage(PageQueryDTO dto);
    List<Category> getTree();
    void add(Category category);
    void update(Category category);
}