package com.payroll.repository;

import com.payroll.model.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface EmployeeRepository extends JpaRepository<Employee, Long> {
    Optional<Employee> findByEmpCode(String empCode);
    List<Employee> findByStatus(String status);
    List<Employee> findByDepartmentId(Long departmentId);

    @Query("SELECT e FROM Employee e WHERE LOWER(e.firstName) LIKE LOWER(CONCAT('%',:query,'%')) " +
           "OR LOWER(e.lastName) LIKE LOWER(CONCAT('%',:query,'%')) " +
           "OR LOWER(e.empCode) LIKE LOWER(CONCAT('%',:query,'%'))")
    List<Employee> searchEmployees(@Param("query") String query);

    long countByStatus(String status);
}
