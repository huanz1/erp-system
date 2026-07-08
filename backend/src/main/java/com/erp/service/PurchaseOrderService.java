package com.erp.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.erp.common.PageResult;
import com.erp.dto.PageQueryDTO;
import com.erp.dto.PurchaseOrderDTO;
import com.erp.entity.PurchaseOrder;
import com.erp.vo.PurchaseOrderVO;

public interface PurchaseOrderService extends IService<PurchaseOrder> {
    PageResult<PurchaseOrderVO> getPage(PageQueryDTO dto);
    PurchaseOrderVO getDetail(Long id);
    PurchaseOrderVO create(PurchaseOrderDTO dto);
    void updateStatus(Long id, Integer status);
}