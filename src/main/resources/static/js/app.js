// ===========================
// CONFIGURATION
// ===========================
const API = '/api';
let currentUser = null;
let sessionTimer = null;
let sessionRemaining = 1800; // 30 min
let toastCount = 0;

// ===========================
// UTILITY FUNCTIONS
// ===========================
function formatCurrency(amount) {
  return '₹' + Number(amount || 0).toLocaleString('en-IN', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  });
}

function formatDate(dateStr) {
  if (!dateStr) return '—';

  return new Date(dateStr).toLocaleDateString('en-IN', {
    day: '2-digit',
    month: 'short',
    year: 'numeric'
  });
}

const MONTHS = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

function getMonthName(num) {
  return MONTHS[num - 1] || '';
}

function refreshIcons() {
  if (window.lucide) {
    lucide.createIcons();
  }
}

// ===========================
// API HELPER
// ===========================
async function api(url, method = 'GET', body = null) {
  const options = { method, headers: {'Content-Type': 'application/json'}, credentials: 'same-origin' };
  if (body) options.body = JSON.stringify(body);
  try {
    const res = await fetch(API + url, options);
   if (res.status === 401) {

    // Only show "Session expired" if the user was actually logged in.
    // Ignore the initial session check and login failures.
    if (
        currentUser &&
        url !== '/auth/login' &&
        url !== '/auth/session'
    ) {
        handleSessionExpired();
    }

    const contentType = res.headers.get('content-type');

    if (contentType && contentType.includes('application/json')) {
        const data = await res.json();
        throw new Error(data.message || data.error || 'Unauthorized');
    }

    throw new Error('Unauthorized');
}
    const contentType = res.headers.get('content-type');
    if (contentType && contentType.includes('application/json')) {
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || data.message || 'Request failed');
      return data;
    }
    if (!res.ok) throw new Error('Request failed');
    return res;
  } catch (err) {
    throw err;
  }
}

/// ===========================
// TOAST NOTIFICATIONS
// ===========================
function showToast(message, type = 'info', duration = 4000) {
  const container = document.getElementById('toast-container');
  const toast = document.createElement('div');

  toast.className = `toast toast-${type}`;
  toast.id = `toast-${toastCount++}`;

  const icons = {
    success: '<i data-lucide="check-circle"></i>',
    error: '<i data-lucide="circle-x"></i>',
    warning: '<i data-lucide="triangle-alert"></i>',
    info: '<i data-lucide="info"></i>'
  };

  toast.innerHTML = `
    <div class="toast-icon">${icons[type]}</div>
    <div class="toast-content">${message}</div>
    <button class="toast-close">✕</button>
    <div class="toast-progress" style="animation: progressBar ${duration}ms linear forwards;"></div>
  `;

  container.appendChild(toast);

  refreshIcons();

  const closeBtn = toast.querySelector('.toast-close');
  let timeout;

  const removeToast = () => {
    toast.classList.add('hiding');
    setTimeout(() => {
      if (toast.parentElement) toast.remove();
    }, 300);
  };

  closeBtn.onclick = () => {
    clearTimeout(timeout);
    removeToast();
  };

  timeout = setTimeout(removeToast, duration);
}
// ===========================
// ===========================
// MODAL SYSTEM
// ===========================
function showModal(title, contentHTML, actions = []) {
  const overlay = document.getElementById('modal-overlay');

  document.getElementById('modal-title').textContent = title;
  document.getElementById('modal-body').innerHTML = contentHTML;

  const footer = document.getElementById('modal-footer');
  footer.innerHTML = '';

  actions.forEach(act => {
    const btn = document.createElement('button');

    btn.className = `btn ${act.class || 'btn-outline'}`;
    btn.textContent = act.label;

    btn.onclick = () => {
      act.onClick();
      hideModal();
    };

    footer.appendChild(btn);
  });

  refreshIcons();

  document.getElementById('modal-close').onclick = hideModal;

  overlay.style.display = 'flex';
}

function hideModal() {
  document.getElementById('modal-overlay').style.display = 'none';
}

function showConfirm(message, onConfirm) {
  showModal('Confirm Action', `<p>${message}</p>`, [
    {
      label: 'Cancel',
      class: 'btn-outline',
      onClick: () => {}
    },
    {
      label: 'Confirm',
      class: 'btn-primary',
      onClick: onConfirm
    }
  ]);
}

// ===========================
// SESSION MANAGEMENT
// ===========================
function startSessionTimer() {
  sessionRemaining = 1800;
  clearInterval(sessionTimer);

  sessionTimer = setInterval(() => {
    sessionRemaining--;
    updateSessionDisplay();

    if (sessionRemaining === 300) {
      showToast('Session expires in 5 minutes', 'warning');
    }

    if (sessionRemaining <= 0) {
      handleSessionExpired();
    }
  }, 1000);
}

