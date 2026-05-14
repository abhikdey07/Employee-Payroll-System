<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>ADD EMPLOYEE</title>
  <link rel="stylesheet" href="css/style.css">
  <style>
    /* ========= Base Page Styling ========= */
    body {
      margin: 0;
      font-family: "Poppins", sans-serif;
      background: linear-gradient(135deg, #c3e8f3, #f9e6cf);
      color: #333;
      animation: fadeIn 0.8s ease-in-out;
    }

    /* ========= Top Bar ========= */
    .topbar {
      background: linear-gradient(90deg, #8ecae6, #219ebc);
      color: #fff;
      padding: 16px 30px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-weight: 600;
      box-shadow: 0 3px 10px rgba(0, 0, 0, 0.15);
    }

    .topbar h1 {
      margin: 0;
      font-size: 22px;
      letter-spacing: 0.5px;
    }

    .btn {
      background: #fff;
      color: #219ebc;
      padding: 10px 20px;
      border-radius: 10px;
      border: none;
      cursor: pointer;
      font-weight: 600;
      text-decoration: none;
      transition: 0.3s;
    }

    .btn:hover {
      background: #f0f0f0;
      transform: scale(1.05);
    }

    /* ========= Main Container ========= */
    .page {
      display: flex;
      justify-content: center;
      align-items: flex-start;
      padding: 50px 20px;
    }

    .panel {
      background: rgba(255, 255, 255, 0.95);
      padding: 45px 50px;
      border-radius: 20px;
      width: 80%;
      max-width: 900px;
      box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
      backdrop-filter: blur(10px);
      animation: slideUp 0.8s ease-out;
    }

    .panel h2 {
      text-align: center;
      font-size: 26px;
      color: #023047;
      margin-bottom: 25px;
    }

    /* ========= Success & Error Alerts ========= */
    .alert-success, .alert-error {
      padding: 12px;
      border-radius: 8px;
      text-align: center;
      font-weight: 500;
      margin-bottom: 20px;
      animation: fadeIn 1s ease;
    }

    .alert-success {
      background-color: #d4edda;
      color: #155724;
      border: 1px solid #c3e6cb;
    }

    .alert-error {
      background-color: #f8d7da;
      color: #721c24;
      border: 1px solid #f5c6cb;
    }

    /* ========= Form Layout ========= */
    form {
      display: flex;
      flex-direction: column;
      gap: 18px;
    }

    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
    }

    label {
      display: block;
      font-weight: 500;
      color: #555;
      margin-bottom: 6px;
      font-size: 14px;
    }

    input, select {
      width: 100%;
      padding: 10px 12px;
      border-radius: 10px;
      border: 1px solid #ccc;
      background: #fafafa;
      font-size: 14px;
      transition: 0.3s;
    }

    input:focus, select:focus {
      border-color: #8ecae6;
      box-shadow: 0 0 6px rgba(142, 202, 230, 0.6);
      background: #fff;
      outline: none;
    }

    /* ========= Buttons ========= */
    .btn-row {
      display: flex;
      justify-content: center;
      gap: 15px;
      margin-top: 25px;
    }

    .btn.primary {
      background: linear-gradient(90deg, #8ecae6, #219ebc);
      color: white;
      border: none;
      padding: 12px 28px;
      font-size: 15px;
      border-radius: 10px;
      transition: all 0.3s ease;
    }

    .btn.primary:hover {
      transform: translateY(-3px);
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
    }

    /* ========= Animations ========= */
    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
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
    <a class="btn" href="adminDashboard.jsp">Back</a>
  </div>

  <div class="page">
    <div class="panel">
      <h2>ADD EMPLOYEE</h2>

      <!-- ✅ Success or Error Messages -->
      <%
        String success = request.getParameter("success");
        if ("1".equals(success)) {
      %>
        <div class="alert-success">✅ Employee details added successfully!</div>
      <%
        } else if ("0".equals(success)) {
      %>
        <div class="alert-error">❌ Error adding employee. Please try again.</div>
      <%
        }
      %>

      <!-- ====== Add Employee Form ====== -->
      <form action="AddEmployeeServlet" method="post">
        <div class="form-row">
          <div><label>First name</label><input name="firstname" required></div>
          <div><label>Surname</label><input name="lastname" required></div>
        </div>

        <div class="form-row">
          <div><label>Date of Birth</label><input type="date" name="dob" required></div>
          <div><label>Gender</label>
            <select name="gender">
              <option>Male</option>
              <option>Female</option>
              <option>Transgender</option>
            </select>
          </div>
        </div>

        <div class="form-row">
          <div><label>Email</label><input name="email"></div>
          <div><label>Contact</label><input name="contact"></div>
        </div>

        <div class="form-row">
          <div><label>Address Line 1</label><input name="address1"></div>
          <div><label>Address Line 2</label><input name="address2"></div>
        </div>

        <div class="form-row">
          <div><label>Apt./House No</label><input name="house_no"></div>
          <div><label>Postal Code</label><input name="postal_code"></div>
        </div>

        <div class="form-row">
          <div><label>Department</label><input name="department"></div>
          <div><label>Designation</label><input name="designation"></div>
        </div>

        <div class="form-row">
          <div><label>Status</label><input name="status" value="Hired"></div>
          <div><label>Date Hired</label><input type="date" name="hire_date" required></div>
        </div>

        <div class="form-row">
          <div><label>Basic Salary</label><input type="number" name="basic_salary" required></div>
          <div><label>Job Title</label><input name="job_title"></div>
        </div>

        <div class="btn-row">
          <button class="btn primary" type="submit">Add Record</button>
          <button class="btn" type="reset">Clear</button>
        </div>
      </form>
    </div>
  </div>
</body>
</html>
