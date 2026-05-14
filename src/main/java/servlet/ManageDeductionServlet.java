package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import dao.DeductionDAO;
import model.Deduction;

@WebServlet(name="ManageDeductionServlet", urlPatterns={"/ManageDeductionServlet"})
public class ManageDeductionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            Deduction d = new Deduction();
            d.setEmpId(Integer.parseInt(req.getParameter("emp_id")));
            d.setReason(req.getParameter("reason"));
            String mode = req.getParameter("mode");

            if ("percent".equals(mode)) {
                d.setPercentage(Double.parseDouble(req.getParameter("percentage")));
                d.setAmount(0);
            } else {
                d.setPercentage(0);
                d.setAmount(Double.parseDouble(req.getParameter("amount")));
            }

            // ✅ Call DAO (no return expected)
            new DeductionDAO().upsert(d);

            // ✅ Redirect with success message
            resp.sendRedirect("manageDeduction.jsp?empId=" + d.getEmpId() + "&success=1");

        } catch (Exception e) {
            e.printStackTrace();
            // Redirect with error flag
            String empId = req.getParameter("emp_id");
            resp.sendRedirect("manageDeduction.jsp?empId=" + (empId != null ? empId : "") + "&success=0");
        }
    }
}
