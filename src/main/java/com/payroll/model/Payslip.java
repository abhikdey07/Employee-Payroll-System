package com.payroll.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name="payslips", uniqueConstraints=@UniqueConstraint(columnNames={"employee_id","month","year"}))
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Payslip {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch=FetchType.EAGER)
    @JoinColumn(name="employee_id")
    private Employee employee;

    @Column(nullable=false)
    private Integer month;

    @Column(nullable=false)
    private Integer year;

    private Double basicSalary;
    private Double hra;
    private Double transportAllowance;
    private Double medicalAllowance;
    private Double otherAllowance;
    private Double grossSalary;

    private Double pfDeduction;
    private Double taxDeduction;
    private Double otherDeduction;
    private Double totalDeductions;
    
    private Double netSalary;

    private LocalDateTime generatedAt;

    @Builder.Default
    private Boolean emailed = false;

    private LocalDateTime emailedAt;

    @PrePersist
    protected void onCreate() {
        generatedAt = LocalDateTime.now();
    }
}
