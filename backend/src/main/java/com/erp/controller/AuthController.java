package com.erp.controller;

import com.erp.common.Result;
import com.erp.dto.LoginDTO;
import com.erp.service.AuthService;
import com.erp.vo.LoginVO;
import jakarta.validation.Valid;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public Result<LoginVO> login(@RequestBody @Valid LoginDTO loginDTO) {
        return Result.success(authService.login(loginDTO));
    }

    @GetMapping("/me")
    public Result<LoginVO> getCurrentUser(Authentication authentication) {
        Long userId = (Long) authentication.getPrincipal();
        return Result.success(authService.getCurrentUser(userId));
    }
}