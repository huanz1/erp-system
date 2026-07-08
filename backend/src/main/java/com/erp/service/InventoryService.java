package com.erp.service;

import com.erp.common.PageResult;
import com.erp.dto.PageQueryDTO;
import com.erp.vo.InventoryVO;
import java.util.Map;

public interface InventoryService {
    PageResult<InventoryVO> getPage(PageQueryDTO dto);
    void adjust(Long productId, Integer quantity, String remark);
    Map<String, Object> getStats();
}