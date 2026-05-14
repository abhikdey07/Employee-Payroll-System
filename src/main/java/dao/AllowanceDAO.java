package dao;

import model.Allowance;
import model.DatabaseConnection;
import java.sql.*;

public class AllowanceDAO {
    public void upsert(Allowance a) {
        String sql = "INSERT INTO allowance(emp_id,overtime,medical,bonus,other,total_overtime_rate,rph_rate) VALUES(?,?,?,?,?,?,?) " +
                     "ON DUPLICATE KEY UPDATE overtime=VALUES(overtime), medical=VALUES(medical), bonus=VALUES(bonus), other=VALUES(other), total_overtime_rate=VALUES(total_overtime_rate), rph_rate=VALUES(rph_rate)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, a.getEmpId());
            ps.setDouble(2, a.getOvertime());
            ps.setDouble(3, a.getMedical());
            ps.setDouble(4, a.getBonus());
            ps.setDouble(5, a.getOther());
            ps.setDouble(6, a.getTotalOvertimeRate());
            ps.setDouble(7, a.getRphRate());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public Allowance get(int empId) {
        String sql = "SELECT * FROM allowance WHERE emp_id=?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, empId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Allowance a = new Allowance();
                    a.setEmpId(empId);
                    a.setOvertime(rs.getDouble("overtime"));
                    a.setMedical(rs.getDouble("medical"));
                    a.setBonus(rs.getDouble("bonus"));
                    a.setOther(rs.getDouble("other"));
                    a.setTotalOvertimeRate(rs.getDouble("total_overtime_rate"));
                    a.setRphRate(rs.getDouble("rph_rate"));
                    return a;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
}
