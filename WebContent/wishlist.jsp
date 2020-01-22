<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.database.WishlistDAO" %>
<%@ page import="group48.enterprice.model.Customer" %>
<%@ page import="group48.enterprice.model.Product" %>
<%@ page import="group48.enterprice.model.User" %>
<%@ page import="group48.enterprice.utilities.Caster" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page errorPage="errorPage.jsp" %>
<!DOCTYPE HTML>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <meta name="author" content="Theodosis Tsaklanos - 8170136">
    <meta name="author" content="Paris Mpampaniotis - 8170080">

    <title>EnterPrice - Wishlist</title>
    <link rel="icon" href="icons/logo-lg.png" type="image/x-icon">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.css">
    <link rel="stylesheet" href="css/navbar-theme.css">
    <link rel="stylesheet" href="css/core-theme.css">
    <link rel="stylesheet" href="css/cart-theme.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>

<%
User user = null;
Customer customer = null;
if(session.getAttribute("enterpriceUser") != null) {
    user = (User)session.getAttribute("enterpriceUser");
    customer = Caster.castObjectToTypeOfUser(user, Customer.class);
    %>
    <jsp:include page="navbarCustomer.jsp" />
    <%    
} else {
    request.setAttribute("message", "You are not authorised to access this source! Please log in to continue!");
    %>
    <jsp:forward page="login.jsp"></jsp:forward>
    <%
}
%>

<body>
    <div class="container-fluid" style="margin-top: 30px">
        <div class="col-sm-10 col-sm-offset-1 col-lg-8 col-lg-offset-2">
        <%
        List<Product> products = customer.getWishlist();
        Collections.sort(products);
        
        if (products.size() > 0) {
        %>
            <div class="thumbnail">
                <div class="caption text-center">
                    <h2>Wish List</h2>
                    <hr>
                    <br>
                </div>

                <div class="cart-container">

                <div style="margin: 0 50px;">
                    <div style="overflow-x: auto">
                            <table class="table col-xs-6" style="background-color: white; overflow-x: auto">
                                <thead>
                                    <tr>
                                        <th scope="col" class="border-0">
                                            <div class="p-2 px-3 text-uppercase" style="margin-left:20px">Product</div>
                                        </th>
                                        <th scope="col" class="border-0 text-center">
                                            <div class="py-2 text-uppercase">View</div>
                                        </th>
                                        <th scope="col" class="border-0 text-center">
                                            <div class="py-2 text-uppercase">Remove</div>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    int counter = 0;
                                    for (Product product : products) {
                                    %>
                                    <tr>
                                        <th scope="row">
                                            <div class="p-2">
                                                <img src="<%=product.getProductImage() %>" alt="" class="img-fluid img-size-sm">
                                                <div class="ml-3 d-inline-block align-middle">
                                                    <%String productName = product.getProductName(); %>
                                                    <h4 class="mb-0"> <a href="viewProduct.jsp?productName=<%=productName.replace(" ", "-") %>" class="text-dark d-inline-block"><%=productName %></a></h4>
                                                    <span class="text-muted font-weight-normal font-italic d-block">Category: <%=product.getCategory().toString() %></span>
                                                </div>
                                            </div>
                                        </th>
                                         
                                        <td class="align-middle text-center">                                   
                                            <a class="btn btn-round enterprice-blue" href="viewProduct.jsp?productName=<%=productName.replace(" ", "-") %>"><i class="fa fa-eye"></i>
 View</a>
                                        </td>
                                        
                                        
	                                    
					                    <td class="align-middle text-center">
						                    <input type="hidden" id="heartId" name="heart">
                                            <form method="post" action="wishlistController.jsp">
                                            <input type="hidden" name="heart" value='<%=productName %>'>
                                            <%session.setAttribute("caller", "wishlist.jsp"); %>
                                            <button style="background-color:inherit; box-shadow: none; outline: none; border:0" type="submit">
                                                <i id="heart" class="fa fa-heart fa-2x" style="vertical-align: middle; color:#f46353"></i>
                                            </button>						                    
						                       
                                            </form>
					                    </td>
					                  
                                    </tr>
                                    <%
                                        counter++;
                                    }
                                    %>
                                </tbody>
                            </table>
                    </div>
                    <br>
                </div>
            </div>
        </div>
                    
        <%
        } else {   
        %>
            <div class="text-center">
                <img src="icons/emptywishlist.png" />
            </div>
        <%    
        }
        %>
    </div>
    </div>
    <jsp:include page="footer.jsp"></jsp:include>
</body>
</html>