function updateSessionDisplay() {
  const el = document.getElementById('session-timer');

  if (!el) return;

  const min = Math.floor(sessionRemaining / 60);
  const sec = sessionRemaining % 60;

  el.textContent = `${min}:${sec.toString().padStart(2, '0')}`;
}

function resetSessionTimer() {
  if (currentUser) {
    sessionRemaining = 1800;
  }
}

function handleSessionExpired() {
  clearInterval(sessionTimer);
  currentUser = null;

  showToast('Session expired. Please login again.', 'error');

  renderApp();
}

// ===========================
// AUTHENTICATION
// ===========================
async function checkSession() {
  try {
    const data = await api('/auth/session');

    if (data && data.authenticated) {
      currentUser = data.username;
      return true;
    }
  } catch (e) {}

  currentUser = null;
  return false;
}

async function handleLogin(e) {
  e.preventDefault();

  const btn = e.target.querySelector('button[type=submit]');
  const username = document.getElementById('login-username').value.trim();
  const password = document.getElementById('login-password').value;

  if (!username || !password) {
    showToast('Please enter username and password', 'warning');
    return;
  }

  btn.classList.add('loading');
  btn.disabled = true;

  try {
    const data = await api('/auth/login', 'POST', { username, password });

    currentUser = data.username || username;

    showToast(`Welcome back, ${currentUser}!`, 'success');

    startSessionTimer();

    renderApp();

  } catch (err) {
    showToast(err.message || 'Login failed', 'error');

  } finally {
    btn.classList.remove('loading');
    btn.disabled = false;
  }
}

async function handleLogout() {
  showConfirm('Are you sure you want to logout?', async () => {
    try {
      await api('/auth/logout', 'POST');

      clearInterval(sessionTimer);
      currentUser = null;

      showToast('Logged out successfully', 'info');

      renderApp();

    } catch (err) {
      showToast('Logout failed', 'error');
    }
  });
}

// ===========================
// NAVIGATION / ROUTING
// ===========================
function navigate(page) {
  window.location.hash = page;
}

function getRoute() {
  return window.location.hash.slice(1) || 'dashboard';
}

async function handleRoute() {
  if (!currentUser) return;

  const route = getRoute();

  resetSessionTimer();

  const content = document.getElementById('page-content');

  if (!content) return;

  content.classList.add('page-exit');

  await new Promise(r => setTimeout(r, 150));

  document.querySelectorAll('.nav-item')
    .forEach(el => el.classList.remove('active'));

  const activeNav = document.querySelector(
    `[data-page="${route.split('/')[0]}"]`
  );

  if (activeNav) {
    activeNav.classList.add('active');
  }

  try {
    if (route === 'dashboard') {
      await renderDashboard();
    } else if (route === 'employees') {
      await renderEmployees();
    } else if (route === 'add-employee') {
      await renderEmployeeForm();
    } else if (route === 'payslips') {
      await renderPayslips();
    } else if (route === 'generate-payslip') {
      await renderGeneratePayslip();
    } else if (route.startsWith('edit-employee/')) {
      await renderEmployeeForm(route.split('/')[1]);
    } else if (route.startsWith('view-payslip/')) {
      await renderViewPayslip(route.split('/')[1]);
    } else {
      await renderDashboard();
    }

  } catch (e) {
    console.error(e);

    content.innerHTML = `
      <div class="empty-state">
        <h2>Error Loading Page</h2>
        <p>${e.message}</p>
      </div>
    `;

    refreshIcons();
  }

  content.classList.remove('page-exit');
  content.classList.add('page-enter');

  setTimeout(() => {
    content.classList.remove('page-enter');
  }, 300);
}
// ===========================
// DASHBOARD PAGE
// ===========================
async function renderDashboard() {
  const content = document.getElementById('page-content');

  content.innerHTML = `
    <h1 class="page-title">Dashboard</h1>
    <div class="stats-grid">
      ${'<div class="stat-card skeleton-card skeleton"></div>'.repeat(4)}
    </div>
  `;

  refreshIcons();

  try {
    const stats = await api('/dashboard/stats');

    content.innerHTML = `
      <h1 class="page-title">Dashboard</h1>

      <div class="stats-grid">

        <div class="stat-card card-blue">
          <div class="stat-icon">
            <i data-lucide="users"></i>
          </div>
          <div class="stat-value" data-count="${stats.totalEmployees || 0}">0</div>
          <div class="stat-label">Total Employees</div>
        </div>

        <div class="stat-card card-emerald">
          <div class="stat-icon">
            <i data-lucide="check-circle"></i>
          </div>
          <div class="stat-value" data-count="${stats.activeEmployees || 0}">0</div>
          <div class="stat-label">Active Employees</div>
        </div>

        <div class="stat-card card-purple">
          <div class="stat-icon">
            <i data-lucide="building-2"></i>
          </div>
          <div class="stat-value" data-count="${stats.departmentCount || 0}">0</div>
          <div class="stat-label">Departments</div>
        </div>

        <div class="stat-card card-amber">
          <div class="stat-icon">
            <i data-lucide="wallet"></i>
          </div>
          <div class="stat-value money" data-count="${stats.totalPayrollThisMonth || 0}">
            ₹0
          </div>
          <div class="stat-label">This Month's Payroll</div>
        </div>

      </div>

      <div class="card mt-2">
        <div class="card-header">
          <h2>Recent Payslips</h2>
        </div>

        <div class="card-body">

          ${
            stats.recentPayslips && stats.recentPayslips.length > 0
              ? `
            <table class="data-table">
              <thead>
                <tr>
                  <th>Employee</th>
                  <th>Code</th>
                  <th>Period</th>
                  <th>Net Salary</th>
                  <th>Generated</th>
                  <th>Status</th>
                </tr>
              </thead>

              <tbody>
                ${stats.recentPayslips
                  .map(
                    p => `
                  <tr>
                    <td>${p.employee.firstName} ${p.employee.lastName}</td>
                    <td>
                      <span class="badge badge-blue">
                        ${p.employee.empCode}
                      </span>
                    </td>
                    <td>${getMonthName(p.month)} ${p.year}</td>
                    <td class="money">${formatCurrency(p.netSalary)}</td>
                    <td>${formatDate(p.generatedAt)}</td>
                    <td>
                      ${
                        p.emailed
                          ? '<span class="badge badge-emerald">Emailed</span>'
                          : '<span class="badge badge-muted">Not Sent</span>'
                      }
                    </td>
                  </tr>
                `
                  )
                  .join('')}
              </tbody>
            </table>
          `
              : `
            <div class="empty-state">
              <div class="empty-icon">
                <i data-lucide="file-search"></i>
              </div>
              <p>No payslips generated yet</p>
            </div>
          `
          }

        </div>
      </div>
    `;

    document
      .querySelectorAll('[data-count]')
      .forEach(el => animateCounter(el));

    refreshIcons();

  } catch (err) {
    showToast('Failed to load dashboard', 'error');
  }
}

