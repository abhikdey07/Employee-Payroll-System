package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DatabaseConnection;

@WebServlet("/ManageAllowanceServlet")
public class ManageAllowanceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        PreparedStatement pst = null;

        try {
            int empId = parseIntSafe(request.getParameter("emp_id"));
            double overtime = parseDoubleSafe(request.getParameter("overtime"));
            double medical = parseDoubleSafe(request.getParameter("medical"));
            double bonus = parseDoubleSafe(request.getParameter("bonus"));
            double other = parseDoubleSafe(request.getParameter("other"));
            double totalOvertimeRate = parseDoubleSafe(request.getParameter("totalOvertimeRate"));
            double rphRate = parseDoubleSafe(request.getParameter("rphRate"));

            double totalAllowance = totalOvertimeRate + medical + bonus + other + rphRate;

            con = DatabaseConnection.getConnection();

            String sql = "INSERT INTO allowance (emp_id, overtime, medical, bonus, other, total_overtime_rate, rph_rate, total_allowance) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            pst = con.prepareStatement(sql);
            pst.setInt(1, empId);
            pst.setDouble(2, overtime);
            pst.setDouble(3, medical);
            pst.setDouble(4, bonus);
            pst.setDouble(5, other);
            pst.setDouble(6, totalOvertimeRate);
            pst.setDouble(7, rphRate);
            pst.setDouble(8, totalAllowance);

            int rows = pst.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("manageAllowance.jsp?success=1");
            } else {
                response.sendRedirect("manageAllowance.jsp?error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageAllowance.jsp?error=1");
        } finally {
            try {
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private int parseIntSafe(String value) {
        try {
            return (value == null || value.isEmpty()) ? 0 : Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private double parseDoubleSafe(String value) {
        try {
            return (value == null || value.isEmpty()) ? 0.0 : Double.parseDouble(value.trim());
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }
}
