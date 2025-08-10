<%@ page session="true" %>
<%
    // Invalidate the session
    session.invalidate();

    // Redirect to login page
    response.sendRedirect("index.jsp");
%>
