<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.database.PurchaseDAO" %>
<%@ page import="group48.enterprice.model.User" %>
<%@ page import="group48.enterprice.model.Customer" %>
<%@ page import="group48.enterprice.model.Product" %>
<%@ page import="group48.enterprice.model.Provision" %>
<%@ page import="group48.enterprice.model.Purchase" %>
<%@ page import="group48.enterprice.model.LineItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>

<!DOCTYPE HTML>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <meta name="author" content="Theodosis Tsaklanos - 8170136">
    <meta name="author" content="Paris Mpampaniotis - 8170080">

    <title>EnterPrice - My Products</title>
    <link rel="icon" href="icons/logo-lg.png" type="image/x-icon">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.css">
    <link href='http://fonts.googleapis.com/css?family=Great+Vibes' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="css/navbar-theme.css">
    <link rel="stylesheet" href="css/core-theme.css">
    <link rel="stylesheet" href="css/timeline-theme.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>

<body>
    <%
    User user = null;
    if(session.getAttribute("enterpriceUser") != null) {
        user = (User)session.getAttribute("enterpriceUser");
    } else {
        request.setAttribute("message", "You are not authorised to access this source! Please log in to continue!");
        %>
        <jsp:forward page="login.jsp"></jsp:forward>
        <%
    }
    %> 
    <jsp:include page="<%=user.getNavbarSrc() %>" />
    <%
    List<Purchase> previousPurchases = new PurchaseDAO().getPreviousPurchases(user);
    %>
    
    <div class="container-fluid" style="margin-top: 30px;">
        <div class="col-xs-12 col-md-2" style="margin-top: 45px">
            <h4>Purchase Timeline</h4>
            <button class="btn btn-round enterprice-blue visible-xs visible-sm" data-toggle="collapse" data-target="#timeline_bar"><i class="fa fa-history fa-2x" aria-hidden="true"></i></button>
            <div id="timeline_bar" class="hidden-xs hidden-sm">
                <ul class="timeline">
                <%
                for (Purchase purchase : previousPurchases) {
                %>
                    <li>
                        <a href="#<%=purchase.getPurchaseID() %>"><%=purchase.getDate().toString() %></a>
                    </li>
                <%
                }
                %>
                </ul>
            </div>
        </div>
        <div class="col-xs-12 col-md-10">
            <%
            for (Purchase purchase : previousPurchases) {
            %>
            <div class="text-center" id="<%=purchase.getPurchaseID() %>">
                <h3 style="color:#282828"><%=purchase.getDate().toString() %></h3>
            </div>
            <hr>
            <div class="row" style="margin:30px 0">
                <%
                for(LineItem item : purchase.getProducts()) {
                    Provision provision = item.getProvision();
                %>   
                    <div class="col-xs-12 col-md-4 col-lg-3">
                        <div class="thumbnail">
                            <div class="caption text-center">
                                <div class="position-relative">
                                    <img src="<%=provision.getProduct().getProductImage()%>" class="img-size-md" />
                                </div>
                                <%String productName = provision.getProduct().getProductName(); %>
                                <%
                                String href="#";
                                if(user instanceof Customer) { 
                                    href="viewProduct.jsp?productName="+productName.replace(" ", "-");
                                }
                                %>
                                <h4 id="thumbnail-label"><a href="<%=href%>"><%=productName %></a></h4>
                                <p><i class="glyphicon glyphicon-list light-red lighter bigger-120"></i> <%=provision.getProduct().getCategory() %></p>
                                <div class="thumbnail-description">
                                    <ul class="list-group">
                                        <li class="list-group-item" style="padding: 0px;">
                                            <h4>
                                                <span class="label label-info"><%=provision.getPrice() %> &euro;</span>
                                            </h4>
                                        </li>
                                        <li class="list-group-item">Quantity: <%=item.getQuantity() %></li>
                                        <%
                                        if(user instanceof Customer) {    
                                            %><li class="list-group-item">Store: <%=provision.getStore().getStoreName() %></li> <%
                                        } %>
                                    </ul>
                                </div>
                                <div class="caption card-footer text-center">
                                    <ul class="list-inline text-center">
                                        <li>&nbsp; <i class="glyphicon glyphicon-info-sign lighter"></i> Purchase ID: <%=purchase.getPurchaseID() %></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                
                <%
                }
                %>
                </div>
                <%
            }
            %>
        </div>
    </div>
    <jsp:include page="footer.jsp"></jsp:include>
</body>

</html>
