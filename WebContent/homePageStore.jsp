<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.model.*" %>
<%@ page import="group48.enterprice.database.*" %>
<%@ page import="group48.enterprice.utilities.Caster" %>
<%@ page import="java.util.List, java.util.ArrayList, java.util.Collections" %>
<%@ page errorPage="errorPage.jsp" %>
<!DOCTYPE HTML>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <title>EnterPrice - Home</title>
    <link rel="icon" href="icons/logo-lg.png" type="image/x-icon">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.css">
    <link rel="stylesheet" href="css/navbar-theme.css">
    <link rel="stylesheet" href="css/find.css">
    <link rel="stylesheet" href="css/core-theme.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>

<style>

li a {
  display: block;
}

li a:hover {
  text-decoration: none;
}

</style>

<body>
<%
Store store = null;
if (session.getAttribute("enterpriceUser")!= null) {
     User user = (User) session.getAttribute("enterpriceUser");
     store = Caster.castObjectToTypeOfUser(user, Store.class);
     %><jsp:include page = "<%=user.getNavbarSrc() %>"/><%
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
        <!-- Logo -->
        <div class="text-center">
            <img src="icons/logo-md.png" alt="EnterPrice Logo" class="img-fluid" style="margin-bottom: 30px; margin-top: 40px">
        </div>
        <!--/Logo-->
        
        <!--Search Bar -->
        <form method="post" action="editProduct.jsp">
            <div class="search">
                <div class="form-group has-feedback has-search">
                    <span class="glyphicon glyphicon-search form-control-feedback" style="font-size: 14px"></span>
                    <input type="text" name="search" id="search" style="border-radius: 50px" class="form-control" placeholder="Search for products..." list="allProducts">
                    <datalist id="allProducts">
                            <%for(Product product : allProducts) { %>
                            <option value="<%=product.getProductName() %>"></option>
                            <%} %>
                    </datalist>
                </div>
            </div>
        </form>
    </div>
    
    <!--/Search Bar -->
    <%
    List<Supply> myProducts = store.getProducts();
    Collections.sort(myProducts);
    %>
    <div class="container" style="margin-top: 40px;">
        <%if(myProducts.isEmpty()) {
        %>
            <div class="text-center">
                <img src="icons/sad-face.png" />
                <div class="alert alert-warning text-center" style="margin-top:40px; font-size:16px;" role="alert">
                    You don't sell any products yet!
                </div>
            </div>
            <% } else {
            %>
        <div class="row">
            <div class="text-center">
                <h2>My Products:</h2>
                <hr>
                <br>
            </div>
            <% 
            for (Supply supply: myProducts) {
                String opacity = "1";
                if(supply.getStock() == 0) {
                    opacity = "0.55";
                }
            %>
            <div class="col-xs-12 col-sm-6 col-md-4">
                <div class="thumbnail" style="opacity:<%=opacity%>;">
                    <div class="dropdown">
                        <div class="text-right">
                        <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" style="background-color:inherit; border:none; box-shadow: none" aria-haspopup="true" aria-expanded="true">
                            <span class="glyphicon glyphicon-option-vertical" aria-hidden="true"></span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdownMenu1" style="background-color: #f5f5f5;">
                            <%String productName = supply.getProvision().getProduct().getProductName(); %>
                            <li><a href="editProduct.jsp?search=<%=productName %>"> <span class="glyphicon glyphicon-edit" aria-hidden="true"></span>&nbsp;Edit Product</a></li>
                            <%if (supply.getStock() > 0) {%>
                            <li><a href="editProduct.jsp?search=<%=productName %>&setOutOfStockToggle=true"> <span class="glyphicon glyphicon-remove-sign" aria-hidden="true"></span>&nbsp;Set out of stock</a></li>
                            <%} %>
                        </ul>
                    </div>
                    </div>
                    <div class="caption text-center">
                        <div class="position-relative">
                            <img src="<%=supply.getProvision().getProduct().getProductImage()%>" class="img-size-lg" />
                        </div>
                        <h4 id="thumbnail-label"><%=supply.getProvision().getProduct().getProductName()%></h4>
                        <p><i class="glyphicon glyphicon-list light-red lighter bigger-120"></i> <%=supply.getProvision().getProduct().getCategory()%></p>
                        <p><i class="glyphicon glyphicon-chevron-right light-red lighter bigger-120"></i> <%=supply.getProvision().getProduct().getSubCategory()%></p>
                        <div class="thumbnail-description">
                            <ul class="list-group">
                                <li class="list-group-item">Available stock: <%if (supply.getStock() == 0) { %><code><%=supply.getStock()%> pieces</code><%} else { %><%=supply.getStock()%><% } %> <br>
                                </li>
                                <li class="list-group-item" style="padding: 0px;">
                                    <h4>
                                        <span class="label label-info">  <%=supply.getProvision().getPrice()%>&euro;</span>
                                    </h4>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
          <%} 
          }%>
        </div>
      </div>
    <jsp:include page="aboutEnterprice.jsp" />
        
    <jsp:include page="footer.jsp" />
    <%} else {
        request.setAttribute("message", "You are not authorized to access this resource. Please log in as a store to proceed"); %>
        <jsp:forward page="login.jsp"/>
    <%
    }
    %>
</body>

</html>
