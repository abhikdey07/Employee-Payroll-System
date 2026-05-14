<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>EMPLOYEE PAYROLL SYSTEM | Dey & Sons Pvt. Ltd.</title>
  <link rel="stylesheet" href="css/style.css">
  <style>
    /* ===== Soft Modern Theme ===== */
    body {
      margin: 0;
      font-family: "Poppins", sans-serif;
      background: linear-gradient(135deg, #c3e8f3, #f9e6cf);
      color: #333;
      animation: fadeIn 0.8s ease-in-out;
    }

    /* ===== Top Bar ===== */
    .topbar {
      background: linear-gradient(90deg, #8ecae6, #219ebc);
      color: white;
      padding: 16px 30px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 3px 10px rgba(0,0,0,0.1);
    }

    .topbar h1 {
      margin: 0;
      font-size: 20px;
      letter-spacing: 0.5px;
      font-weight: 600;
    }

    .btn-logout {
      background: #fff;
      color: #219ebc;
      padding: 10px 20px;
      border-radius: 10px;
      border: none;
      cursor: pointer;
      font-weight: 600;
      transition: all 0.3s;
    }

    .btn-logout:hover {
      background: #f0f0f0;
      transform: scale(1.05);
    }

    /* ===== Page Content ===== */
    .page {
      text-align: center;
      padding: 40px;
    }

    h2 {
      font-weight: 700;
      font-size: 28px;
      color: #023047;
      margin-bottom: 30px;
    }

    /* ===== Grid Layout ===== */
    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 25px;
      justify-content: center;
      margin-top: 20px;
    }

    /* ===== Card Styles ===== */
    .card {
      border-radius: 15px;
      padding: 35px 25px;
      color: #fff;
      text-align: center;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.4s ease;
      box-shadow: 0 6px 20px rgba(0,0,0,0.1);
      background: rgba(255, 255, 255, 0.2);
      backdrop-filter: blur(10px);
      opacity: 0;
      animation: slideUp 0.7s ease forwards;
    }

    .card:hover {
      transform: translateY(-8px);
      box-shadow: 0 10px 25px rgba(0,0,0,0.2);
    }

    a.card-link {
      text-decoration: none;
      color: inherit;
      display: block;
    }

    h3 {
      margin: 12px 0 6px;
      font-size: 18px;
    }

    p {
      font-weight: normal;
      font-size: 14px;
      opacity: 0.9;
      margin: 0;
    }

    /* ===== Individual Card Colors (Soft Pastels) ===== */
    .card-blue { background: linear-gradient(135deg, #a2d2ff, #bde0fe); color: #023047; }
    .card-green { background: linear-gradient(135deg, #b9fbc0, #90f1ef); color: #023047; }
    .card-orange { background: linear-gradient(135deg, #ffdab9, #ffe5b4); color: #023047; }
    .card-gray { background: linear-gradient(135deg, #dee2e6, #ced4da); color: #023047; }
    .card-red { background: linear-gradient(135deg, #ffadad, #ffd6a5); color: #023047; }
    .card-purple { background: linear-gradient(135deg, #cdb4db, #ffc8dd); color: #023047; }
    .card-aqua { background: linear-gradient(135deg, #b5e48c, #76c893); color: #023047; }

    /* ===== Animations ===== */
    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(25px); }
      to { opacity: 1; transform: translateY(0); }
    }

    /* Staggered animation delays */
    .card:nth-child(1) { animation-delay: 0.2s; }
    .card:nth-child(2) { animation-delay: 0.4s; }
    .card:nth-child(3) { animation-delay: 0.6s; }
    .card:nth-child(4) { animation-delay: 0.8s; }
    .card:nth-child(5) { animation-delay: 1.0s; }
    .card:nth-child(6) { animation-delay: 1.2s; }
    .card:nth-child(7) { animation-delay: 1.4s; }

    /* ===== Footer ===== */
    .footer {
      margin-top: 40px;
      font-size: 13px;
      color: #555;
      text-align: center;
    }
    .footer span { color: #219ebc; font-weight: 600; }
  </style>

  <script>
    // Prevent caching when going back
    if (performance.navigation.type === 2) {
      location.reload(true);
    }
  </script>
</head>

<body>
  <div class="topbar">
    <h1>EMPLOYEE PAYROLL SYSTEM | <span style="font-weight:normal;">Dey & Sons Pvt. Ltd.</span></h1>
    <form action="LogoutServlet" method="post">
      <button class="btn-logout" type="submit">LOG OUT</button>
    </form>
  </div>

  <div class="page">
    <h2>Employee Manager</h2>
    <div class="grid">
      <div class="card card-blue">
        <a href="addEmployee.jsp" class="card-link">
          <h3>➕ ADD NEW EMPLOYEE</h3>
          <p>Click this button to add new employee</p>
        </a>
      </div>

      <div class="card card-green">
        <a href="searchEmployee.jsp" class="card-link">
          <h3>🔍 SEARCH EMPLOYEE</h3>
          <p>Search employee</p>
        </a>
      </div>

      <div class="card card-orange">
        <a href="manageAllowance.jsp" class="card-link">
          <h3>🤝 MANAGE EMPLOYEE ALLOWANCE</h3>
          <p>Add overtime/bonus/medical</p>
        </a>
      </div>

      <div class="card card-gray">
        <a href="updateSalary.jsp" class="card-link">
          <h3>🔁 UPDATE EMPLOYEE SALARY</h3>
          <p>Increase by % or amount</p>
        </a>
      </div>

      <div class="card card-red">
        <a href="manageDeduction.jsp" class="card-link">
          <h3>💸 EMPLOYEE DEDUCTION</h3>
          <p>Percentage or amount</p>
        </a>
      </div>

      <div class="card card-purple">
        <a href="payslip.jsp" class="card-link">
          <h3>🧾 PRINT EMPLOYEE PAYMENT RECEIPT</h3>
          <p>Generate & download PDF</p>
        </a>
      </div>

      <div class="card card-aqua">
        <a href="employeeReport.jsp" class="card-link">
          <h3>📘 PRINT EMPLOYEE REPORT</h3>
          <p>View & download all employee details</p>
        </a>
      </div>
    </div>

    <div class="footer">
      Developed by <span>Abhik Dey</span>
    </div>
  </div>
</body>
</html>
