package dao;

import model.Employee;
import model.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {

    public int add(Employee e) {
        String sql = "INSERT INTO employee (firstname,lastname,dob,gender,email,contact,address1,address2,house_no,postal_code,department,designation,status,hire_date,basic_salary,job_title) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, e.getFirstname());
            ps.setString(2, e.getLastname());
            ps.setDate(3, e.getDob());
            ps.setString(4, e.getGender());
            ps.setString(5, e.getEmail());
            ps.setString(6, e.getContact());
            ps.setString(7, e.getAddress1());
            ps.setString(8, e.getAddress2());
            ps.setString(9, e.getHouseNo());
            ps.setString(10, e.getPostalCode());
            ps.setString(11, e.getDepartment());
            ps.setString(12, e.getDesignation());
            ps.setString(13, e.getStatus());
            ps.setDate(14, e.getHireDate());
            ps.setDouble(15, e.getBasicSalary());
            ps.setString(16, e.getJobTitle());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception ex) { ex.printStackTrace(); }
        return -1;
    }

    public Employee findById(int id) {
        String sql = "SELECT * FROM employee WHERE id=?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Employee e = new Employee();
                    e.setId(rs.getInt("id"));
                    e.setFirstname(rs.getString("firstname"));
                    e.setLastname(rs.getString("lastname"));
                    e.setDob(rs.getDate("dob"));
                    e.setGender(rs.getString("gender"));
                    e.setEmail(rs.getString("email"));
                    e.setContact(rs.getString("contact"));
                    e.setAddress1(rs.getString("address1"));
                    e.setAddress2(rs.getString("address2"));
                    e.setHouseNo(rs.getString("house_no"));
                    e.setPostalCode(rs.getString("postal_code"));
                    e.setDepartment(rs.getString("department"));
                    e.setDesignation(rs.getString("designation"));
                    e.setStatus(rs.getString("status"));
                    e.setHireDate(rs.getDate("hire_date"));
                    e.setBasicSalary(rs.getDouble("basic_salary"));
                    e.setJobTitle(rs.getString("job_title"));
                    return e;
                }
            }
        } catch (Exception ex) { ex.printStackTrace(); }
        return null;
    }

    public boolean updateBasicSalary(int id, double newSalary) {
        String sql = "UPDATE employee SET basic_salary=? WHERE id=?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, newSalary);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception ex) { ex.printStackTrace(); }
        return false;
    }

    public boolean update(Employee e) {
        String sql = "UPDATE employee SET firstname=?, lastname=?, dob=?, gender=?, email=?, contact=?, address1=?, address2=?, house_no=?, postal_code=?, department=?, designation=?, status=?, hire_date=?, basic_salary=?, job_title=? WHERE id=?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, e.getFirstname());
            ps.setString(2, e.getLastname());
            ps.setDate(3, e.getDob());
            ps.setString(4, e.getGender());
            ps.setString(5, e.getEmail());
            ps.setString(6, e.getContact());
            ps.setString(7, e.getAddress1());
            ps.setString(8, e.getAddress2());
            ps.setString(9, e.getHouseNo());
            ps.setString(10, e.getPostalCode());
            ps.setString(11, e.getDepartment());
            ps.setString(12, e.getDesignation());
            ps.setString(13, e.getStatus());
            ps.setDate(14, e.getHireDate());
            ps.setDouble(15, e.getBasicSalary());
            ps.setString(16, e.getJobTitle());
            ps.setInt(17, e.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception ex) { ex.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM employee WHERE id=?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception ex) { ex.printStackTrace(); }
        return false;
    }

    public List<Employee> searchByName(String q) {
        List<Employee> list = new ArrayList<>();
        String sql = "SELECT * FROM employee WHERE firstname LIKE ? OR lastname LIKE ?";
        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + q + "%");
            ps.setString(2, "%" + q + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Employee e = new Employee();
                    e.setId(rs.getInt("id"));
                    e.setFirstname(rs.getString("firstname"));
                    e.setLastname(rs.getString("lastname"));
                    e.setBasicSalary(rs.getDouble("basic_salary"));
                    e.setDepartment(rs.getString("department"));
                    list.add(e);
                }
            }
        } catch (Exception ex) { ex.printStackTrace(); }
        return list;
    }
}
