package com.payroll.config;

import com.payroll.model.Admin;
import com.payroll.model.Department;
import com.payroll.repository.AdminRepository;
import com.payroll.repository.DepartmentRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(DataInitializer.class);

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private DepartmentRepository departmentRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Value("${app.admin.username:admin}")
    private String adminUsername;

    @Value("${app.admin.password:Admin@123}")
    private String adminPassword;

    @Override
    public void run(String... args) throws Exception {
        if (adminRepository.count() == 0) {
            Admin admin = new Admin();
            admin.setUsername(adminUsername);
            admin.setPassword(passwordEncoder.encode(adminPassword));
            admin.setFullName("System Administrator");
            admin.setEmail("admin@payrollpro.com");
            adminRepository.save(admin);
            logger.info("Default admin created");
        }

        if (departmentRepository.count() == 0) {
            departmentRepository.save(new Department(null, "Human Resources", "HR operations and employee welfare"));
            departmentRepository.save(new Department(null, "Engineering", "Software development and technical operations"));
            departmentRepository.save(new Department(null, "Finance", "Financial planning, accounting and budgeting"));
            departmentRepository.save(new Department(null, "Marketing", "Brand management, advertising and promotions"));
            departmentRepository.save(new Department(null, "Operations", "Day-to-day business operations management"));
            departmentRepository.save(new Department(null, "Sales", "Revenue generation and client relationships"));
            logger.info("Default departments created");
        }
    }
}
