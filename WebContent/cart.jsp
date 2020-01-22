<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.model.Customer" %>
<%@ page import="group48.enterprice.model.LineItem" %>
<%@ page import="group48.enterprice.model.Provision" %>
<%@ page import="group48.enterprice.model.Supply" %>
<%@ page import="group48.enterprice.model.User" %>
<%@ page import="group48.enterprice.exceptions.IntruderException" %>
<%@ page import="group48.enterprice.utilities.Caster" %>
<%@ page import="java.util.List" %>
<%@ page errorPage="errorPage.jsp" %>
<!DOCTYPE HTML>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <meta name="author" content="Theodosis Tsaklanos - 8170136">
    <meta name="author" content="Paris Mpampaniotis - 8170080">

    <title>EnterPrice - MyCart</title>
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
Customer customer = null;
if(session.getAttribute("enterpriceUser") != null) {
    customer = Caster.castObjectToTypeOfUser(session.getAttribute("enterpriceUser"), Customer.class);
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
        List<LineItem> cartProducts = customer.getCart().getProducts();
        @SuppressWarnings("unchecked")
        List<Supply> allAvailabilities = (List<Supply>) session.getAttribute("allAvailabilities");
        
        if (cartProducts.size() > 0) {
        %>
            <div class="thumbnail">
                <div class="caption text-center">
                    <h2>My Cart</h2>
                    <hr>
                    <br>
                </div>

                <div class="cart-container">
                    <%
                    if(request.getAttribute("message") != null) { %>
                        <div id="message" class="alert alert-danger text-center" role="alert"><%=(String)request.getAttribute("message") %></div>
                    <%
                    }
                    %>
                    <form method="post" action="purchase.jsp">
                        <div style="overflow-x: auto">
                            <table class="table col-xs-6" style="background-color: white; overflow-x: auto">
                                <thead>
                                    <tr>
                                        <th scope="col" class="border-0">
                                            <div class="p-2 px-3 text-uppercase">Product</div>
                                        </th>
                                        <th scope="col" class="border-0 text-center">
                                            <div class="py-2 text-uppercase">Price</div>
                                        </th>
                                        <th scope="col" class="border-0 text-center">
                                            <div class="py-2 text-uppercase">Quantity</div>
                                        </th>
                                        <th scope="col" class="border-0 text-center">
                                            <div class="py-2 text-uppercase">Remove</div>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    int counter = 0;
                                    double total = 0D;
                                    
                                    for (LineItem item : cartProducts) {
                                        Provision provision = item.getProvision();
                                        total += provision.getPrice() * item.getQuantity();
                                        
                                        int maxAvailable = 5;
                                        int available = maxAvailable;
                                        for(Supply supply : allAvailabilities) {
                                            if(supply.getProvision().equals(provision)) {
                                                if(supply.getStock() < maxAvailable) {
                                                    available = supply.getStock();
                                                }
                                            }
                                        }
                                    %>
                                
                                    <tr>
                                        <th scope="row">
                                            <div class="p-2">
                                                <img src="<%=provision.getProduct().getProductImage() %>" alt="" class="img-fluid img-size-sm">
                                                <div class="ml-3 d-inline-block align-middle">
                                                    <%String productName = provision.getProduct().getProductName(); %>
                                                    <h4 class="mb-0"> <a href="viewProduct.jsp?productName=<%=productName.replace(" ", "-") %>" class="text-dark d-inline-block"><%=productName %></a></h4>
                                                    <span class="text-muted font-weight-normal font-italic d-block">Category: <%=provision.getProduct().getCategory().toString() %></span>
                                                    <span class="text-muted font-weight-normal font-italic d-block">Store: <%=provision.getStore().getStoreName() %></span>
                                                    <%
                                                    if(available < 5) {
                                                        %>
                                                        <span style="color:darkred"><i class="fas fa-fire"> Only <%=available %> left!</i></span>
                                                        <%
                                                        
                                                    }
                                                    %>
                                                </div>
                                            </div>
                                        </th>
                                        <td class="align-middle text-center"><input type="hidden" name="price" value='<%=provision.getPrice() %>' /><strong>&euro; <%=provision.getPrice() %></strong></td>
                                        <td class="col-xs-4 col-md-3 align-middle text-center">
                                            <select name="selectQuantity" style="width: 30%; text-overflow: ellipsis;" autocomplete="off">
                                            <%
                                            for(int i = 0; i < available; i++) {
                                                %>
                                                <option value="<%=i+1%>" <%if(item.getQuantity() == i+1) { %> selected <% } %>>
                                                    <%=i+1 %>
                                                </option>  
                                                <%
                                            }
                                            %>
                                            </select>
                                        </td>
                                        <td class="align-middle text-center">
                                            <a href="cartController.jsp?delete=<%=String.valueOf(counter) %>" class="text-dark">
                                                <i class="fa fa-trash fa-lg" style="color: #315b96"></i>
                                            </a>
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
                    
                    <div class="row text-center">
                        <div class="col-xs-6 col-xs-offset-5 col-sm-3 col-sm-offset-9 col-md-2 col-md-offset-10">
                        <div class="form-group">
                            <label id="total-cost-area">Total: &euro; <%=total %></label>
                            <button type="submit" class="btn btn-round enterprice-blue" style="margin-bottom: 10px; font-size: 16px; font-weight: 550">
                                Checkout
                            </button>
                        </div>
                        </div>
                    </div>
                    </form>
                </div>
            </div>
        <%
        } else {   
        %>
            <div class="text-center">
                <img src="icons/emptycart.png" />
                <div class="alert text-center" style="margin-top:40px; font-size:16px; background-color:aliceblue" role="alert">
                    Your cart is empty!
                </div>
            </div>
        <%    
        }
        %>
        </div>
    </div>
    <jsp:include page="footer.jsp"></jsp:include>
</body>

<script>
    $(document).ready(function() {
        $("select").on('change', function() {
            var totalCost = 0;
            var selectArray = document.getElementsByName('selectQuantity');
            var priceArray = document.getElementsByName('price');
            for(var i = 0; i < selectArray.length; i++) {
            	totalCost += selectArray[i].value * priceArray[i].value;
            }
            if(typeof totalCost == 'number') {
                $('#total-cost-area').html('Total: \u20AC ' + totalCost);                        	
            }
        });
    });
</script>

 <script>
    setTimeout(function() {
          $("#message").fadeOut();
        }, 3700);
    </script>

</html>
