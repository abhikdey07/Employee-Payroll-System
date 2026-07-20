package com.payroll.model;

import jakarta.persistence.*;
import lombok.*;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name="employees")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Employee {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;

    @Column(unique=true, nullable=false)
    private String empCode;

    @Column(nullable=false)
    private String firstName;

    @Column(nullable=false)
    private String lastName;

    @Column(nullable=false)
    private String email;

    private String phone;

    @ManyToOne(fetch=FetchType.EAGER)
    @JoinColumn(name="department_id")
    @JsonIgnoreProperties("employees")
    private Department department;

    private String designation;
    private LocalDate dateOfJoining;

    @Column(nullable=false)
    private Double basicSalary;

    @Builder.Default
    private Double hra = 0.0;

    @Builder.Default
    private Double transportAllowance = 0.0;

    @Builder.Default
    private Double medicalAllowance = 0.0;

    @Builder.Default
    private Double otherAllowance = 0.0;

    @Builder.Default
    private String status = "ACTIVE";

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
