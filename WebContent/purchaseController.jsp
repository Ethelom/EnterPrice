<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.model.Cart" %>
<%@ page import="group48.enterprice.model.Customer" %>
<%@ page import="group48.enterprice.model.LineItem" %>
<%@ page import="group48.enterprice.model.Product" %>
<%@ page import="group48.enterprice.model.Provision" %>
<%@ page import="group48.enterprice.model.Purchase" %>
<%@ page import="group48.enterprice.utilities.Caster" %>
<%@ page import="group48.enterprice.database.PurchaseDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page errorPage="errorPage.jsp" %>
<%
if(session.getAttribute("enterpriceUser") != null) {
    Customer customer = Caster.castObjectToTypeOfUser(session.getAttribute("enterpriceUser"), Customer.class);
    if(session.getAttribute("purchaseCart") != null) {    
        Cart cart = (Cart)session.getAttribute("purchaseCart");
        if(request.getParameter("totalCost") != null) {
            double totalCost = Double.valueOf(request.getParameter("totalCost"));
            Purchase purchase = new Purchase(0, null, totalCost);
            purchase.setProducts(cart.getProducts());
            new PurchaseDAO().insertPurchase(purchase, customer);
            customer.setCart(new Cart());
            %><jsp:forward page="homePage.jsp"></jsp:forward><%
        } else {
            throw new Exception("There has been a violation of the total cost and thus, your purchase cannot proceed!");
        }
    } else {
        throw new Exception("The products you wish to buy cannot be retrieved! Please try again!");
    }
} else {
    request.setAttribute("message", "You are not authorised to access this source! Please log in to continue!");
%><jsp:forward page="login.jsp"></jsp:forward><%
}
%>