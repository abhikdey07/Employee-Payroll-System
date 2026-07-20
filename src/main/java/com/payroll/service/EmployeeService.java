package com.payroll.service;

import com.payroll.dto.EmployeeDTO;
import com.payroll.model.Employee;
import com.payroll.repository.DepartmentRepository;
import com.payroll.repository.EmployeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
public class EmployeeService {

    @Autowired
    private EmployeeRepository employeeRepository;

    @Autowired
    private DepartmentRepository departmentRepository;

    public List<Employee> getAllEmployees() {
        return employeeRepository.findAll(Sort.by(Sort.Direction.ASC, "empCode"));
    }

    public Employee getEmployeeById(Long id) {
        return employeeRepository.findById(id).orElseThrow(() -> new RuntimeException("Employee not found"));
    }

    public List<Employee> searchEmployees(String query) {
        if (query == null || query.trim().isEmpty()) {
            return getAllEmployees();
        }
        return employeeRepository.searchEmployees(query);
    }

    public List<Employee> getEmployeesByDepartment(Long deptId) {
        return employeeRepository.findByDepartmentId(deptId);
    }

    public List<Employee> getEmployeesByStatus(String status) {
        return employeeRepository.findByStatus(status);
    }

    public Employee createEmployee(EmployeeDTO dto) {
        Employee employee = new Employee();
        employee.setEmpCode(generateEmpCode());
        employee.setFirstName(dto.getFirstName());
        employee.setLastName(dto.getLastName());
        employee.setEmail(dto.getEmail());
        employee.setPhone(dto.getPhone());
        employee.setDesignation(dto.getDesignation());
        if (dto.getDateOfJoining() != null) {
            employee.setDateOfJoining(dto.getDateOfJoining());
        }
        employee.setStatus(dto.getStatus());
        employee.setDepartment(departmentRepository.findById(dto.getDepartmentId()).orElseThrow(() -> new RuntimeException("Department not found")));
        
        employee.setBasicSalary(dto.getBasicSalary() != null ? dto.getBasicSalary() : 0.0);
        employee.setHra(dto.getHra() != null ? dto.getHra() : 0.0);
        employee.setTransportAllowance(dto.getTransportAllowance() != null ? dto.getTransportAllowance() : 0.0);
        employee.setMedicalAllowance(dto.getMedicalAllowance() != null ? dto.getMedicalAllowance() : 0.0);
        employee.setOtherAllowance(dto.getOtherAllowance() != null ? dto.getOtherAllowance() : 0.0);
        
        employee.setCreatedAt(LocalDateTime.now());
        employee.setUpdatedAt(LocalDateTime.now());
        
        return employeeRepository.save(employee);
    }

    public Employee updateEmployee(Long id, EmployeeDTO dto) {
        Employee employee = getEmployeeById(id);
        employee.setFirstName(dto.getFirstName());
        employee.setLastName(dto.getLastName());
        employee.setEmail(dto.getEmail());
        employee.setPhone(dto.getPhone());
        employee.setDesignation(dto.getDesignation());
        if (dto.getDateOfJoining() != null) {
            employee.setDateOfJoining(dto.getDateOfJoining());
        }
        employee.setStatus(dto.getStatus());
        if (dto.getDepartmentId() != null) {
            employee.setDepartment(departmentRepository.findById(dto.getDepartmentId()).orElseThrow(() -> new RuntimeException("Department not found")));
        }
        
        employee.setBasicSalary(dto.getBasicSalary() != null ? dto.getBasicSalary() : employee.getBasicSalary());
        employee.setHra(dto.getHra() != null ? dto.getHra() : employee.getHra());
        employee.setTransportAllowance(dto.getTransportAllowance() != null ? dto.getTransportAllowance() : employee.getTransportAllowance());
        employee.setMedicalAllowance(dto.getMedicalAllowance() != null ? dto.getMedicalAllowance() : employee.getMedicalAllowance());
        employee.setOtherAllowance(dto.getOtherAllowance() != null ? dto.getOtherAllowance() : employee.getOtherAllowance());
        
        employee.setUpdatedAt(LocalDateTime.now());
        return employeeRepository.save(employee);
    }

    public void deleteEmployee(Long id) {
        employeeRepository.deleteById(id);
    }

    public long getEmployeeCount() {
        return employeeRepository.count();
    }

    public long getActiveEmployeeCount() {
        return employeeRepository.countByStatus("ACTIVE");
    }

    private String generateEmpCode() {
        List<Employee> allEmployees = employeeRepository.findAll();
        if (allEmployees.isEmpty()) {
            return "EMP0001";
        }
        int maxId = allEmployees.stream()
                .map(e -> {
                    String code = e.getEmpCode();
                    if (code != null && code.startsWith("EMP")) {
                        try {
                            return Integer.parseInt(code.substring(3));
                        } catch (NumberFormatException ex) {
                            return 0;
                        }
                    }
                    return 0;
                })
                .max(Integer::compareTo)
                .orElse(0);
        return "EMP" + String.format("%04d", maxId + 1);
    }
}
