<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Payroll System | LOG IN</title>
  <link rel="stylesheet" href="css/style.css">
  <style>
    /* ===== Background & Layout ===== */
    body {
      margin: 0;
      padding: 0;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      font-family: "Poppins", sans-serif;
      background: linear-gradient(135deg, #c3e8f3, #f9e6cf);
      /* soft pastel gradient */
    }

    /* ===== Login Card ===== */
    .login-wrap {
      background: #ffffff;
      padding: 45px 55px;
      border-radius: 18px;
      box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
      text-align: center;
      width: 400px;
      transition: all 0.3s ease;
      animation: fadeIn 0.9s ease;
    }

    .login-wrap:hover {
      transform: translateY(-4px);
      box-shadow: 0 12px 35px rgba(0, 0, 0, 0.2);
    }

    /* ===== Welcome Message ===== */
    .welcome-text {
      font-size: 18px;
      color: #333;
      font-weight: 600;
      margin-bottom: 8px;
      line-height: 1.5;
      animation: slideDown 1s ease;
    }

    .company-name {
      color: #0a66c2;
      font-weight: 700;
      font-size: 20px;
    }

    /* ===== Title ===== */
    h2 {
      font-size: 22px;
      color: #444;
      margin-top: 10px;
      margin-bottom: 25px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      animation: fadeIn 1.2s ease;
    }

    /* ===== Input & Select ===== */
    label {
      display: block;
      text-align: left;
      font-size: 14px;
      margin-bottom: 6px;
      color: #555;
      font-weight: 500;
    }

    input, select {
      width: 100%;
      padding: 10px 12px;
      margin-bottom: 15px;
      border: 1px solid #ccc;
      border-radius: 8px;
      font-size: 14px;
      outline: none;
      background: #fafafa;
      transition: 0.3s;
    }

    input:focus, select:focus {
      border-color: #8ecae6;
      box-shadow: 0 0 6px rgba(142, 202, 230, 0.6);
      background: #fff;
    }

    /* ===== Button ===== */
    .btn.primary {
      width: 100%;
      padding: 12px;
      background: linear-gradient(90deg, #8ecae6, #219ebc);
      color: white;
      font-weight: bold;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      font-size: 15px;
      letter-spacing: 0.5px;
      transition: all 0.3s;
    }

    .btn.primary:hover {
      background: linear-gradient(90deg, #219ebc, #023047);
      transform: scale(1.03);
    }

    /* ===== Error Message ===== */
    .small {
      color: #c00;
      font-size: 13px;
      margin-top: 10px;
    }

    /* ===== Footer ===== */
    .footer-text {
      margin-top: 18px;
      font-size: 13px;
      color: #666;
      letter-spacing: 0.3px;
      animation: fadeIn 1s ease;
    }

    .footer-text span {
      color: #219ebc;
      font-weight: 600;
    }

    /* ===== Animations ===== */
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    @keyframes slideDown {
      from { opacity: 0; transform: translateY(-15px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>

<body>
  <div class="login-wrap">
    <!-- Welcome Section -->
    <div class="welcome-text">
      Welcome to the Employee Payroll System of<br>
      <span class="company-name">Dey & Sons Private Limited</span>
    </div>

    <!-- Login Heading -->
    <h2>LOG IN</h2>

    <!-- Login Form -->
    <form action="LoginServlet" method="post" autocomplete="off">
      <div class="form-row">
        <label>User level</label>
        <select name="userlevel" required>
          <option value="">Select User Level</option>
          <option value="Admin">Admin</option>
        </select>
      </div>

      <div class="form-row">
        <label>Username</label>
        <input type="text" name="username" placeholder="Enter your username" autocomplete="new-username" required>
      </div>

      <div class="form-row">
        <label>Password</label>
        <input type="password" name="password" placeholder="Enter your password" autocomplete="new-password" required>
      </div>

      <button class="btn primary" type="submit">LOG IN AS ADMIN</button>

      <div class="small">
        <%
          String err = (String) request.getAttribute("error");
          if (err != null) { out.print(err); }
        %>
      </div>
    </form>

    <div class="footer-text">
      Developed by <span>Abhik Dey</span>
    </div>
  </div>
</body>
</html>
