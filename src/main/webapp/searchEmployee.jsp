<%@ page import="java.sql.*" %>
<%@ page import="model.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Employees | Payroll System</title>
    <style>
        /* ---------- GLOBAL STYLES ---------- */
        body {
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(135deg, #eef3ff, #f5f7fb);
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        .container {
            width: 85%;
            margin: 50px auto;
            background: #ffffff;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            animation: fadeIn 1s ease;
        }

        h2 {
            color: #0a66c2;
            text-align: center;
            margin-bottom: 25px;
            font-size: 28px;
            letter-spacing: 1px;
        }

        /* ---------- SEARCH BAR ---------- */
        .search-bar {
            text-align: center;
            margin-top: 10px;
            animation: slideDown 0.8s ease;
        }

        input[type="text"] {
            width: 45%;
            padding: 10px 12px;
            border-radius: 8px;
            border: 1px solid #cdd6f3;
            box-shadow: inset 0 1px 2px rgba(0,0,0,0.1);
            transition: 0.3s;
        }

        input[type="text"]:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 8px rgba(0,123,255,0.3);
        }

        button {
            padding: 10px 18px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            margin-left: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        button:hover {
            background: #0056c9;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,123,255,0.3);
        }

        /* ---------- TABLE ---------- */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
            border-radius: 12px;
            overflow: hidden;
            animation: fadeInUp 0.9s ease;
        }

        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #e3e9f7;
        }

        th {
            background: #007bff;
            color: white;
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        tr {
            transition: 0.3s;
        }

        tr:hover {
            background: #f1f6ff;
            transform: scale(1.005);
        }

        /* ---------- DELETE BUTTON ---------- */
        .btn-delete {
            background: #dc3545;
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
            font-weight: 500;
        }

        .btn-delete:hover {
            background: #b02a37;
            transform: scale(1.05);
            box-shadow: 0 4px 8px rgba(220,53,69,0.3);
        }

        /* ---------- ALERT MESSAGES ---------- */
        .msg-success, .msg-error {
            width: 70%;
            margin: 15px auto;
            padding: 12px;
            border-radius: 8px;
            text-align: center;
            font-weight: 600;
            animation: fadeIn 0.8s ease, slideUp 0.6s ease;
        }

        .msg-success {
            background-color: #e7f9ee;
            color: #157347;
            border: 1px solid #b4e2c3;
        }

        .msg-error {
            background-color: #fde2e2;
            color: #842029;
            border: 1px solid #f5c2c7;
        }

        /* ---------- ANIMATIONS ---------- */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-15px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes slideUp {
            from { transform: translateY(10px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        /* Fade-out animation for delete row */
        .fade-out {
            animation: fadeOut 0.6s forwards;
        }

        @keyframes fadeOut {
            from { opacity: 1; transform: scale(1); }
            to { opacity: 0; transform: scale(0.98); }
        }
    </style>
</head>

<body>
<div class="container">
    <h2>Search Employee</h2>

    <%-- Message Display Section --%>
    <%
        String msg = request.getParameter("deleted");
        if ("1".equals(msg)) {
    %>
        <div class="msg-success">Employee deleted successfully.</div>
    <% } else if ("0".equals(msg)) { %>
        <div class="msg-error">Failed to delete employee. Please try again.</div>
    <% } %>

    <form method="get" action="searchEmployee.jsp" class="search-bar">
        <input type="text" name="search" placeholder="Enter employee first name, last name, or department" required>
        <button type="submit">Search</button>
    </form>

    <%
        String search = request.getParameter("search");
        if (search != null && !search.trim().isEmpty()) {
            try {
                Connection con = DatabaseConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM employee WHERE firstname LIKE ? OR lastname LIKE ? OR department LIKE ?"
                );
                ps.setString(1, "%" + search + "%");
                ps.setString(2, "%" + search + "%");
                ps.setString(3, "%" + search + "%");
                ResultSet rs = ps.executeQuery();
    %>

    <table>
        <tr>
            <th>ID</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Department</th>
            <th>Designation</th>
            <th>Hire Date</th>
            <th>Basic Salary</th>
            <th>Job Title</th>
            <th>Email</th>
            <th>Contact</th>
            <th>Action</th>
        </tr>

        <%
            boolean hasResults = false;
            while (rs.next()) {
                hasResults = true;
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("firstname") %></td>
            <td><%= rs.getString("lastname") %></td>
            <td><%= rs.getString("department") %></td>
            <td><%= rs.getString("designation") %></td>
            <td><%= rs.getString("hire_date") %></td>
            <td><%= rs.getString("basic_salary") %></td>
            <td><%= rs.getString("job_title") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("contact") %></td>
            <td>
                <form action="DeleteEmployeeServlet" method="post" style="display:inline;">
                    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                    <button type="submit" class="btn-delete">Delete</button>
                </form>
            </td>
        </tr>
        <%
            }
            if (!hasResults) {
        %>
        <tr><td colspan="11" style="color:red; font-weight:600;">No employee found with that name or department.</td></tr>
        <%
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            out.print("<div class='msg-error'>Error: " + e.getMessage() + "</div>");
        }
    }
    %>
    </table>
</div>

<script>
document.addEventListener("DOMContentLoaded", () => {
  const deleteButtons = document.querySelectorAll(".btn-delete");
  deleteButtons.forEach(btn => {
    btn.addEventListener("click", function(event) {
      const row = this.closest("tr");
      if (confirm("Are you sure you want to permanently delete this employee?")) {
        row.classList.add("fade-out");
        setTimeout(() => {
          this.closest("form").submit();
        }, 600);
      }
      event.preventDefault();
    });
  });
});
</script>
</body>
</html>
