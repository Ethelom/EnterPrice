<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.database.ProductDAO" %>
<%@ page import="group48.enterprice.model.Customer" %>
<%@ page import="group48.enterprice.model.Product" %>
<%@ page import="group48.enterprice.model.ProductKeeper" %>
<%@ page import="group48.enterprice.model.User" %>
<%@ page import="group48.enterprice.utilities.Caster" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
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
        h4 {
            text-align: left;
            cursor: pointer;
            margin-top: 20px;
            margin-left: 10px;
            }
        
    </style>

<body>
<%if(session.getAttribute("enterpriceUser") != null) {
    User user = (User)session.getAttribute("enterpriceUser");
    Caster.castObjectToTypeOfUser(user, Customer.class);
    %>
    <jsp:include page="navbarCustomer.jsp" />
    <%    
} else {
    %>
    <jsp:include page="defaultNavbar.jsp" />
    <%
}
%>

    <div class="container" style="margin-top: 32px; min-height: 79vh">
    <%
    String searchText = null;
    LinkedHashMap<String, Integer> subCategoriesAndFrequencies = null;
    List<Product> products = null;
    if(request.getParameter("search") != null) {
        searchText = request.getParameter("search");
       
        /* hidden feature start */
        if(searchText.equals("m.u.s.i.c")) { 
        %>
            <iframe width="1280" height="720" src="https://www.youtube.com/embed/EPo5wWmKEaI" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
        <%
        }
        /* hidden feature end */
        
        
        products = new ProductDAO().findProducts(searchText);
        ProductKeeper productKeeper = new ProductKeeper(products);
        session.setAttribute("savedProducts", productKeeper);
        if (products.size() == 0) { %>
        <div class="alert text-center" style="margin-top:40px; font-size:16px; background-color:aliceblue" role="alert">
            No product(s) found for: <%=searchText %>
        </div>
        <%
        } else {
            subCategoriesAndFrequencies = ProductDAO.getDistinctSubcategoriesAndOccurences(searchText);
        %>
            <div style="margin-bottom: 20px">
            <h3>Categories for: <b><%=searchText %></b></h3>
            <hr>
            </div>
            <%
            for (Map.Entry<String, Integer> entry : subCategoriesAndFrequencies.entrySet()) { %>
                <div class="col-md-4">
                    <div class="thumbnail">
                        <div class="caption text-center">
                            <div class="position-relative">
                                <%//Product firstSubCategoryOccurence = products.stream().filter(t -> t.getSubCategory().equals(entry.getKey())).findFirst().get();
                                
                                Product firstSubCategoryOccurence = null;
                                for (Product product : products) {
                                    if(product.getSubCategory().equals(entry.getKey())) {
                                        firstSubCategoryOccurence = product;
                                        break;
                                    }
                                }
                                
                                %>
                                <a href="searchMultipleProducts.jsp?search=<%=searchText %>&subcategory=<%=entry.getKey()%>&cameFrom=search&resetFilters=yes">
                                <img src="<%=firstSubCategoryOccurence.getProductImage()%>" alt="<%=entry.getKey() %>" class="img-size-lg">
                                </a>
                            </div>
                        </div>
                        <div class="thumbnail-description category-description">
                            <h4>
                            <a href="searchMultipleProducts.jsp?search=<%=searchText %>&subcategory=<%=entry.getKey()%>&cameFrom=search&resetFilters=yes"><%=entry.getKey() %></a>
                            <small> (<%=entry.getValue() %>)</small>
                            </h4>
                        </div>
                    </div>
                </div>
            <%
            }
        }
    }
    %>

    </div>

    <jsp:include page="footer.jsp" />

</body>

</html>
