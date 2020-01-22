<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.database.UserDAO"%>
<%@ page import="group48.enterprice.database.ProductDAO" %>
<%@ page import="group48.enterprice.model.Product" %>
<%@ page import="group48.enterprice.model.ProductKeeper" %>
<%@ page import="group48.enterprice.model.User" %>
<%@ page import="group48.enterprice.model.Avatar" %>
<%@ page import="group48.enterprice.database.Authenticator" %>
<%@ page import="group48.enterprice.database.WishlistDAO" %>
<%@ page import="java.util.ArrayList" import="java.util.List" %>
<%@ page errorPage="errorPage.jsp" %>
<%
//remove every attribute
if(session.getAttribute("savedProducts") != null) {
    session.removeAttribute("savedProducts");
}
if(session.getAttribute("checkedFilters") != null) {
    session.removeAttribute("checkedFilters");
}
if(session.getAttribute("lastViewedProcut") != null) {
    session.removeAttribute("lastViewedProduct");
}
String username = request.getParameter("username");
String password = request.getParameter("password");
Authenticator authenticator = new Authenticator();
try {
    User user = authenticator.authenticate(username, password);
    session.setAttribute("enterpriceUser", user);
    user.preloadData();
    
    //load all products for search bar purposes
    List<Product> allProducts = new ArrayList<Product>();
    allProducts = new ProductDAO().findAllProducts();
    session.setAttribute("allProducts", new ProductKeeper(allProducts));
    
    %>
    <jsp:forward page="<%=user.getHomePageSrc() %>"></jsp:forward>
    <%
} catch (Exception e) {
    request.setAttribute("message", e.getMessage());
    %>
    <jsp:forward page="login.jsp"></jsp:forward>
    <%
}
%>
