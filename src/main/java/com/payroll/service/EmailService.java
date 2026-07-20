package com.payroll.service;

import com.payroll.model.Payslip;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.time.Month;
import java.time.format.DateTimeFormatter;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private TemplateEngine templateEngine;

    @Value("${spring.mail.username:noreply@company.com}")
    private String senderEmail;

    @Value("${app.company.name:My Company}")
    private String companyName;

    @Value("${app.company.address:123 Business Park, Tech City, India}")
    private String companyAddress;

    public void sendPayslipEmail(Payslip payslip, byte[] pdfBytes) throws MessagingException {
        Context context = new Context();
        context.setVariable("employeeName", payslip.getEmployee().getFirstName() + " " + payslip.getEmployee().getLastName());
        context.setVariable("empCode", payslip.getEmployee().getEmpCode());
        
        String monthName = getMonthName(payslip.getMonth());
        context.setVariable("month", monthName);
        context.setVariable("year", payslip.getYear());
        
        context.setVariable("basicSalary", payslip.getBasicSalary());
        context.setVariable("hra", payslip.getHra());
        context.setVariable("transportAllowance", payslip.getTransportAllowance());
        context.setVariable("medicalAllowance", payslip.getMedicalAllowance());
        context.setVariable("otherAllowance", payslip.getOtherAllowance());
        context.setVariable("grossSalary", payslip.getGrossSalary());
        context.setVariable("pfDeduction", payslip.getPfDeduction());
        context.setVariable("taxDeduction", payslip.getTaxDeduction());
        context.setVariable("otherDeduction", payslip.getOtherDeduction());
        context.setVariable("totalDeductions", payslip.getTotalDeductions());
        context.setVariable("netSalary", payslip.getNetSalary());
        context.setVariable("companyName", companyName);
        context.setVariable("companyAddress", companyAddress);
        context.setVariable("generatedDate", payslip.getGeneratedAt().format(DateTimeFormatter.ofPattern("dd MMM yyyy")));

        String htmlContent = templateEngine.process("email-payslip", context);

        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
        
        helper.setFrom(senderEmail);
        helper.setTo(payslip.getEmployee().getEmail());
        helper.setSubject("Payslip for " + monthName + " " + payslip.getYear() + " - " + companyName);
        helper.setText(htmlContent, true);

        String filename = "Payslip_" + payslip.getEmployee().getEmpCode() + "_" + payslip.getMonth() + "_" + payslip.getYear() + ".pdf";
        helper.addAttachment(filename, new ByteArrayResource(pdfBytes), "application/pdf");

        mailSender.send(message);
    }

    private String getMonthName(int month) {
        String name = Month.of(month).name();
        return name.substring(0, 1).toUpperCase() + name.substring(1).toLowerCase();
    }
}
