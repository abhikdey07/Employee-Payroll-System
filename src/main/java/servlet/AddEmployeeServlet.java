package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import dao.EmployeeDAO;
import model.Employee;

@WebServlet(name="AddEmployeeServlet", urlPatterns={"/AddEmployeeServlet"})
public class AddEmployeeServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            Employee e = new Employee();
            e.setFirstname(req.getParameter("firstname"));
            e.setLastname(req.getParameter("lastname"));
            e.setDob(Date.valueOf(req.getParameter("dob")));
            e.setGender(req.getParameter("gender"));
            e.setEmail(req.getParameter("email"));
            e.setContact(req.getParameter("contact"));
            e.setAddress1(req.getParameter("address1"));
            e.setAddress2(req.getParameter("address2"));
            e.setHouseNo(req.getParameter("house_no"));
            e.setPostalCode(req.getParameter("postal_code"));
            e.setDepartment(req.getParameter("department"));
            e.setDesignation(req.getParameter("designation"));
            e.setStatus(req.getParameter("status"));
            e.setHireDate(Date.valueOf(req.getParameter("hire_date")));
            e.setBasicSalary(Double.parseDouble(req.getParameter("basic_salary")));
            e.setJobTitle(req.getParameter("job_title"));

            int id = new EmployeeDAO().add(e);

            // ✅ If employee added successfully
            if (id > 0) {
                resp.sendRedirect("addEmployee.jsp?success=1");
            } else {
                resp.sendRedirect("addEmployee.jsp?success=0");
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            // ❌ If error occurred
            resp.sendRedirect("addEmployee.jsp?success=0");
        }
    }
}
