<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="group48.enterprice.model.Product" %>
<%@ page import="group48.enterprice.model.User" %>
<%@ page import="group48.enterprice.model.Customer" %>
<%@ page import="group48.enterprice.model.ProductReview" %>
<%@ page import="group48.enterprice.database.ReviewDAO" %>
<%@ page import="group48.enterprice.utilities.Caster" %>
<%@ page import="com.mysql.jdbc.exceptions.MySQLIntegrityConstraintViolationException" %>
<%@ page errorPage="errorPage.jsp" %>
<%
request.setCharacterEncoding("UTF-8");
Product product = null;
if(session.getAttribute("enterpriceUser") != null) {
    Customer customer = Caster.castObjectToTypeOfUser(session.getAttribute("enterpriceUser"), Customer.class);
        if(session.getAttribute("lastViewedProduct") != null) {
            product = (Product) session.getAttribute("lastViewedProduct");
                if(request.getParameter("rating") != null) {
                    try {
                        //the errorPage properly handles any NumberFormatExceptions
                        int rating = Integer.valueOf(request.getParameter("rating"));
                        String reviewBody = null;
                        if(request.getParameter("comment") != null) {
                            reviewBody = request.getParameter("comment").trim();
                        } else {
                            reviewBody = "";
                        }
                        ProductReview review = new ProductReview(customer, product, rating, reviewBody);
                        
                        ReviewDAO reviewDAO = new ReviewDAO();
                        reviewDAO.submitProductReview(review);
                        %>
                        <jsp:forward page="viewProduct.jsp">
                            <jsp:param name="productName" value='<%=product.getProductName().replace(" ", "-") %>'></jsp:param>
                        </jsp:forward>
                        <%
                    } catch(NumberFormatException e) {
                        throw new Exception("You somehow tried to violate something that was supposed to be a number!");
                    } catch(Exception e) {
                        if(e.getMessage().contains("Duplicate entry")) {
                            request.setAttribute("reviewMessage", "You have already reviewed this product!");
                            %>
                            <jsp:forward page="viewProduct.jsp">
                            <jsp:param name="productName" value='<%=product.getProductName().replace(" ", "-") %>' ></jsp:param>
                            </jsp:forward>
                            <%
                        } else {
                            throw new Exception("Unspecified error");
                        }
                            
                    }
                } else if(request.getParameter("deleteReviewFor") != null) {
                    String productName = request.getParameter("deleteReviewFor");
                    ReviewDAO reviewDAO = new ReviewDAO();
                    reviewDAO.deleteReview(customer.getUsername(), productName);
                    %>
                    <jsp:forward page="viewProduct.jsp">
                        <jsp:param name="productName" value='<%=productName.replace(" ", "-") %>' ></jsp:param>
                    </jsp:forward>
                    <%
                } else {
                    throw new Exception("If you play with fire, you get burnt!");
                } 
        } else {
            throw new Exception("You are kindly requested to select a product before trying to review!");
        }
} else {
    request.setAttribute("message", "You cannot review a product without being signed in! Please sign in first!");
    %>
    <jsp:forward page="login.jsp"></jsp:forward>
    <%    
}
%>