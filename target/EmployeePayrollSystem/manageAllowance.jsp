<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Manage Employee Allowance | Payroll System</title>
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

    input {
      width: 100%;
      padding: 10px;
      border: 1px solid #d0d7e2;
      border-radius: 8px;
      font-size: 14px;
      transition: all 0.3s ease;
      background-color: #f8faff;
    }

    input:focus {
      border-color: #0d6efd;
      box-shadow: 0 0 6px rgba(13, 110, 253, 0.3);
      outline: none;
      background-color: #fff;
    }

    /* === Button Row === */
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
      background-color: #0d6efd;
      color: white;
    }

    .btn.primary:hover {
      background-color: #0b5ed7;
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

    /* === Success/Error Messages === */
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
    function calculateOvertime() {
      const overtime = parseFloat(document.getElementById("overtime").value) || 0;
      const rph = parseFloat(document.getElementById("rphRate").value) || 0;
      document.getElementById("totalOvertimeRate").value = (overtime * rph).toFixed(2);
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
      <h2>Manage Employee Allowance</h2>

      <% if (request.getParameter("success") != null) { %>
        <p class="success">Allowance saved successfully!</p>
      <% } else if (request.getParameter("error") != null) { %>
        <p class="error">Error saving allowance. Please check Employee ID.</p>
      <% } %>

      <form action="ManageAllowanceServlet" method="post">
        <div class="form-row">
          <div>
            <label>Employee ID</label>
            <input type="number" name="emp_id" required>
          </div>
        </div>

        <div class="form-row">
          <div>
            <label>Overtime (Hours)</label>
            <input type="number" id="overtime" name="overtime" oninput="calculateOvertime()" required>
          </div>
          <div>
            <label>RPH Rate</label>
            <input type="number" id="rphRate" name="rphRate" oninput="calculateOvertime()" required>
          </div>
        </div>

        <div class="form-row">
          <div>
            <label>Medical Allowance</label>
            <input type="number" name="medical" required>
          </div>
          <div>
            <label>Bonus</label>
            <input type="number" name="bonus" required>
          </div>
        </div>

        <div class="form-row">
          <div>
            <label>Other Allowance</label>
            <input type="number" name="other" required>
          </div>
          <div>
            <label>Total Overtime Rate</label>
            <input type="number" id="totalOvertimeRate" name="totalOvertimeRate" readonly>
          </div>
        </div>

        <div class="btn-row">
          <button type="submit" class="btn primary">Save</button>
          <button type="reset" class="btn secondary">Clear</button>
        </div>
      </form>
    </div>
  </div>
</body>
</html>
