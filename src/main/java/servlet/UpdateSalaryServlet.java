package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.EmployeeDAO;

@WebServlet(name="UpdateSalaryServlet", urlPatterns={"/UpdateSalaryServlet"})
public class UpdateSalaryServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int empId = Integer.parseInt(req.getParameter("emp_id"));
        double basic = Double.parseDouble(req.getParameter("basic_salary"));
        String mode = req.getParameter("mode");
        double value = Double.parseDouble(req.getParameter("value"));

        double newSalary = basic;
        if ("percent".equals(mode)) newSalary = basic + (basic * value / 100.0);
        else if ("amount".equals(mode)) newSalary = basic + value;

        new EmployeeDAO().updateBasicSalary(empId, newSalary);
        resp.sendRedirect("updateSalary.jsp?empId=" + empId + "&newSalary=" + newSalary);
    }
}
