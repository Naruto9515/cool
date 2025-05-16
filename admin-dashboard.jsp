
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title><fmt:message key="admin.title"/></title>
  <style>
    .container { padding: 20px; font-family: Arial, sans-serif; }
    #products img { height: 100px; display: block; }
    input, button { padding: 8px; margin: 5px 0; }
  </style>
</head>
<body>
  <div class="container">
    <form method="get" action="">
      <select name="lang" onchange="this.form.submit()">
        <option value="en" ${param.lang == 'en' ? 'selected' : ''}>English</option>
        <option value="te" ${param.lang == 'te' ? 'selected' : ''}>తెలుగు</option>
        <option value="hi" ${param.lang == 'hi' ? 'selected' : ''}>हिंदी</option>
      </select>
    </form>

    <c:choose>
      <c:when test="${not empty sessionScope.userId}">
        <h1>🛠️ <fmt:message key="admin.dashboard"/></h1>
        <a href="/logout"><button><fmt:message key="logout"/></button></a>

        <h2>📦 <fmt:message key="manage.products"/></h2>
        <div id="adminProducts">Loading products...</div>

        <h2>👥 <fmt:message key="manage.users"/></h2>
        <div id="adminUsers">Loading users...</div>

        <h2>📋 <fmt:message key="manage.orders"/></h2>
        <div id="adminOrders">Loading orders...</div>
      </c:when>
      <c:otherwise>
        <h2>🔐 <fmt:message key="admin.login"/></h2>
        <form method="post" action="/admin-login">
          <input type="email" name="email" placeholder="Email" required /><br />
          <input type="password" name="password" placeholder="Password" required /><br />
          <button type="submit"><fmt:message key="login"/></button>
        </form>
        <c:if test="${not empty error}">
          <div style="color: red; margin-top: 10px;">${error}</div>
        </c:if>
      </c:otherwise>
    </c:choose>
  </div>

  <script>
    if (${not empty sessionScope.userId}) {
      fetch('/api/products').then(r => r.json()).then(data => {
        const container = document.getElementById("adminProducts");
        container.innerHTML = data.map(p => `<div><h4>${p.name}</h4><p>₹${p.price}</p></div>`).join('');
      });

      fetch('/api/orders').then(r => r.json()).then(data => {
        const container = document.getElementById("adminOrders");
        container.innerHTML = data.map(o => `<div><p>Order #${o.id} - Status: ${o.status}</p></div>`).join('');
      });

      fetch('/api/users').then(r => r.json()).then(data => {
        const container = document.getElementById("adminUsers");
        container.innerHTML = data.map(u => `<div><p>${u.name} (${u.email})</p></div>`).join('');
      });
    }
  </script>
</body>
</html>