function animateCounter(element) {
  const target = parseFloat(element.dataset.count) || 0;
  const isMoney = element.classList.contains('money');
  const duration = 1000;
  const start = performance.now();

  function update(now) {
    const elapsed = now - start;
    const progress = Math.min(elapsed / duration, 1);
    const eased = 1 - Math.pow(1 - progress, 3);
    const current = target * eased;

    element.textContent = isMoney
      ? formatCurrency(current)
      : Math.round(current).toString();

    if (progress < 1) {
      requestAnimationFrame(update);
    } else {
      element.textContent = isMoney
        ? formatCurrency(target)
        : target.toString();
    }
  }

  requestAnimationFrame(update);
}
// ===========================
// ===========================
// EMPLOYEES PAGE
// ===========================
async function renderEmployees() {
  const content = document.getElementById('page-content');

  content.innerHTML = `
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem;">
      <h1 class="page-title" style="margin:0;">Employees</h1>

      <button class="btn btn-primary" onclick="navigate('add-employee')">
        <i data-lucide="user-plus"></i>
        Add Employee
      </button>
    </div>

    <div class="card">
      <div class="card-header" style="gap:1rem;">

        <div class="search-bar">
          <span>
            <i data-lucide="search"></i>
          </span>

          <input
            type="text"
            id="emp-search"
            placeholder="Search employees..."
          >
        </div>

        <select id="emp-status-filter"
                class="form-group"
                style="margin:0; width:auto;">
          <option value="">All Status</option>
          <option value="ACTIVE">Active</option>
          <option value="INACTIVE">Inactive</option>
        </select>

      </div>

      <div class="card-body" id="emp-table-container">
        <div class="skeleton skeleton-card"></div>
      </div>
    </div>
  `;

  refreshIcons();

  const loadEmps = async () => {
    try {
      const q = document.getElementById('emp-search').value;
      const st = document.getElementById('emp-status-filter').value;

      let url = '/employees?';

      if (q) {
        url += `search=${encodeURIComponent(q)}&`;
      }

      if (st) {
        url += `status=${encodeURIComponent(st)}`;
      }

      const emps = await api(url);

      const tc = document.getElementById('emp-table-container');

      if (emps.length === 0) {

        tc.innerHTML = `
          <div class="empty-state">
            <div class="empty-icon">
              <i data-lucide="users"></i>
            </div>

            <p>No employees found</p>
          </div>
        `;

      } else {

        tc.innerHTML = `
          <table class="data-table">

            <thead>
              <tr>
                <th>Code</th>
                <th>Name</th>
                <th>Email</th>
                <th>Department</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>

            <tbody>

              ${emps.map(e => `
                <tr>

                  <td>
                    <span class="badge badge-blue">
                      ${e.empCode}
                    </span>
                  </td>

                  <td>${e.firstName} ${e.lastName}</td>

                  <td>${e.email}</td>

                  <td>${e.department ? e.department.name : '—'}</td>

                  <td>
                    ${
                      e.status === 'ACTIVE'
                        ? '<span class="badge badge-emerald">ACTIVE</span>'
                        : '<span class="badge badge-rose">INACTIVE</span>'
                    }
                  </td>

                  <td>

                    <button
                      class="btn-icon"
                      title="Edit"
                      onclick="navigate('edit-employee/${e.id}')">

                      <i data-lucide="square-pen"></i>

                    </button>

                    <button
                      class="btn-icon"
                      title="Delete"
                      onclick="deleteEmployee(${e.id})">

                      <i data-lucide="trash-2"></i>

                    </button>

                  </td>

                </tr>
              `).join('')}

            </tbody>

          </table>
        `;
      }

      refreshIcons();

    } catch (err) {

      document.getElementById('emp-table-container').innerHTML = `
        <p style="color:red;">Error loading employees</p>
      `;
    }
  };

  await loadEmps();

  let dbTimer;

  document.getElementById('emp-search').onkeyup = () => {
    clearTimeout(dbTimer);
    dbTimer = setTimeout(loadEmps, 300);
  };

  document.getElementById('emp-status-filter').onchange = loadEmps;
}

