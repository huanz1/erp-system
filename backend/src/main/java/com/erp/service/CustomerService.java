package com.erp.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.erp.common.PageResult;
import com.erp.dto.PageQueryDTO;
import com.erp.entity.Customer;

public interface CustomerService extends IService<Customer> {
    PageResult<Customer> getPage(PageQueryDTO dto);
    void add(Customer customer);
    void update(Customer customer);
}