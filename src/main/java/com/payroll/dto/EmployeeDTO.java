package com.payroll.dto;

import lombok.Data;
import java.time.LocalDate;

@Data
public class EmployeeDTO {
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String designation;
    private LocalDate dateOfJoining;
    private String status;
    private Long departmentId;
    private Double basicSalary;
    private Double hra;
    private Double transportAllowance;
    private Double medicalAllowance;
    private Double otherAllowance;
}