window.deleteEmployee = (id) => {
  showConfirm(
    'Are you sure you want to delete this employee?',
    async () => {
      try {
        await api(`/employees/${id}`, 'DELETE');

        showToast('Employee deleted', 'success');

        renderEmployees();

      } catch (err) {
        showToast(err.message, 'error');
      }
    }
  );
};

// ===========================
// ===========================
// EMPLOYEE FORM
// ===========================
async function renderEmployeeForm(editId = null) {
  const content = document.getElementById('page-content');

  content.innerHTML = `
    <h1 class="page-title">${editId ? 'Edit' : 'Add'} Employee</h1>
    <div class="card skeleton skeleton-card"></div>
  `;

  refreshIcons();

  try {
    const depts = await api('/departments');

    let emp = {};

    if (editId) {
      emp = await api(`/employees/${editId}`);
    }

    content.innerHTML = `
      <h1 class="page-title">${editId ? 'Edit' : 'Add'} Employee</h1>

      <div class="card">
        <div class="card-body">

          <form id="emp-form">

            <div class="form-grid">

              <div class="form-group">
                <label>First Name</label>
                <input type="text" id="ef-first" required value="${emp.firstName || ''}">
              </div>

              <div class="form-group">
                <label>Last Name</label>
                <input type="text" id="ef-last" required value="${emp.lastName || ''}">
              </div>

              <div class="form-group">
                <label>Email</label>
                <input type="email" id="ef-email" required value="${emp.email || ''}">
              </div>

              <div class="form-group">
                <label>Phone</label>
                <input type="text" id="ef-phone" value="${emp.phone || ''}">
              </div>

              <div class="form-group">
                <label>Department</label>
                <select id="ef-dept" required>
                  <option value="">Select Department</option>
                  ${depts.map(d => `
                    <option value="${d.id}"
                      ${emp.department && emp.department.id === d.id ? 'selected' : ''}>
                      ${d.name}
                    </option>
                  `).join('')}
                </select>
              </div>

              <div class="form-group">
                <label>Designation</label>
                <input type="text" id="ef-desig" value="${emp.designation || ''}">
              </div>

              <div class="form-group">
                <label>Date of Joining</label>
                <input
                  type="date"
                  id="ef-doj"
                  value="${emp.dateOfJoining ? emp.dateOfJoining.substring(0, 10) : ''}">
              </div>

              <div class="form-group">
                <label>Status</label>
                <select id="ef-status">
                  <option value="ACTIVE" ${emp.status === 'ACTIVE' ? 'selected' : ''}>Active</option>
                  <option value="INACTIVE" ${emp.status === 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                </select>
              </div>

              <div class="form-group">
                <label>Basic Salary</label>
                <input type="number" id="ef-basic" required value="${emp.basicSalary || 0}">
              </div>

              <div class="form-group">
                <label>HRA</label>
                <input type="number" id="ef-hra" value="${emp.hra || 0}">
              </div>

              <div class="form-group">
                <label>Transport Allowance</label>
                <input type="number" id="ef-ta" value="${emp.transportAllowance || 0}">
              </div>

              <div class="form-group">
                <label>Medical Allowance</label>
                <input type="number" id="ef-ma" value="${emp.medicalAllowance || 0}">
              </div>

              <div class="form-group">
                <label>Other Allowance</label>
                <input type="number" id="ef-oa" value="${emp.otherAllowance || 0}">
              </div>

            </div>

            <div class="form-actions">
              <button
                type="button"
                class="btn btn-outline"
                onclick="navigate('employees')">
                Cancel
              </button>

              <button type="submit" class="btn btn-primary">
                ${editId ? 'Update' : 'Save'} Employee
              </button>
            </div>

          </form>

        </div>
      </div>
    `;

    refreshIcons();

    document.getElementById('emp-form').onsubmit = async (e) => {
      e.preventDefault();

      const payload = {
        firstName: document.getElementById('ef-first').value,
        lastName: document.getElementById('ef-last').value,
        email: document.getElementById('ef-email').value,
        phone: document.getElementById('ef-phone').value,
        departmentId: parseInt(document.getElementById('ef-dept').value),
        designation: document.getElementById('ef-desig').value,
        dateOfJoining: document.getElementById('ef-doj').value,
        status: document.getElementById('ef-status').value,
        basicSalary: parseFloat(document.getElementById('ef-basic').value),
        hra: parseFloat(document.getElementById('ef-hra').value),
        transportAllowance: parseFloat(document.getElementById('ef-ta').value),
        medicalAllowance: parseFloat(document.getElementById('ef-ma').value),
        otherAllowance: parseFloat(document.getElementById('ef-oa').value)
      };

      const btn = e.target.querySelector('button[type=submit]');
      btn.classList.add('loading');

      try {
        if (editId) {
          await api(`/employees/${editId}`, 'PUT', payload);
        } else {
          await api('/employees', 'POST', payload);
        }

        showToast(
          `Employee ${editId ? 'updated' : 'added'} successfully`,
          'success'
        );

        navigate('employees');

      } catch (err) {
        showToast(err.message, 'error');
        btn.classList.remove('loading');
      }
    };

  } catch (err) {
    content.innerHTML = `<p style="color:red;">Error loading form</p>`;
  }
}

