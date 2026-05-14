package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import model.DatabaseConnection;

@WebServlet("/GeneratePayslipServlet")
public class GeneratePayslipServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String empIdParam = request.getParameter("empId");
        if (empIdParam == null || empIdParam.isEmpty()) {
            response.sendRedirect("payslip.jsp?error=MissingID");
            return;
        }

        int empId = Integer.parseInt(empIdParam);

        try (Connection con = DatabaseConnection.getConnection()) {
            String sql = """
                SELECT e.id, e.firstname, e.lastname, e.department, e.designation, e.basic_salary,
                       IFNULL(a.total_allowance, 0) AS total_allowance,
                       IFNULL(d.total_deduction, 0) AS total_deduction,
                       (e.basic_salary + IFNULL(a.total_allowance, 0) - IFNULL(d.total_deduction, 0)) AS total_salary
                FROM employee e
                LEFT JOIN allowance a ON e.id = a.emp_id
                LEFT JOIN deduction d ON e.id = d.emp_id
                WHERE e.id = ?;
            """;

            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, empId);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                request.setAttribute("empId", rs.getInt("id"));
                request.setAttribute("name", rs.getString("firstname") + " " + rs.getString("lastname"));
                request.setAttribute("department", rs.getString("department"));
                request.setAttribute("designation", rs.getString("designation"));
                request.setAttribute("basicSalary", rs.getDouble("basic_salary"));
                request.setAttribute("allowance", rs.getDouble("total_allowance"));
                request.setAttribute("deduction", rs.getDouble("total_deduction"));
                request.setAttribute("totalSalary", rs.getDouble("total_salary"));

                request.getRequestDispatcher("payslip.jsp").forward(request, response);
            } else {
                response.sendRedirect("payslip.jsp?error=NotFound");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("payslip.jsp?error=DBError");
        }
    }
}
