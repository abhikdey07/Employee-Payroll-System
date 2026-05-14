<%@ page contentType="text/html;charset=UTF-8" %>
<%
  String user = (String)session.getAttribute("username");
  if (user == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
  <title>EMPLOYEE PAYROLL SYSTEM</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <div class="topbar">
    <h1>EMPLOYEE PAYROLL SYSTEM</h1>
    <div class="spacer"></div>
    <a class="btn secondary" href="dashboard.jsp">HOME</a>
    <a class="btn secondary" href="dashboard.jsp">EMPLOYEE MANAGER</a>
    <a class="btn warn" href="LogoutServlet">LOG OUT</a>
  </div>

  <div class="page">
    <h2 class="center">Employee Manager</h2>
    <div class="card-grid">
      <a class="card add" href="addEmployee.jsp"><h2>ADD NEW EMPLOYEE</h2><p>Click this button to add new employee</p></a>
      <a class="card search" href="searchEmployee.jsp"><h2>SEARCH EMPLOYEE</h2><p>Click this button to search and delete employee</p></a>
      <a class="card allow" href="manageAllowance.jsp"><h2>MANAGE EMPLOYEE ALLOWANCE</h2><p>Manage employee allowance</p></a>
      <a class="card update" href="updateSalary.jsp"><h2>UPDATE EMPLOYEE SALARY</h2><p>Update the employee salary</p></a>
      <a class="card deduct" href="manageDeduction.jsp"><h2>EMPLOYEE DEDUCTION</h2><p>Update employee deduction</p></a>
      <a class="card slip" href="payslip.jsp"><h2>PRINT EMPLOYEE PAYMENT RECEIPT</h2><p>Generate PDF payslip</p></a>
    </div>
  </div>
</body>
</html>