// ===========================
// PAYSLIPS PAGE
// ===========================
async function renderPayslips() {
  const content = document.getElementById('page-content');

  content.innerHTML = `
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem;">
      <h1 class="page-title" style="margin:0;">Payslips</h1>

      <button class="btn btn-primary" onclick="navigate('generate-payslip')">
        <i data-lucide="wallet"></i>
        Generate New
      </button>
    </div>

    <div class="card">
      <div class="card-body" id="ps-table-container">
        <div class="skeleton skeleton-card"></div>
      </div>
    </div>
  `;

  refreshIcons();

  try {
    const ps = await api('/payslips');

    const tc = document.getElementById('ps-table-container');

    if (ps.length === 0) {

      tc.innerHTML = `
        <div class="empty-state">
          <div class="empty-icon">
            <i data-lucide="file-text"></i>
          </div>

          <p>No payslips found</p>
        </div>
      `;

    } else {

      tc.innerHTML = `
        <table class="data-table">

          <thead>
            <tr>
              <th>Employee</th>
              <th>Period</th>
              <th>Net Salary</th>
              <th>Generated On</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>

            ${ps.map(p => `
              <tr>

                <td>${p.employee.firstName} ${p.employee.lastName}</td>

                <td>${getMonthName(p.month)} ${p.year}</td>

                <td class="money">
                  ${formatCurrency(p.netSalary)}
                </td>

                <td>${formatDate(p.generatedAt)}</td>

                <td>
                  ${
                    p.emailed
                      ? '<span class="badge badge-emerald">Emailed</span>'
                      : '<span class="badge badge-muted">Not Sent</span>'
                  }
                </td>

                <td>

                  <button
                    class="btn-icon"
                    title="View / Download"
                    onclick="window.open('${API}/payslips/${p.id}/pdf', '_blank')">

                    <i data-lucide="file-down"></i>

                  </button>

                  <button
                    class="btn-icon"
                    title="Email"
                    onclick="emailPayslip(${p.id})">

                    <i data-lucide="mail"></i>

                  </button>

                </td>

              </tr>
            `).join('')}

          </tbody>

        </table>
      `;
    }

    refreshIcons();

  } catch (err) {

    document.getElementById('ps-table-container').innerHTML = `
      <p>Error loading payslips</p>
    `;
  }
}

window.emailPayslip = async (id) => {
  try {
    await api(`/payslips/${id}/email`, 'POST');

    showToast('Email sent successfully', 'success');

    renderPayslips(); // Refresh status

  } catch (err) {
    showToast(err.message, 'error');
  }
};

