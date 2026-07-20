package com.payroll.dto;

import com.payroll.model.Payslip;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DashboardStats {
    private long totalEmployees;
    private long activeEmployees;
    private long departmentCount;
    private double totalPayrollThisMonth;
    private List<Payslip> recentPayslips;
}
