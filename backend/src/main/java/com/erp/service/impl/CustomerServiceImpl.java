package com.erp.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.erp.common.BusinessException;
import com.erp.common.PageResult;
import com.erp.dto.PageQueryDTO;
import com.erp.entity.Customer;
import com.erp.mapper.CustomerMapper;
import com.erp.service.CustomerService;
import org.springframework.stereotype.Service;

@Service
public class CustomerServiceImpl extends ServiceImpl<CustomerMapper, Customer> implements CustomerService {

    @Override
    public PageResult<Customer> getPage(PageQueryDTO dto) {
        LambdaQueryWrapper<Customer> wrapper = new LambdaQueryWrapper<Customer>()
                .like(org.springframework.util.StringUtils.hasText(dto.getKeyword()),
                        Customer::getCustomerName, dto.getKeyword())
                .orderByDesc(Customer::getCreateTime);
        Page<Customer> page = this.page(new Page<>(dto.getPageNum(), dto.getPageSize()), wrapper);
        return PageResult.of(page);
    }

    @Override
    public void add(Customer customer) {
        customer.setId(null);
        this.save(customer);
    }

    @Override
    public void update(Customer customer) {
        if (customer.getId() == null) {
            throw new BusinessException("ID不能为空");
        }
        this.updateById(customer);
    }
}