// ===========================
// GENERATE PAYSLIP PAGE
// ===========================
async function renderGeneratePayslip() {
  const content = document.getElementById('page-content');

  content.innerHTML = `
    <h1 class="page-title">Generate Payslip</h1>
    <div class="skeleton skeleton-card"></div>
  `;

  refreshIcons();

  try {
    const emps = await api('/employees?status=ACTIVE');

    const curYear = new Date().getFullYear();
    const curMonth = new Date().getMonth() + 1;

    content.innerHTML = `
      <h1 class="page-title">Generate Payslip</h1>

      <div class="payslip-split">

        <div class="card">
          <div class="card-body">

            <form id="gen-form">

              <div class="form-group">
                <label>Employee</label>

                <select id="gp-emp" required>
                  <option value="">Select Employee</option>

                  ${emps.map(e => `
                    <option
                      value="${e.id}"
                      data-basic="${e.basicSalary || 0}"
                      data-hra="${e.hra || 0}"
                      data-ta="${e.transportAllowance || 0}"
                      data-ma="${e.medicalAllowance || 0}"
                      data-oa="${e.otherAllowance || 0}">
                      ${e.empCode} - ${e.firstName} ${e.lastName}
                    </option>
                  `).join('')}

                </select>
              </div>

              <div class="form-grid">

                <div class="form-group">
                  <label>Month</label>

                  <select id="gp-month" required>
                    ${MONTHS.map((m, i) => `
                      <option
                        value="${i + 1}"
                        ${i + 1 === curMonth ? 'selected' : ''}>
                        ${m}
                      </option>
                    `).join('')}
                  </select>
                </div>

                <div class="form-group">
                  <label>Year</label>
                  <input
                    type="number"
                    id="gp-year"
                    required
                    value="${curYear}">
                </div>

              </div>

              <hr style="border:0; border-top:1px solid var(--glass-border); margin:1.5rem 0;">

              <h3>Deductions</h3>
              <br>

              <div class="form-grid">

                <div class="form-group">
                  <label>PF Deduction</label>
                  <input type="number" id="gp-pf" value="0" required>
                </div>

                <div class="form-group">
                  <label>Tax Deduction</label>
                  <input type="number" id="gp-tax" value="0" required>
                </div>

                <div class="form-group">
                  <label>Other Deduction</label>
                  <input type="number" id="gp-otherd" value="0" required>
                </div>

              </div>

              <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                  Generate Payslip
                </button>
              </div>

            </form>

          </div>
        </div>

        <div class="payslip-preview">

          <h2 style="text-align:center; margin-bottom:1.5rem;">
            Live Preview
          </h2>

          <div class="salary-breakdown">

            <div class="breakdown-col">

              <h3>Earnings</h3>

              <div class="breakdown-item">
                <span>Basic</span>
                <span id="pv-basic">₹0.00</span>
              </div>

              <div class="breakdown-item">
                <span>HRA</span>
                <span id="pv-hra">₹0.00</span>
              </div>

              <div class="breakdown-item">
                <span>Transport</span>
                <span id="pv-ta">₹0.00</span>
              </div>

              <div class="breakdown-item">
                <span>Medical</span>
                <span id="pv-ma">₹0.00</span>
              </div>

              <div class="breakdown-item">
                <span>Other</span>
                <span id="pv-oa">₹0.00</span>
              </div>

              <div class="breakdown-item"
                   style="font-weight:bold; margin-top:1rem; border-top:1px dashed var(--glass-border); padding-top:0.5rem;">
                <span>Gross</span>
                <span id="pv-gross">₹0.00</span>
              </div>

            </div>

            <div class="breakdown-col">

              <h3>Deductions</h3>

              <div class="breakdown-item">
                <span>PF</span>
                <span id="pv-pf">₹0.00</span>
              </div>

              <div class="breakdown-item">
                <span>Tax</span>
                <span id="pv-tax">₹0.00</span>
              </div>

              <div class="breakdown-item">
                <span>Other</span>
                <span id="pv-otherd">₹0.00</span>
              </div>

              <div class="breakdown-item"
                   style="font-weight:bold; margin-top:1rem; border-top:1px dashed var(--glass-border); padding-top:0.5rem; color:var(--accent-rose);">
                <span>Total Deductions</span>
                <span id="pv-totald">₹0.00</span>
              </div>

            </div>

          </div>

          <div class="net-salary-highlight" id="pv-net">
            ₹0.00
          </div>

        </div>

      </div>
    `;

    refreshIcons();

    const updatePreview = () => {
      const sel = document.getElementById('gp-emp');
      const opt = sel.options[sel.selectedIndex];

      if (!opt || !opt.value) return;

      const basic = parseFloat(opt.dataset.basic || 0);
      const hra = parseFloat(opt.dataset.hra || 0);
      const ta = parseFloat(opt.dataset.ta || 0);
      const ma = parseFloat(opt.dataset.ma || 0);
      const oa = parseFloat(opt.dataset.oa || 0);

      const gross = basic + hra + ta + ma + oa;

      const pf = parseFloat(document.getElementById('gp-pf').value || 0);
      const tax = parseFloat(document.getElementById('gp-tax').value || 0);
      const otherd = parseFloat(document.getElementById('gp-otherd').value || 0);

      const totald = pf + tax + otherd;
      const net = gross - totald;

      document.getElementById('pv-basic').textContent = formatCurrency(basic);
      document.getElementById('pv-hra').textContent = formatCurrency(hra);
      document.getElementById('pv-ta').textContent = formatCurrency(ta);
      document.getElementById('pv-ma').textContent = formatCurrency(ma);
      document.getElementById('pv-oa').textContent = formatCurrency(oa);
      document.getElementById('pv-gross').textContent = formatCurrency(gross);

      document.getElementById('pv-pf').textContent = formatCurrency(pf);
      document.getElementById('pv-tax').textContent = formatCurrency(tax);
      document.getElementById('pv-otherd').textContent = formatCurrency(otherd);
      document.getElementById('pv-totald').textContent = formatCurrency(totald);

      document.getElementById('pv-net').textContent = formatCurrency(net);
    };

    document.getElementById('gp-emp').onchange = updatePreview;

    ['gp-pf', 'gp-tax', 'gp-otherd'].forEach(id => {
      document.getElementById(id).oninput = updatePreview;
    });

    document.getElementById('gen-form').onsubmit = async (e) => {
      e.preventDefault();

      const payload = {
        employeeId: parseInt(document.getElementById('gp-emp').value),
        month: parseInt(document.getElementById('gp-month').value),
        year: parseInt(document.getElementById('gp-year').value),
        pfDeduction: parseFloat(document.getElementById('gp-pf').value),
        taxDeduction: parseFloat(document.getElementById('gp-tax').value),
        otherDeduction: parseFloat(document.getElementById('gp-otherd').value)
      };

      try {
        await api('/payslips/generate', 'POST', payload);

        showToast('Payslip generated successfully', 'success');

        navigate('payslips');

      } catch (err) {
        showToast(err.message, 'error');
      }
    };

  } catch (err) {
    content.innerHTML = '<p>Error loading employees</p>';
  }
}

