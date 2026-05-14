<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Manage Employee Deduction | Payroll System</title>
  <link rel="stylesheet" href="css/style.css">
  <style>
    /* === Base Styles === */
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

    /* === Page Layout === */
    .page {
      display: flex;
      justify-content: center;
      align-items: flex-start;
      min-height: calc(100vh - 80px);
      padding-top: 40px;
    }

    /* === Form Panel === */
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

    /* === Form Structure === */
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

    /* === Buttons === */
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

    .btn.secondary {
      background-color: #6c757d;
      color: white;
    }

    .btn.secondary:hover {
      background-color: #5c636a;
      transform: scale(1.05);
    }

    /* === Success / Error Messages === */
    .success, .error {
      text-align: center;
      font-weight: 500;
      padding: 10px;
      border-radius: 6px;
      animation: fadeIn 0.8s ease;
    }

    .success {
      background-color: #d1e7dd;
      color: #0f5132;
      border: 1px solid #badbcc;
      margin-bottom: 20px;
    }

    .error {
      background-color: #f8d7da;
      color: #842029;
      border: 1px solid #f5c2c7;
      margin-bottom: 20px;
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

  <script>
    function calculateDeduction() {
      const mode = document.getElementById("mode").value;
      const percentage = parseFloat(document.getElementById("percentage").value) || 0;
      const basicSalary = parseFloat(document.getElementById("basicSalary").value) || 0;
      const amountField = document.getElementById("amount");

      if (mode === "percent" && basicSalary > 0) {
        const amount = (basicSalary * percentage) / 100;
        amountField.value = amount.toFixed(2);
      }
    }

    function toggleFields() {
      const mode = document.getElementById("mode").value;
      document.getElementById("percentage").disabled = (mode !== "percent");
      document.getElementById("amount").disabled = (mode !== "amount");
    }
  </script>
</head>

<body>
  <div class="topbar">
    <h1>Payroll System</h1>
    <a class="btn secondary" href="adminDashboard.jsp">Back</a>
  </div>

  <div class="page">
    <div class="panel">
      <h2>Manage Employee Deduction</h2>

      <% 
        String success = request.getParameter("success");
        if ("1".equals(success)) { 
      %>
        <p class="success">Deduction updated successfully!</p>
      <% 
        } else if ("0".equals(success)) { 
      %>
        <p class="error">Error updating deduction. Please try again.</p>
      <% } %>

      <form action="ManageDeductionServlet" method="post">
        <div class="form-row">
          <div>
            <label>Employee ID</label>
            <input type="number" name="emp_id" required 
                   value="<%= request.getParameter("empId")==null?1:request.getParameter("empId") %>">
          </div>
          <div>
            <label>Basic Salary</label>
            <input type="number" id="basicSalary" name="basic_salary" placeholder="Enter Basic Salary" required>
          </div>
        </div>

        <div class="form-row">
          <div>
            <label>Deduct Salary by</label>
            <select id="mode" name="mode" onchange="toggleFields()" required>
              <option value="percent">Percentage (%)</option>
              <option value="amount">Amount</option>
            </select>
          </div>
          <div>
            <label>Percentage (%)</label>
            <input type="number" id="percentage" name="percentage" step="0.01" value="0" oninput="calculateDeduction()">
          </div>
        </div>

        <div class="form-row">
          <div>
            <label>Amount</label>
            <input type="number" id="amount" name="amount" step="0.01" value="0">
          </div>
          <div>
            <label>Reason</label>
            <input type="text" name="reason" placeholder="Reason for deduction">
          </div>
        </div>

        <div class="btn-row">
          <button class="btn primary" type="submit">Save</button>
          <button class="btn secondary" type="reset">Clear</button>
        </div>
      </form>
    </div>
  </div>
</body>
</html>
