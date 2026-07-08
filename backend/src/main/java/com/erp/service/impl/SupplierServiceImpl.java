package com.erp.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.erp.common.BusinessException;
import com.erp.common.PageResult;
import com.erp.dto.PageQueryDTO;
import com.erp.entity.Supplier;
import com.erp.mapper.SupplierMapper;
import com.erp.service.SupplierService;
import org.springframework.stereotype.Service;

@Service
public class SupplierServiceImpl extends ServiceImpl<SupplierMapper, Supplier> implements SupplierService {

    @Override
    public PageResult<Supplier> getPage(PageQueryDTO dto) {
        LambdaQueryWrapper<Supplier> wrapper = new LambdaQueryWrapper<Supplier>()
                .like(org.springframework.util.StringUtils.hasText(dto.getKeyword()),
                        Supplier::getSupplierName, dto.getKeyword())
                .orderByDesc(Supplier::getCreateTime);
        Page<Supplier> page = this.page(new Page<>(dto.getPageNum(), dto.getPageSize()), wrapper);
        return PageResult.of(page);
    }

    @Override
    public void add(Supplier supplier) {
        supplier.setId(null);
        this.save(supplier);
    }

    @Override
    public void update(Supplier supplier) {
        if (supplier.getId() == null) {
            throw new BusinessException("ID不能为空");
        }
        this.updateById(supplier);
    }
}