package com.erp.controller;

import com.erp.common.PageResult;
import com.erp.common.Result;
import com.erp.dto.PageQueryDTO;
import com.erp.entity.Customer;
import com.erp.service.CustomerService;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/customer")
public class CustomerController {

    private final CustomerService customerService;

    public CustomerController(CustomerService customerService) {
        this.customerService = customerService;
    }

    @GetMapping("/page")
    public Result<PageResult<Customer>> getPage(PageQueryDTO dto) {
        return Result.success(customerService.getPage(dto));
    }

    @GetMapping("/list")
    public Result<List<Customer>> getList() {
        return Result.success(customerService.list());
    }

    @PostMapping
    public Result<Void> add(@RequestBody Customer customer) {
        customerService.add(customer);
        return Result.success();
    }

    @PutMapping
    public Result<Void> update(@RequestBody Customer customer) {
        customerService.update(customer);
        return Result.success();
    }

    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        customerService.removeById(id);
        return Result.success();
    }

    @GetMapping("/{id}")
    public Result<Customer> getById(@PathVariable Long id) {
        return Result.success(customerService.getById(id));
    }
}