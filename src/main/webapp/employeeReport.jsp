<%@ page import="java.sql.*, model.DatabaseConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Employee Report | Dey & Sons Pvt. Ltd.</title>
  <style>
    /* === Base Styling === */
    body {
      background: linear-gradient(135deg, #eaf2ff, #f8faff);
      font-family: 'Poppins', sans-serif;
      margin: 0;
      padding: 0;
      animation: fadeInBody 1s ease-in;
    }

    /* === Container === */
    .container {
      width: 90%;
      margin: 50px auto;
      background: rgba(255, 255, 255, 0.95);
      padding: 40px;
      border-radius: 16px;
      box-shadow: 0 6px 25px rgba(0,0,0,0.1);
      backdrop-filter: blur(10px);
      animation: slideUp 0.9s ease;
    }

    h1 {
      text-align: center;
      color: #0d6efd;
      margin-bottom: 8px;
      font-weight: 600;
      font-size: 26px;
      animation: fadeIn 1s ease;
    }

    h3 {
      text-align: center;
      color: #495057;
      margin-top: 0;
      font-weight: 500;
      animation: fadeIn 1.2s ease;
    }

    /* === Table Styling === */
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 25px;
      animation: fadeIn 1.2s ease;
      border-radius: 10px;
      overflow: hidden;
    }

    th, td {
      padding: 12px 10px;
      text-align: center;
      border-bottom: 1px solid #e0e0e0;
      transition: all 0.3s ease;
    }

    th {
      background-color: #0d6efd;
      color: white;
      font-weight: 600;
      letter-spacing: 0.3px;
      text-transform: uppercase;
      font-size: 14px;
    }

    tr:hover td {
      background-color: #f3f7ff;
      transform: scale(1.01);
    }

    td {
      color: #333;
      font-size: 15px;
    }

    /* === Print Button === */
    .btn {
      display: block;
      width: 250px;
      margin: 30px auto 10px auto;
      padding: 12px 20px;
      text-align: center;
      background: #198754;
      color: white;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      font-size: 16px;
      font-weight: 600;
      transition: all 0.3s ease;
      box-shadow: 0 4px 10px rgba(25,135,84,0.2);
      animation: fadeIn 1.5s ease;
    }

    .btn:hover {
      background: #157347;
      transform: scale(1.05);
      box-shadow: 0 6px 15px rgba(25,135,84,0.3);
    }

    /* === Error Row === */
    .error-row td {
      color: #842029;
      background: #f8d7da;
      border: 1px solid #f5c2c7;
      padding: 12px;
      border-radius: 8px;
    }

    /* === Animations === */
    @keyframes fadeInBody {
      from { opacity: 0; }
      to { opacity: 1; }
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: scale(0.97); }
      to { opacity: 1; transform: scale(1); }
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(30px); }
      to { opacity: 1; transform: translateY(0); }
    }

    /* === Print Friendly === */
    @media print {
      .btn {
        display: none;
      }
      body {
        background: white;
      }
      .container {
        box-shadow: none;
        border: none;
        padding: 0;
      }
    }
  </style>
</head>

<body>
  <div class="container">
    <h1>Dey & Sons Pvt. Ltd.</h1>
    <h3>Employee Report</h3>

    <table>
      <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Department</th>
        <th>Designation</th>
        <th>Basic Salary</th>
        <th>Hire Date</th>
      </tr>

      <%
        try {
          Connection con = DatabaseConnection.getConnection();
          String sql = "SELECT id, firstname, lastname, department, designation, basic_salary, hire_date FROM employee";
          PreparedStatement pst = con.prepareStatement(sql);
          ResultSet rs = pst.executeQuery();
          boolean hasData = false;
          while (rs.next()) {
            hasData = true;
      %>
      <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("firstname") + " " + rs.getString("lastname") %></td>
        <td><%= rs.getString("department") %></td>
        <td><%= rs.getString("designation") %></td>
        <td>₹<%= rs.getDouble("basic_salary") %></td>
        <td><%= rs.getDate("hire_date") %></td>
      </tr>
      <%
          }
          if (!hasData) {
      %>
      <tr class="error-row">
        <td colspan="6">No employee records found.</td>
      </tr>
      <%
          }
          con.close();
        } catch (Exception e) {
      %>
      <tr class="error-row">
        <td colspan="6">Error fetching employee data!</td>
      </tr>
      <%
        }
      %>
    </table>

    <button class="btn" onclick="window.print()">🖨 Print or Save as PDF</button>
  </div>
</body>
</html>
