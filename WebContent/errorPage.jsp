<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true"%>
<%@ page import="group48.enterprice.model.Product" %>
<%@ page import="group48.enterprice.model.ProductKeeper" %>
<%@ page import="group48.enterprice.model.User" %>
<%@ page import="group48.enterprice.database.ProductDAO" %>
<%@ page import="group48.enterprice.exceptions.IntruderException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
    <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width initial-scale=1.0">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">

            <meta name="author" content="Theodosis Tsaklanos - 8170136">

            <title>EnterPrice - Error</title>
            <link rel="icon" href="icons/logo-lg.png" type="image/x-icon">
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.css">
            <link rel="stylesheet" href="css/navbar-theme.css">
            <link rel="stylesheet" href="css/find.css">
            <link rel="stylesheet" href="css/core-theme.css">

            <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    </head>

    <body>      
        <%
        
        User user = null;
        String searchForward = "";
        if(session.getAttribute("enterpriceUser") != null) {
            user = (User)session.getAttribute("enterpriceUser");
            searchForward = user.getSearchBarForwardSrc();
            %>
            <jsp:include page="<%=user.getNavbarSrc() %>" />
            <%    
        } else {
            searchForward = "searchSubcategories.jsp";
            %>
            <jsp:include page="defaultNavbar.jsp" />
            <% 
        }
        %>
        
        <%
        List<Product> allProducts = new ArrayList<Product>();

        if(session.getAttribute("allProducts") != null) {
            ProductKeeper allProductsKeeper = (ProductKeeper)session.getAttribute("allProducts");
            allProducts = allProductsKeeper.getSavedProducts();
        } else {
            allProducts = new ProductDAO().findAllProducts();
            session.setAttribute("allProducts", new ProductKeeper(allProducts));
        }
        %>

         <div class="half-background" style="height:35vh;">
            <div class="text-center">
                    <img src="icons/logo-md.png" alt="EnterPrice Logo" class="img-fluid" style="margin-bottom: 30px; margin-top: 40px">
            </div>

            <form method="post" action="<%=searchForward %>">
                <div class="search">
                    <div class="form-group has-feedback has-search">
                        <span class="glyphicon glyphicon-search form-control-feedback" style="font-size: 14px"></span>
                        <input type="text" name="search" style="border-radius: 50px" class="form-control" placeholder="Search for products..." list="allProducts">
                         <datalist id="allProducts">
                                <%for(Product product : allProducts) { %>
                                <option value="<%=product.getProductName() %>"></option>
                                <%} %>
                        </datalist>
                    </div>
                </div>
            </form>
         </div>
         <%
         String message = "Something has gone wrong!";
         if(exception != null) {
             message = exception.getMessage();
             if(exception instanceof IntruderException) {
                 message = "Access is not allowed to " + user.getTypeOfUser() + "(s)";
             }
             
         }
         %>
         <div class="container">
            <div class="page-header text-center">
                <h2>You were forwarded here because:</h2>              
            </div>
            <div class="col-xs-12 col-md-offset-3 col-md-6" style="oveflow:hidden">    
                <div class="alert alert-danger text-center" role="alert">
                    <p style="font-size:18px;">
                        <%=message %>
                    </p>
                </div>
            </div>
        </div>
    </body>
</html>