// ===========================
// VIEW PAYSLIP PAGE
// ===========================
async function renderViewPayslip(id) {
  const content = document.getElementById('page-content');

  content.innerHTML = `
    <h1 class="page-title">Payslip Details</h1>
    <div class="skeleton skeleton-card"></div>
  `;

  refreshIcons();

  try {
    const p = await api(`/payslips/${id}`);

    content.innerHTML = `
      <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem;">
        <h1 class="page-title" style="margin:0;">Payslip Details</h1>

        <button class="btn btn-outline" onclick="navigate('payslips')">
          <i data-lucide="arrow-left"></i>
          Back to Payslips
        </button>
      </div>

      <div class="payslip-split">

        <div class="card">
          <div class="card-body">

            <h3 style="margin-bottom:1rem;">Employee Information</h3>

            <div class="form-grid">

              <div class="form-group">
                <label>Name</label>
                <p>${p.employee.firstName} ${p.employee.lastName}</p>
              </div>

              <div class="form-group">
                <label>Code</label>
                <p>
                  <span class="badge badge-blue">
                    ${p.employee.empCode}
                  </span>
                </p>
              </div>

              <div class="form-group">
                <label>Department</label>
                <p>${p.employee.department ? p.employee.department.name : '—'}</p>
              </div>

              <div class="form-group">
                <label>Designation</label>
                <p>${p.employee.designation || '—'}</p>
              </div>

              <div class="form-group">
                <label>Period</label>
                <p>${getMonthName(p.month)} ${p.year}</p>
              </div>

              <div class="form-group">
                <label>Generated</label>
                <p>${formatDate(p.generatedAt)}</p>
              </div>

            </div>

          </div>
        </div>

        <div class="payslip-preview">

          <h2 style="text-align:center; margin-bottom:1.5rem;">
            Salary Breakdown
          </h2>

          <div class="salary-breakdown">

            <div class="breakdown-col">

              <h3>Earnings</h3>

              <div class="breakdown-item">
                <span>Basic</span>
                <span>${formatCurrency(p.basicSalary)}</span>
              </div>

              <div class="breakdown-item">
                <span>HRA</span>
                <span>${formatCurrency(p.hra)}</span>
              </div>

              <div class="breakdown-item">
                <span>Transport</span>
                <span>${formatCurrency(p.transportAllowance)}</span>
              </div>

              <div class="breakdown-item">
                <span>Medical</span>
                <span>${formatCurrency(p.medicalAllowance)}</span>
              </div>

              <div class="breakdown-item">
                <span>Other</span>
                <span>${formatCurrency(p.otherAllowance)}</span>
              </div>

              <div class="breakdown-item"
                   style="font-weight:bold; margin-top:1rem; border-top:1px dashed var(--glass-border); padding-top:0.5rem;">
                <span>Gross</span>
                <span>${formatCurrency(p.grossSalary)}</span>
              </div>

            </div>

            <div class="breakdown-col">

              <h3>Deductions</h3>

              <div class="breakdown-item">
                <span>PF</span>
                <span>${formatCurrency(p.pfDeduction)}</span>
              </div>

              <div class="breakdown-item">
                <span>Tax</span>
                <span>${formatCurrency(p.taxDeduction)}</span>
              </div>

              <div class="breakdown-item">
                <span>Other</span>
                <span>${formatCurrency(p.otherDeduction)}</span>
              </div>

              <div class="breakdown-item"
                   style="font-weight:bold; margin-top:1rem; border-top:1px dashed var(--glass-border); padding-top:0.5rem; color:var(--accent-rose);">
                <span>Total Deductions</span>
                <span>${formatCurrency(p.totalDeductions)}</span>
              </div>

            </div>

          </div>

          <div class="net-salary-highlight">
            ${formatCurrency(p.netSalary)}
          </div>

          <div style="display:flex; gap:1rem; margin-top:1.5rem; justify-content:center;">

            <button
              class="btn btn-primary"
              onclick="window.open('${API}/payslips/${p.id}/pdf', '_blank')">

              <i data-lucide="file-down"></i>
              Download PDF

            </button>

            <button
              class="btn btn-success"
              id="vp-email-btn"
              onclick="vpEmailPayslip(${p.id})">

              <i data-lucide="mail"></i>
              Send Email

            </button>

          </div>

          ${
            p.emailed
              ? `
                <p style="text-align:center; margin-top:1rem; color:var(--accent-emerald);">
                  <i data-lucide="check-circle"></i>
                  Emailed on ${formatDate(p.emailedAt)}
                </p>
              `
              : ''
          }

        </div>

      </div>
    `;

    refreshIcons();

  } catch (err) {
    content.innerHTML = `
      <p style="color:red;">Error loading payslip</p>
    `;
  }
}

