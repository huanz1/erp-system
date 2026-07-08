package com.erp.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.erp.common.PageResult;
import com.erp.dto.PageQueryDTO;
import com.erp.dto.SalesOrderDTO;
import com.erp.entity.SalesOrder;
import com.erp.vo.SalesOrderVO;

public interface SalesOrderService extends IService<SalesOrder> {
    PageResult<SalesOrderVO> getPage(PageQueryDTO dto);
    SalesOrderVO getDetail(Long id);
    SalesOrderVO create(SalesOrderDTO dto);
    void updateStatus(Long id, Integer status);
}