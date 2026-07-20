package com.payroll.dto;

import lombok.Data;

@Data
public class PayslipDTO {
    private Long employeeId;
    private Integer month;
    private Integer year;
    private Double pfDeduction;
    private Double taxDeduction;
    private Double otherDeduction;
}
