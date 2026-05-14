package servlet;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.DatabaseConnection;

@WebServlet("/SearchEmployeeServlet")
public class SearchEmployeeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchValue = request.getParameter("search");

        try (Connection con = DatabaseConnection.getConnection()) {
            String sql = """
                SELECT e.id, e.firstname, e.lastname, e.department, e.designation, e.basic_salary,
                       IFNULL(a.total_allowance, 0) AS total_allowance,
                       IFNULL(d.total_deduction, 0) AS total_deduction,
                       (e.basic_salary + IFNULL(a.total_allowance, 0) - IFNULL(d.total_deduction, 0)) AS total_salary
                FROM employee e
                LEFT JOIN allowance a ON e.id = a.emp_id
                LEFT JOIN deduction d ON e.id = d.emp_id
                WHERE e.firstname LIKE ? OR e.lastname LIKE ? OR e.id = ?;
            """;

            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, "%" + searchValue + "%");
            pst.setString(2, "%" + searchValue + "%");
            try {
                pst.setInt(3, Integer.parseInt(searchValue));
            } catch (NumberFormatException e) {
                pst.setInt(3, -1);
            }

            ResultSet rs = pst.executeQuery();
            request.setAttribute("employeeList", rs);
            request.getRequestDispatcher("searchEmployee.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("searchEmployee.jsp?error=db");
        }
    }
}