window.vpEmailPayslip = async (id) => {
  const btn = document.getElementById('vp-email-btn');

  if (btn) {
    btn.classList.add('loading');
    btn.disabled = true;
  }

  try {
    await api(`/payslips/${id}/email`, 'POST');

    showToast('Email sent successfully!', 'success');

    await renderViewPayslip(id);

  } catch (err) {
    showToast(err.message || 'Failed to send email', 'error');

  } finally {
    if (btn) {
      btn.classList.remove('loading');
      btn.disabled = false;
    }
  }
};

// ===========================
// ===========================
// RENDER APP
// ===========================
function renderApp() {
  const app = document.getElementById('app');

  if (!currentUser) {
    document.getElementById('login-page').style.display = 'flex';
    document.getElementById('main-layout').style.display = 'none';

    const form = document.getElementById('login-form');
    if (form) {
      form.onsubmit = handleLogin;
    }

    refreshIcons();
    setupPasswordToggle();

  } else {
    document.getElementById('login-page').style.display = 'none';
    document.getElementById('main-layout').style.display = 'flex';

    const userEl = document.getElementById('sidebar-username');
    if (userEl) {
      userEl.textContent = currentUser;
    }

    const logoutBtn = document.getElementById('logout-btn');
    if (logoutBtn) {
      logoutBtn.onclick = handleLogout;
    }

    document.querySelectorAll('.nav-item').forEach(el => {
      el.onclick = () => navigate(el.dataset.page);
    });

    refreshIcons();

    handleRoute();
  }
}

function setupPasswordToggle() {
  const toggle = document.getElementById('password-toggle');
  const input = document.getElementById('login-password');

  if (!toggle || !input) return;

  const updateIcon = () => {
    toggle.innerHTML = input.type === 'password'
      ? '<i data-lucide="eye"></i>'
      : '<i data-lucide="eye-off"></i>';

    refreshIcons();
  };

  updateIcon();

  toggle.onclick = () => {
    input.type = input.type === 'password'
      ? 'text'
      : 'password';

    updateIcon();
  };
}

// ===========================
// INITIALIZATION
// ===========================
document.addEventListener('DOMContentLoaded', async () => {
  const authenticated = await checkSession();

  if (authenticated) {
    startSessionTimer();
  }

  renderApp();

  window.addEventListener('hashchange', handleRoute);
});
