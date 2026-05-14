<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Payslip | Dey & Sons Pvt. Ltd.</title>
  <style>
    /* === Base Styling === */
    body {
      font-family: 'Poppins', sans-serif;
      background: linear-gradient(135deg, #eaf2ff, #f8faff);
      height: 100vh;
      margin: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      animation: fadeInBody 1s ease-in;
    }

    /* === Card Container === */
    .card {
      background: rgba(255, 255, 255, 0.9);
      border-radius: 16px;
      padding: 40px;
      width: 600px;
      box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
      backdrop-filter: blur(10px);
      animation: slideUp 0.9s ease;
    }

    /* === Headers === */
    h1 {
      text-align: center;
      color: #0d6efd;
      font-size: 26px;
      font-weight: 600;
      margin-bottom: 5px;
      animation: fadeIn 1s ease;
    }

    h3 {
      text-align: center;
      color: #495057;
      margin-bottom: 30px;
      font-weight: 500;
      animation: fadeIn 1.2s ease;
    }

    /* === Table Styling === */
    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 25px;
      animation: fadeIn 1s ease;
    }

    td, th {
      padding: 10px 8px;
      border-bottom: 1px solid #e0e0e0;
      font-size: 15px;
    }

    th {
      text-align: left;
      color: #0d6efd;
      font-weight: 600;
    }

    td {
      color: #333;
    }

    .total {
      font-weight: bold;
      color: #000;
      background-color: #f3f7ff;
    }

    /* === Centered Elements === */
    .center {
      text-align: center;
    }

    /* === Buttons === */
    button {
      background: #0d6efd;
      color: white;
      border: none;
      padding: 10px 25px;
      border-radius: 8px;
      font-size: 15px;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    button:hover {
      background: #0b5ed7;
      transform: scale(1.05);
    }

    input[type="number"] {
      padding: 8px;
      border-radius: 6px;
      border: 1px solid #ccc;
      width: 50%;
      transition: all 0.3s ease;
      font-size: 15px;
    }

    input[type="number"]:focus {
      border-color: #0d6efd;
      box-shadow: 0 0 6px rgba(13, 110, 253, 0.3);
      outline: none;
    }

    label {
      font-size: 15px;
      color: #333;
      font-weight: 500;
    }

    /* === Error Message === */
    .error {
      color: #842029;
      background: #f8d7da;
      border: 1px solid #f5c2c7;
      border-radius: 8px;
      padding: 10px;
      margin-bottom: 20px;
      text-align: center;
      font-weight: 500;
      animation: fadeIn 1s ease;
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
  </style>
</head>
<body>

<div class="card">
  <h1>Dey & Sons Pvt. Ltd.</h1>
  <h3>Employee Payslip</h3>

  <% 
    String error = request.getParameter("error");
    if (error != null) { 
  %>
    <div class="error">Error: <%= error %></div>
  <% } else if (request.getAttribute("empId") == null) { %>
    <form action="GeneratePayslipServlet" method="post" class="center">
      <label>Enter Employee ID:</label><br><br>
      <input type="number" name="empId" required placeholder="Employee ID"><br><br>
      <button type="submit">Generate Payslip</button>
    </form>
  <% } else { %>

    <table>
      <tr><th>Employee ID</th><td><%= request.getAttribute("empId") %></td></tr>
      <tr><th>Name</th><td><%= request.getAttribute("name") %></td></tr>
      <tr><th>Department</th><td><%= request.getAttribute("department") %></td></tr>
      <tr><th>Designation</th><td><%= request.getAttribute("designation") %></td></tr>
      <tr><th>Basic Salary</th><td>₹<%= request.getAttribute("basicSalary") %></td></tr>
      <tr><th>Allowance</th><td>₹<%= request.getAttribute("allowance") %></td></tr>
      <tr><th>Deduction</th><td>₹<%= request.getAttribute("deduction") %></td></tr>
      <tr class="total"><th>Total Salary</th><td>₹<%= request.getAttribute("totalSalary") %></td></tr>
    </table>

    <div class="center">
      <button onclick="window.print()">Print / Download PDF</button>
    </div>
  <% } %>
</div>

</body>
</html>
