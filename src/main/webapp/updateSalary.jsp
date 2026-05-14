<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Update Employee Salary | Payroll System</title>
  <link rel="stylesheet" href="css/style.css">
  <style>
    /* === Base styling === */
    body {
      background: linear-gradient(135deg, #eaf2ff, #f8faff);
      font-family: 'Poppins', sans-serif;
      margin: 0;
      padding: 0;
      animation: fadeInBody 1s ease-in;
    }

    /* === Top Bar === */
    .topbar {
      background: #0d6efd;
      color: white;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 14px 40px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      font-weight: 600;
    }

    .topbar h1 {
      margin: 0;
      font-size: 22px;
    }

    .btn.secondary {
      background: #495057;
      color: #fff;
      border: none;
      border-radius: 8px;
      padding: 8px 16px;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .btn.secondary:hover {
      background: #343a40;
      transform: scale(1.05);
    }

    /* === Page Wrapper === */
    .page {
      display: flex;
      justify-content: center;
      align-items: flex-start;
      min-height: calc(100vh - 80px);
      padding-top: 40px;
    }

    /* === Main Form Card === */
    .panel {
      background: rgba(255, 255, 255, 0.95);
      padding: 40px;
      border-radius: 16px;
      width: 650px;
      box-shadow: 0 6px 25px rgba(0,0,0,0.1);
      backdrop-filter: blur(8px);
      animation: slideUp 0.8s ease;
    }

    h2 {
      text-align: center;
      color: #0d6efd;
      margin-bottom: 25px;
      font-size: 24px;
      font-weight: 600;
      animation: fadeIn 1s ease;
    }

    /* === Form Layout === */
    .form-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 18px;
      gap: 12px;
    }

    .form-row div {
      flex: 1;
      text-align: left;
    }

    label {
      font-weight: 500;
      display: block;
      margin-bottom: 6px;
      color: #495057;
    }

    input, select {
      width: 100%;
      padding: 10px;
      border: 1px solid #d0d7e2;
      border-radius: 8px;
      font-size: 14px;
      transition: all 0.3s ease;
      background-color: #f8faff;
    }

    input:focus, select:focus {
      border-color: #0d6efd;
      box-shadow: 0 0 6px rgba(13, 110, 253, 0.3);
      outline: none;
      background-color: #fff;
    }

    /* === Button Styles === */
    .btn-row {
      text-align: center;
      margin-top: 25px;
      animation: fadeIn 1.2s ease;
    }

    .btn {
      padding: 10px 25px;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      font-weight: 600;
      font-size: 15px;
      transition: all 0.3s ease;
      margin: 0 8px;
    }

    .btn.primary {
      background-color: #198754;
      color: white;
    }

    .btn.primary:hover {
      background-color: #157347;
      transform: scale(1.05);
    }

    .btn.calculate {
      background-color: #6c757d;
      color: white;
    }

    .btn.calculate:hover {
      background-color: #5c636a;
      transform: scale(1.05);
    }

    /* === Result Panel === */
    .result-panel {
      background: rgba(248, 249, 250, 0.8);
      border-radius: 12px;
      padding: 15px 20px;
      margin-top: 20px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
      text-align: center;
      font-weight: 500;
      color: #333;
      animation: fadeIn 1s ease;
    }

    .result-panel b {
      color: #0d6efd;
      font-size: 18px;
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
  <div class="topbar">
    <h1>Payroll System</h1>
    <a class="btn secondary" href="adminDashboard.jsp">Back</a>
  </div>

  <div class="page">
    <div class="panel">
      <h2>Update Employee Salary</h2>
      <form action="UpdateSalaryServlet" method="post">
        <div class="form-row">
          <div>
            <label>Search Employee ID</label>
            <input type="number" name="emp_id" value="<%= request.getParameter("empId")==null?1:request.getParameter("empId") %>">
          </div>
          <div>
            <label>Basic Salary</label>
            <input type="number" name="basic_salary" value="<%= request.getParameter("basic")==null?50000:request.getParameter("basic") %>">
          </div>
        </div>

        <div class="form-row">
          <div>
            <label>Update Salary By</label>
            <select name="mode">
              <option value="percent">Percentage (%)</option>
              <option value="amount">Amount</option>
            </select>
          </div>
          <div>
            <label>Value</label>
            <input type="number" step="0.01" name="value" value="10">
          </div>
        </div>

        <div class="btn-row">
          <button class="btn calculate" type="submit">Calculate / Update</button>
          <a class="btn primary" href="updateSalary.jsp?empId=<%= request.getParameter("empId")==null?1:request.getParameter("empId") %>&basic=<%= request.getParameter("newSalary")==null?50000:request.getParameter("newSalary") %>">Refresh</a>
        </div>

        <div class="result-panel">
          Salary after Update: <b><%= request.getParameter("newSalary")==null? "" : request.getParameter("newSalary") %></b>
        </div>
      </form>
    </div>
  </div>
</body>
</html>
