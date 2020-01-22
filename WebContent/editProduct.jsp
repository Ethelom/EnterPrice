<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.database.ProductDAO"%>
<%@ page import="group48.enterprice.model.Cart" %>
<%@ page import="group48.enterprice.model.Product" %>
<%@ page import="group48.enterprice.model.Provision" %>
<%@ page import="group48.enterprice.model.Store" %>
<%@ page import="group48.enterprice.model.Supply" %>
<%@ page import="group48.enterprice.utilities.Caster" %>
<%@ page errorPage="errorPage.jsp" %>

<%
Supply sp = null;
Product product = null;
if (session.getAttribute("enterpriceUser") != null) { 
    Store store = Caster.castObjectToTypeOfUser(session.getAttribute("enterpriceUser"), Store.class);
    String productName = (String)request.getParameter("search");
    if (productName != null && !(productName.isEmpty())) {
        product = new ProductDAO().findProduct(productName);
        if (product != null) {
            sp = store.findProductInfo(productName);
            session.setAttribute("editedSupply", sp);
            if(request.getParameter("setOutOfStockToggle") != null) {
                if(request.getParameter("setOutOfStockToggle").equals("true")) {
                    %>
                    <jsp:forward page="editProductController.jsp">
                        <jsp:param value="true" name="setOutOfStockToggle"/>
                    </jsp:forward>
                    <%
                } else {
                    throw new Exception("If you play with fire, you get burnt!");
                }
            }
        } else {
            response.sendError(404);
            throw new Exception();            
        }
    } else {
        throw new Exception("If you play with fire, you get burnt!");
    }
%>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="author" content="Efthymia Kostaki - 8170055">
    <%
    String title = ""; 
    if(sp == null) {
        title = "Add Product";
        session.setAttribute("productToBeAdded", product);
    } else {
        title = "Edit Product";
    }
    %>
    <title><%=title %></title>
    <link rel="icon" href="icons/logo-lg.png" type="image/x-icon">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="css/navbar-theme.css">
    <link rel="stylesheet" href="css/core-theme.css">
    <link rel="stylesheet" href="css/store-navbar-submenu-theme.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>

<body>

    <style>
        body {
            background: url(wallpapers/ballpen-cell-phone-company-796602.jpg) fixed no-repeat;
            background-position: center;
            background-size: cover;
        }
    </style>
            <jsp:include page="<%=store.getNavbarSrc() %>" />

            <div class="container" style="margin-top: 30px; margin-bottom: 198px">
                <div class="col-xs-12  col-sm-12 col-md-12 col-lg-12">
                    <div class="thumbnail">
                        <div class="caption text-center">
                        <%if (sp!= null) { %>
                            <h2>Edit product</h2>
                        <%} else { %>
                            <h2>Add product</h2>
                        <%} %>
                            <hr><br><br>
                        </div>
                        <% if(request.getAttribute("message") != null) { %>     
                            <div class="alert alert-danger text-center" role="alert"><%=(String)request.getAttribute("message") %></div>
                        <% } %>

                        <form class="form-horizontal" action="editProductController.jsp" method="post">
                        
                             <input type="hidden" name="product_name" value="<%=productName%>">
                           <div class="text-center">
                                <h3><%=productName%></h3>
                                <img class="img-responsive center-block img-size-xl" src="<%=product.getProductImage()%>" alt="<%=product.getProductName() %>">
                                <br>
                            </div>
                         <br>
                            <div class="form-group">
                           <label for="product-price" class="col-sm-2 col-md-offset-1 control-label">Price: </label>
                           <div class="col-sm-6 col-md-5">
                               <input type="text" name="productPrice" class="form-control" value = "<%if (sp!=null) {%><%=sp.getProvision().getPrice()%><%} %>" required style="border-radius: 25px">
                           </div>
                        </div>
                        <div class="form-group">
                            <label for="product-quantity" class="col-sm-2 col-md-offset-1 control-label">Quantity: </label>
                            <div class="col-sm-6 col-md-5">
                                 <input type="text" name="productQuantity" class="form-control" value= "<%if (sp!=null) {%><%=sp.getStock()%><%} %>" required style="border-radius: 25px">
                            </div>
                        </div>
                        <%if(sp == null) { %>
                            <input type="hidden" name="addProduct" />
                        <%} else { %>
                            <input type="hidden" name="editProduct" />                        
                        <%} %>

                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-10 col-md-offset-3" style="margin-top: 20px;">
                                <button type="submit" class="btn btn-round enterprice-blue">
                                      <span class="fa fa-check"></span> Submit
                                </button>
                            </div>
                        </div>
                </form>
            </div>
        </div>
    </div>
    <jsp:include page="footer.jsp" />
   <%  
 } else {
        request.setAttribute("message", "You can't access this resource. Please login as a store to proceed.");
        %><jsp:forward page= "login.jsp"/><%
} %>
</body>

</html>
