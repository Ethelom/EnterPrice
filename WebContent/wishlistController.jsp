<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.database.ProductDAO" %>
<%@ page import="group48.enterprice.database.WishlistDAO" %>
<%@ page import="group48.enterprice.model.Customer" %>
<%@ page import="group48.enterprice.utilities.Caster" %>
<%@ page errorPage="errorPage.jsp" %>
<%
Customer customer = null;
if(session.getAttribute("enterpriceUser") != null) {
    customer = Caster.castObjectToTypeOfUser(session.getAttribute("enterpriceUser"), Customer.class);
} else {
    request.setAttribute("message", "You are not authorised to access this source! Please log in to continue!");
    %><jsp:forward page="login.jsp"></jsp:forward><%
}
if(request.getParameter("heart") != null) {
    String productToBeDeleted = request.getParameter("heart");
    
    WishlistDAO wishlistDao = new WishlistDAO();
    wishlistDao.updateWishlist(customer, productToBeDeleted);
    
    customer.updateWishlist(new ProductDAO().findProduct(productToBeDeleted));
    
    //forward back to the page that called this
    String forwardBackPage = null;
    if(session.getAttribute("caller") != null) {
        forwardBackPage = (String) session.getAttribute("caller");
        if(forwardBackPage.equals("viewProduct.jsp")) {
            String productName = productToBeDeleted.replace(" ", "-");
            %>
            <jsp:forward page="viewProduct.jsp">
                <jsp:param name="productName" value="<%=productName%>"></jsp:param>
            </jsp:forward>
            <%
        } else {
            %><jsp:forward page="wishlist.jsp"></jsp:forward>  <%
        }
    }
}
%>