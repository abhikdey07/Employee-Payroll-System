package com.payroll.service;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.payroll.model.Payslip;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.text.DecimalFormat;
import java.time.format.DateTimeFormatter;
import java.time.Month;

@Service
public class PdfService {

    @Value("${app.company.name:My Company}")
    private String companyName;

    @Value("${app.company.address:123 Business Road, Tech City}")
    private String companyAddress;

    @Value("${app.company.email:contact@mycompany.com}")
    private String companyEmail;

    @Value("${app.company.phone:+1 234 567 8900}")
    private String companyPhone;

    private static final Color DARK_BLUE = new Color(15, 23, 42);
    private static final Color ACCENT_BLUE = new Color(59, 130, 246);
    private static final Color LIGHT_GRAY = new Color(241, 245, 249);
    private static final DecimalFormat df = new DecimalFormat("₹ ###,##0.00");
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy");

    public byte[] generatePayslipPdf(Payslip payslip) {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        try {
            Document document = new Document(PageSize.A4, 40, 40, 40, 40);
            PdfWriter.getInstance(document, out);
            document.open();

            Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 24, DARK_BLUE);
            Paragraph header = new Paragraph(companyName, headerFont);
            header.setAlignment(Element.ALIGN_CENTER);
            document.add(header);

            Font addressFont = FontFactory.getFont(FontFactory.HELVETICA, 10, Color.GRAY);
            Paragraph address = new Paragraph(companyAddress + " | " + companyPhone + " | " + companyEmail, addressFont);
            address.setAlignment(Element.ALIGN_CENTER);
            address.setSpacingAfter(10);
            document.add(address);

            document.add(new Paragraph("______________________________________________________________________________"));

            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16, DARK_BLUE);
            String monthName = Month.of(payslip.getMonth()).name();
            monthName = monthName.substring(0, 1).toUpperCase() + monthName.substring(1).toLowerCase();
            Paragraph title = new Paragraph("SALARY SLIP - " + monthName + " " + payslip.getYear(), titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingBefore(10);
            title.setSpacingAfter(10);
            document.add(title);

            document.add(new Paragraph("______________________________________________________________________________"));
            document.add(new Paragraph("\n"));

            PdfPTable detailsTable = new PdfPTable(2);
            detailsTable.setWidthPercentage(100);
            detailsTable.getDefaultCell().setBorder(0);
            
            Font valueFont = FontFactory.getFont(FontFactory.HELVETICA, 10, Color.BLACK);

            detailsTable.addCell(new Phrase("Employee Name: " + payslip.getEmployee().getFirstName() + " " + payslip.getEmployee().getLastName(), valueFont));
            String doj = payslip.getEmployee().getDateOfJoining() != null ? payslip.getEmployee().getDateOfJoining().format(formatter) : "N/A";
            detailsTable.addCell(new Phrase("Date of Joining: " + doj, valueFont));
            
            detailsTable.addCell(new Phrase("Employee Code: " + payslip.getEmployee().getEmpCode(), valueFont));
            detailsTable.addCell(new Phrase("Pay Period: " + monthName + " " + payslip.getYear(), valueFont));
            
            detailsTable.addCell(new Phrase("Designation: " + payslip.getEmployee().getDesignation(), valueFont));
            detailsTable.addCell(new Phrase("Payment Date: " + payslip.getGeneratedAt().format(formatter), valueFont));
            
            String deptName = payslip.getEmployee().getDepartment() != null ? payslip.getEmployee().getDepartment().getName() : "N/A";
            detailsTable.addCell(new Phrase("Department: " + deptName, valueFont));
            detailsTable.addCell(new Phrase("", valueFont));

            document.add(detailsTable);
            document.add(new Paragraph("\n"));

            PdfPTable earningsTable = new PdfPTable(2);
            earningsTable.setWidthPercentage(100);
            addTableHeader(earningsTable, "Earnings", "Amount");
            addRow(earningsTable, "Basic Salary", payslip.getBasicSalary(), false);
            addRow(earningsTable, "HRA", payslip.getHra(), false);
            addRow(earningsTable, "Transport Allowance", payslip.getTransportAllowance(), false);
            addRow(earningsTable, "Medical Allowance", payslip.getMedicalAllowance(), false);
            addRow(earningsTable, "Other Allowance", payslip.getOtherAllowance(), false);
            addRow(earningsTable, "Gross Salary", payslip.getGrossSalary(), true);
            document.add(earningsTable);
            document.add(new Paragraph("\n"));

            PdfPTable deductionsTable = new PdfPTable(2);
            deductionsTable.setWidthPercentage(100);
            addTableHeader(deductionsTable, "Deductions", "Amount");
            addRow(deductionsTable, "Provident Fund", payslip.getPfDeduction(), false);
            addRow(deductionsTable, "Income Tax", payslip.getTaxDeduction(), false);
            addRow(deductionsTable, "Other Deductions", payslip.getOtherDeduction(), false);
            addRow(deductionsTable, "Total Deductions", payslip.getTotalDeductions(), true);
            document.add(deductionsTable);
            document.add(new Paragraph("\n"));

            Font netSalaryFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, DARK_BLUE);
            Paragraph netSalary = new Paragraph("NET SALARY: " + df.format(payslip.getNetSalary()), netSalaryFont);
            netSalary.setAlignment(Element.ALIGN_CENTER);
            document.add(netSalary);
            
            document.add(new Paragraph("\n\n\n"));
            Font footerFont = FontFactory.getFont(FontFactory.HELVETICA, 8, Color.GRAY);
            Paragraph footer = new Paragraph("This is a computer-generated payslip and does not require a signature.\nGenerated on: " + payslip.getGeneratedAt().format(formatter) + "\n" + companyName, footerFont);
            footer.setAlignment(Element.ALIGN_CENTER);
            document.add(footer);

            document.close();
        } catch (DocumentException e) {
            e.printStackTrace();
        }
        return out.toByteArray();
    }

    private void addTableHeader(PdfPTable table, String header1, String header2) {
        Font font = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, Color.WHITE);
        PdfPCell cell1 = new PdfPCell(new Phrase(header1, font));
        cell1.setBackgroundColor(DARK_BLUE);
        cell1.setPadding(8);
        table.addCell(cell1);

        PdfPCell cell2 = new PdfPCell(new Phrase(header2, font));
        cell2.setBackgroundColor(DARK_BLUE);
        cell2.setPadding(8);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        table.addCell(cell2);
    }

    private void addRow(PdfPTable table, String description, Double amount, boolean isTotal) {
        Font font = FontFactory.getFont(isTotal ? FontFactory.HELVETICA_BOLD : FontFactory.HELVETICA, 10, Color.BLACK);
        PdfPCell cell1 = new PdfPCell(new Phrase(description, font));
        cell1.setPadding(6);
        PdfPCell cell2 = new PdfPCell(new Phrase(df.format(amount != null ? amount : 0.0), font));
        cell2.setPadding(6);
        cell2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        
        if (isTotal) {
            cell1.setBackgroundColor(LIGHT_GRAY);
            cell2.setBackgroundColor(LIGHT_GRAY);
        }
        
        table.addCell(cell1);
        table.addCell(cell2);
    }
}
