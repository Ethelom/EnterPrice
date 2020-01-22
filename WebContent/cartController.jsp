<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.model.Cart" %>
<%@ page import="group48.enterprice.model.Customer" %>
<%@ page import="group48.enterprice.model.LineItem" %>
<%@ page import="group48.enterprice.model.Product" %>
<%@ page import="group48.enterprice.model.Provision" %>
<%@ page import="group48.enterprice.model.Supply" %>
<%@ page import="group48.enterprice.model.User" %>
<%@ page import="group48.enterprice.database.WishlistDAO" %>
<%@ page import="group48.enterprice.exceptions.IntruderException" %>
<%@ page import="group48.enterprice.utilities.Caster" %>
<%@ page import="java.util.List" %>
<%@ page errorPage="errorPage.jsp" %>
<%
if(session.getAttribute("enterpriceUser") != null) {
    Customer customer = Caster.castObjectToTypeOfUser(session.getAttribute("enterpriceUser"), Customer.class);
    if(request.getParameter("addToCart") != null) {
        int index = Integer.valueOf(request.getParameter("addToCart"));
        @SuppressWarnings("unchecked")
        List<Supply> availabilities = (List<Supply>) session.getAttribute("availabilities");
        Supply supply = availabilities.get(index);
        Provision provision = availabilities.get(index).getProvision();
        Cart cart = customer.getCart();
        if(!cart.containsItem(provision)) {
            if(supply.getStock() >= 1) {
                customer.getCart().addToCart(new LineItem(provision, 1)); //setting the default quantity to 1
            } else {
                request.setAttribute("reviewMessage", "Changing the button from disabled is not going to work! :) ");
            }
        } else {
            request.setAttribute("reviewMessage", "Cannot add this product to cart, because has already been added!");
        }
       String productName = provision.getProduct().getProductName().replace(" ", "-"); 
%>
        <jsp:forward page="viewProduct.jsp">
      	     <jsp:param name="productName" value="<%=productName%>"></jsp:param>
        </jsp:forward>
<%    
    }
    
    if (request.getParameter("delete") != null) {
        int index = Integer.valueOf(request.getParameter("delete"));
        customer.getCart().getProducts().remove(index);
        %><jsp:forward page="cart.jsp"></jsp:forward><%
    }
    
    if(request.getParameter("addToCart") == null && request.getParameter("delete") == null) {
        throw new Exception("If you play with fire, you get burnt!");
    }
    
} else {
    request.setAttribute("message", "You are not authorised to access this source! Please log in to continue!");
    %>
    <jsp:forward page="login.jsp"></jsp:forward>
    <%
}
%>
