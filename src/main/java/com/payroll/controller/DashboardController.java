package com.payroll.controller;

import com.payroll.dto.DashboardStats;
import com.payroll.model.Department;
import com.payroll.repository.DepartmentRepository;
import com.payroll.service.EmployeeService;
import com.payroll.service.PayslipService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api")
public class DashboardController {

    @Autowired
    private EmployeeService employeeService;

    @Autowired
    private PayslipService payslipService;

    @Autowired
    private DepartmentRepository departmentRepository;

    @GetMapping("/dashboard/stats")
    public DashboardStats getDashboardStats() {
        LocalDate now = LocalDate.now();
        return DashboardStats.builder()
                .totalEmployees(employeeService.getEmployeeCount())
                .activeEmployees(employeeService.getActiveEmployeeCount())
                .departmentCount(departmentRepository.count())
                .totalPayrollThisMonth(payslipService.getTotalPayrollForMonth(now.getMonthValue(), now.getYear()))
                .recentPayslips(payslipService.getRecentPayslips(10))
                .build();
    }

    @GetMapping("/departments")
    public List<Department> getAllDepartments() {
        return departmentRepository.findAll();
    }
}
