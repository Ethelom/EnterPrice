<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.model.User" %>
<%@ page import="group48.enterprice.model.Customer" %>
<%@ page import="group48.enterprice.model.Product" %>
<%@ page import="group48.enterprice.model.ProductKeeper" %>
<%@ page import="group48.enterprice.database.UserDAO" %>
<%@ page import="group48.enterprice.database.ProductDAO" %>
<%@ page import="group48.enterprice.utilities.Caster" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page errorPage="errorPage.jsp" %>
<!DOCTYPE HTML>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <meta name="author" content="Paris Mpampaniotis - 8170080">
    <meta name="author" content="Theodosis Tsaklanos - 8170136">

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
<%if(session.getAttribute("enterpriceUser") != null) {
    User user = (User)session.getAttribute("enterpriceUser");
    Customer customer = Caster.castObjectToTypeOfUser(user, Customer.class);
        %>
        <jsp:include page="<%=user.getNavbarSrc() %>" />
        <%
} else {
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
        <!-- Logo -->
        <div class="text-center">
            <img src="icons/logo-md.png" alt="EnterPrice Logo" class="img-fluid" style="margin-bottom: 30px; margin-top: 40px">
        </div>
        <!--/Logo-->
        
        <!--Search Bar -->
        <form method="post" action="searchSubcategories.jsp">
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
    <!--/Search Bar -->


    <div class="container" style="margin-top: 40px;">
        <div class="row">
            <div class="col-xs-12 col-sm-4">
                <div class="thumbnail" style="background-color: #daeaf7;">
                    <h3>Technology</h3>
                    <img src="icons/xiaomi-mi-9T.png" alt="Smartphone" class="center">
                    <div class="caption">
                        <ul class="list-group" style="margin-top: 10px">
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Smartphone&resetFilters=yes&cameFrom=home">Smartphones </a></li>
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Laptop&resetFilters=yes&cameFrom=home">Laptops </a></li>
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Camera&resetFilters=yes&cameFrom=home">Cameras </a></li>
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=TV&resetFilters=yes&cameFrom=home">TVs </a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-xs-12 col-sm-4">
                <div class="thumbnail" style="background-color: lavender">
                    <h3>Fashion</h3>
                    <img src="icons/suit.png" alt="laptop">
                    <div class="caption">
                        <ul class="list-group" style="margin-top: 10px">
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Suit&resetFilters=yes&cameFrom=home">Suits </a></li>
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Shirt&resetFilters=yes&cameFrom=home">Shirts </a></li>
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Dress&resetFilters=yes&cameFrom=home">Dresess </a></li>
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Shoes&resetFilters=yes&cameFrom=home">Shoes </a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-xs-12 col-sm-4">
                <div class="thumbnail" style="background-color: whitesmoke">
                    <h3>Home</h3>
                    <img src="icons/sofa.png" alt="laptop">
                    <div class="caption">
                        <ul class="list-group" style="margin-top: 10px">
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Fridge&resetFilters=yes&cameFrom=home">Fridges </a></li>
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Couch&resetFilters=yes&cameFrom=home">Couches </a></li>
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Bed&resetFilters=yes&cameFrom=home">Beds </a></li>
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Table&resetFilters=yes&cameFrom=home">Tables </a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-xs-12 col-sm-4 col-sm-offset-2">
                <div class="thumbnail" style="background-color: #b3798d">
                    <h3>Sports</h3>
                    <img src="icons/snowboard.png" alt="laptop">
                    <div class="caption">
                        <ul class="list-group" style="margin-top: 10px">
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Basketball&resetFilters=yes&cameFrom=home">Basketball </a></li>
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Soccer&resetFilters=yes&cameFrom=home">Soccer </a></li>
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Tennis&resetFilters=yes&cameFrom=home">Tennis </a></li>
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Snowboard&resetFilters=yes&cameFrom=home">Snowboard </a></li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="col-xs-12 col-sm-4">
                <div class="thumbnail" style="background-color: #ffffed">
                    <h3>Stationery</h3>
                    <img src="icons/books.png" alt="laptop">
                    <div class="caption">
                        <ul class="list-group" style="margin-top: 10px">
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Book&resetFilters=yes&cameFrom=home">Books </a></li>
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Pen&resetFilters=yes&cameFrom=home">Pens </a></li>
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Notebook&resetFilters=yes&cameFrom=home">Notebooks </a></li>
                            <li class="list-group-item"><a href="searchMultipleProducts.jsp?subcategory=Bookmark&resetFilters=yes&cameFrom=home">Bookmarks </a></li>
                        </ul>
                    </div>
                </div>
            </div>

        </div>
    </div>
    

    <jsp:include page="aboutEnterprice.jsp"></jsp:include>
    <jsp:include page="footer.jsp"></jsp:include>
</body>

</html>
