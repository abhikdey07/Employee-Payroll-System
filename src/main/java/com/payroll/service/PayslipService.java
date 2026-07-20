package com.payroll.service;

import com.payroll.dto.PayslipDTO;
import com.payroll.model.Employee;
import com.payroll.model.Payslip;
import com.payroll.repository.EmployeeRepository;
import com.payroll.repository.PayslipRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
public class PayslipService {

    @Autowired
    private PayslipRepository payslipRepository;

    @Autowired
    private EmployeeRepository employeeRepository;

    public Payslip generatePayslip(PayslipDTO dto) {
        Employee employee = employeeRepository.findById(dto.getEmployeeId())
                .orElseThrow(() -> new RuntimeException("Employee not found"));

        if (payslipRepository.findByEmployeeIdAndMonthAndYear(dto.getEmployeeId(), dto.getMonth(), dto.getYear()).isPresent()) {
            throw new RuntimeException("Payslip already exists for this employee for " + dto.getMonth() + "/" + dto.getYear());
        }

        Double basicSalary = employee.getBasicSalary() != null ? employee.getBasicSalary() : 0.0;
        Double hra = employee.getHra() != null ? employee.getHra() : 0.0;
        Double transportAllowance = employee.getTransportAllowance() != null ? employee.getTransportAllowance() : 0.0;
        Double medicalAllowance = employee.getMedicalAllowance() != null ? employee.getMedicalAllowance() : 0.0;
        Double otherAllowance = employee.getOtherAllowance() != null ? employee.getOtherAllowance() : 0.0;

        Double grossSalary = basicSalary + hra + transportAllowance + medicalAllowance + otherAllowance;

        Double pfDeduction = dto.getPfDeduction() != null ? dto.getPfDeduction() : 0.0;
        Double taxDeduction = dto.getTaxDeduction() != null ? dto.getTaxDeduction() : 0.0;
        Double otherDeduction = dto.getOtherDeduction() != null ? dto.getOtherDeduction() : 0.0;

        Double totalDeductions = pfDeduction + taxDeduction + otherDeduction;
        Double netSalary = grossSalary - totalDeductions;

        Payslip payslip = new Payslip();
        payslip.setEmployee(employee);
        payslip.setMonth(dto.getMonth());
        payslip.setYear(dto.getYear());
        payslip.setBasicSalary(basicSalary);
        payslip.setHra(hra);
        payslip.setTransportAllowance(transportAllowance);
        payslip.setMedicalAllowance(medicalAllowance);
        payslip.setOtherAllowance(otherAllowance);
        payslip.setGrossSalary(grossSalary);
        payslip.setPfDeduction(pfDeduction);
        payslip.setTaxDeduction(taxDeduction);
        payslip.setOtherDeduction(otherDeduction);
        payslip.setTotalDeductions(totalDeductions);
        payslip.setNetSalary(netSalary);
        payslip.setGeneratedAt(LocalDateTime.now());
        payslip.setEmailed(false);

        return payslipRepository.save(payslip);
    }

    public Payslip getPayslipById(Long id) {
        return payslipRepository.findById(id).orElseThrow(() -> new RuntimeException("Payslip not found"));
    }

    public List<Payslip> getPayslipsByEmployee(Long employeeId) {
        return payslipRepository.findByEmployeeId(employeeId);
    }

    public List<Payslip> getAllPayslips() {
        return payslipRepository.findAll(org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.DESC, "generatedAt"));
    }

    public List<Payslip> getRecentPayslips(int limit) {
        return payslipRepository.findTop10ByOrderByGeneratedAtDesc();
    }

    public Double getTotalPayrollForMonth(int month, int year) {
        Double total = payslipRepository.getTotalPayrollForMonth(month, year);
        return total != null ? total : 0.0;
    }

    public void markAsEmailed(Long payslipId) {
        Payslip payslip = getPayslipById(payslipId);
        payslip.setEmailed(true);
        payslip.setEmailedAt(LocalDateTime.now());
        payslipRepository.save(payslip);
    }
}
