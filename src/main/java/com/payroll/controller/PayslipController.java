package com.payroll.controller;

import com.payroll.dto.PayslipDTO;
import com.payroll.model.Payslip;
import com.payroll.service.EmailService;
import com.payroll.service.PayslipService;
import com.payroll.service.PdfService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/payslips")
@Slf4j
public class PayslipController {

    @Autowired
    private PayslipService payslipService;

    @Autowired
    private PdfService pdfService;

    @Autowired
    private EmailService emailService;

    @PostMapping("/generate")
    public ResponseEntity<Payslip> generatePayslip(@RequestBody PayslipDTO dto) {
        Payslip payslip = payslipService.generatePayslip(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(payslip);
    }

    @GetMapping
    public List<Payslip> getPayslips(
            @RequestParam(required = false) Long employeeId,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Integer year) {

        if (employeeId != null) {
            return payslipService.getPayslipsByEmployee(employeeId);
        }

        return payslipService.getAllPayslips();
    }

    @GetMapping("/{id}")
    public Payslip getPayslipById(@PathVariable Long id) {
        return payslipService.getPayslipById(id);
    }

    @GetMapping("/recent")
    public List<Payslip> getRecentPayslips(
            @RequestParam(defaultValue = "10") int limit) {
        return payslipService.getRecentPayslips(limit);
    }

    @GetMapping("/{id}/pdf")
    public ResponseEntity<ByteArrayResource> getPayslipPdf(@PathVariable Long id) {

        Payslip payslip = payslipService.getPayslipById(id);
        byte[] pdfBytes = pdfService.generatePayslipPdf(payslip);

        String filename =
                "Payslip_"
                        + payslip.getEmployee().getEmpCode()
                        + "_"
                        + payslip.getMonth()
                        + "_"
                        + payslip.getYear()
                        + ".pdf";

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(
                        HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"" + filename + "\"")
                .body(new ByteArrayResource(pdfBytes));
    }

    @PostMapping("/{id}/email")
    public ResponseEntity<Map<String, String>> emailPayslip(@PathVariable Long id) {

        try {
            Payslip payslip = payslipService.getPayslipById(id);

            byte[] pdfBytes = pdfService.generatePayslipPdf(payslip);

            emailService.sendPayslipEmail(payslip, pdfBytes);

            payslipService.markAsEmailed(id);

            return ResponseEntity.ok(
                    Map.of(
                            "message",
                            "Payslip emailed successfully to "
                                    + payslip.getEmployee().getEmail()));

        } catch (Exception e) {

            log.error("Failed to email payslip", e);

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(
                            Map.of(
                                    "error",
                                    "Failed to email payslip: " + e.getMessage()));
        }
    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<Map<String, String>> handleRuntimeException(RuntimeException e) {
        return ResponseEntity.badRequest().body(
                Map.of("error", e.getMessage()));
    }
}