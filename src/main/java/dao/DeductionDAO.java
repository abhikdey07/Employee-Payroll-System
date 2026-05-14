package dao;

import java.sql.*;
import model.Deduction;
import model.DatabaseConnection;

public class DeductionDAO {

    public void upsert(Deduction d) {
        Connection con = null;
        PreparedStatement pst = null;

        try {
            con = DatabaseConnection.getConnection();

            // Fetch employee basic salary
            double baseSalary = 0;
            PreparedStatement psBase = con.prepareStatement("SELECT basic_salary FROM employee WHERE id = ?");
            psBase.setInt(1, d.getEmpId());
            ResultSet rs = psBase.executeQuery();
            if (rs.next()) {
                baseSalary = rs.getDouble("basic_salary");
            }
            rs.close();
            psBase.close();

            // Calculate deduction
            double deductionAmount = d.getAmount();
            if (d.getPercentage() > 0) {
                deductionAmount = baseSalary * d.getPercentage() / 100.0;
            }

            // Insert or update
            String sql = """
                INSERT INTO deduction (emp_id, reason, percentage, amount, total_deduction)
                VALUES (?, ?, ?, ?, ?)
                ON DUPLICATE KEY UPDATE
                reason = VALUES(reason),
                percentage = VALUES(percentage),
                amount = VALUES(amount),
                total_deduction = VALUES(total_deduction);
            """;

            pst = con.prepareStatement(sql);
            pst.setInt(1, d.getEmpId());
            pst.setString(2, d.getReason());
            pst.setDouble(3, d.getPercentage());
            pst.setDouble(4, deductionAmount);
            pst.setDouble(5, deductionAmount);
            pst.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
