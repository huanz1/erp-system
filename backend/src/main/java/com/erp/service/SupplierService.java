package com.erp.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.erp.common.PageResult;
import com.erp.dto.PageQueryDTO;
import com.erp.entity.Supplier;

public interface SupplierService extends IService<Supplier> {
    PageResult<Supplier> getPage(PageQueryDTO dto);
    void add(Supplier supplier);
    void update(Supplier supplier);
}