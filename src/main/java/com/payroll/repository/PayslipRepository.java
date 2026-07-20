package com.payroll.repository;

import com.payroll.model.Payslip;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface PayslipRepository extends JpaRepository<Payslip, Long> {
    List<Payslip> findByEmployeeId(Long employeeId);
    List<Payslip> findByMonthAndYear(Integer month, Integer year);
    Optional<Payslip> findByEmployeeIdAndMonthAndYear(Long employeeId, Integer month, Integer year);
    List<Payslip> findTop10ByOrderByGeneratedAtDesc();

    @Query("SELECT COALESCE(SUM(p.netSalary), 0) FROM Payslip p WHERE p.month = :month AND p.year = :year")
    Double getTotalPayrollForMonth(@Param("month") Integer month, @Param("year") Integer year);
}
