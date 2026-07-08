package com.erp.service;

import com.erp.dto.LoginDTO;
import com.erp.vo.LoginVO;

public interface AuthService {
    LoginVO login(LoginDTO loginDTO);
    LoginVO getCurrentUser(Long userId);
}