package servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import model.DatabaseConnection;

@WebServlet(name="DeleteEmployeeServlet", urlPatterns={"/DeleteEmployeeServlet"})
public class DeleteEmployeeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int empId = Integer.parseInt(req.getParameter("id"));
        try {
            Connection con = DatabaseConnection.getConnection();

            // Delete the employee by ID
            PreparedStatement ps = con.prepareStatement("DELETE FROM employee WHERE id = ?");
            ps.setInt(1, empId);

            int rows = ps.executeUpdate();

            con.close();

            // Redirect with message flag
            if (rows > 0) {
                resp.sendRedirect("searchEmployee.jsp?deleted=1");
            } else {
                resp.sendRedirect("searchEmployee.jsp?deleted=0");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("searchEmployee.jsp?deleted=0");
        }
    }
}
