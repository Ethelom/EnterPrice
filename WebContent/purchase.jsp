<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.model.Cart" %>
<%@ page import="group48.enterprice.model.Customer" %>
<%@ page import="group48.enterprice.model.LineItem" %>
<%@ page import="group48.enterprice.model.Product" %>
<%@ page import="group48.enterprice.model.Provision" %>
<%@ page import="group48.enterprice.utilities.Caster" %>
<%@ page import="group48.enterprice.exceptions.IntruderException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page errorPage="errorPage.jsp" %>
<%
request.setCharacterEncoding("UTF-8");
Customer customer = null;
double cost = 0D;
if(session.getAttribute("enterpriceUser") != null) {
        customer = Caster.castObjectToTypeOfUser(session.getAttribute("enterpriceUser"), Customer.class);
        String[] selectValues = request.getParameterValues("selectQuantity");
        int counter = 0;
        Cart cart = customer.getCart();
        List<LineItem> productsToBePurchased = new ArrayList<LineItem>();
        for(LineItem item : customer.getCart().getProducts()) {
            int quantity = 0;
            try {
                quantity = Integer.parseInt(selectValues[counter]);
            } catch(NumberFormatException e) {
                request.setAttribute("message", "Quantity has to be an integer!");
                %><jsp:forward page="cart.jsp"></jsp:forward> <%
            }
            if(quantity > 0) {
                item.setQuantity(quantity);                
                double price = item.getProvision().getPrice();
                cost += price * quantity;
                counter++;
            } else {
                throw new IllegalArgumentException("Quantity cannot be negative or zero!");
            }
        }
        session.setAttribute("purchaseCart", cart);
} else {
    request.setAttribute("message", "You are not authorised to access this source! Please log in to continue!");
    %><jsp:forward page="login.jsp"></jsp:forward> <%
}
%>
<!DOCTYPE HTML>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <meta name="author" content="Theodosis Tsaklanos - 8170136">
    <meta name="author" content="Paris Mpampaniotis - 8170080">

    <title>EnterPrice - Purchase</title>
    <link rel="icon" href="icons/logo-lg.png" type="image/x-icon">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.css">
    <link rel="stylesheet" href="css/navbar-theme.css">
    <link rel="stylesheet" href="css/core-theme.css">
    <link rel="stylesheet" href="css/purchase-theme-2.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>

<body>
    <jsp:include page="<%=customer.getNavbarSrc() %>" />
    <div class="container" style="margin-top: 30px">
        <div class="thumbnail">
            <div class="signup-control">
                <form class="form-horizontal" action="purchaseController.jsp" method="post">
                    <div class="caption text-center">
                        <h2>Recipient's Info</h2>
                    </div>
                    <hr>
                    <br>
                    <br>
                    <br>
                    <div>
                        <div class="row">
                            <div class="col-xs-12">
                                <input type="text" name="fullname" placeholder="&#xf2c1; Fullname" value="<%=customer.getFullname() %>" required="required">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-xs-12 col-md-6">
                                <input type="text" name="country" placeholder="&#xf57e; Country" value="<%=customer.getAdInfo().getCountry() %>" required="required">
                            </div>
                            <div class="col-xs-12 col-md-6">
                                <input type="text" name="city" placeholder="&#xf1ad; City" value="<%=customer.getAdInfo().getCity() %>" required="required">
                            </div>
                        </div>

                        <div class="row">

                            <div class="col-xs-12 col-md-6">
                                <input type="text" name="address" placeholder="&#xf041; Address" value="<%=customer.getAdInfo().getAddress() %>" required="required">
                            </div>

                            <div class="col-xs-12 col-md-6">
                                <input type="text" name="zip" placeholder="&#xf0d1; Zip" value="<%=customer.getAdInfo().getZip() %>" required="required">
                            </div>

                        </div>

                        <div class="row">
                            <div class="col-xs-12 col-md-6">
                                <input type="text" name="phone" placeholder="&#xf095; Phone number" required="required" maxlength="10">
                            </div>
                        </div>

                        <!--Payment method -->


                        <div class="col-md-12 text-left">
                            <h2>Payment method</h2>
                            <p><i>Turn on PayPal payment in case you want.</i></p>
                            <i class="fab fa-paypal" style="color:#315b96; font-size:32px;"></i>
                            <label class="switch">
                                <input type="checkbox" name="paymentMethodToggle" onclick="disappear()" autocomplete="off">
                                <span class="slider"></span>
                            </label>
                            <br>
                        </div>

                        <div id="card-payment">
                            <!--Card payment -->
                            <div class="row">
                                <div class="text-center">
                                    <h2>Card Payment</h2>
                                </div>
                                <hr>
                                <div class="col-md-6">
                                    <br>
                                    <br>
                                    <br>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <input type="text" id="cardName" placeholder="&#xf2c2; Card Name" value="<%=customer.getFullname() %>" required>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <input type="text" id="cardNumber" placeholder="&#xf09d; Card Number" required>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4">
                                            <input type="text" id="expYear" placeholder="&#xf057; Expiration YY" required>
                                        </div>

                                        <div class="col-md-4">
                                            <input type="text" id="expMonth" placeholder="&#xf057; Expiration MM" required>
                                        </div>
                                        <div class="col-md-4">
                                            <input type="text" id="cvv" placeholder="&#xf022; CVV" required>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-6 text-left">
                                    <br>
                                    <br>
                                    <div class="text-center">
                                        <h2>Accepted Cards</h2>
                                    </div>
                                    <div class="col-md-8 col-md-offset-2">
                                        <div class="icon-container">
                                            <ul>
                                                <li><i class="fab fa-cc-mastercard" style="color: orangered; font-size: 32px;"></i> Mastercard</li>
                                                <li><i class="fab fa-cc-visa" style="color:navy; font-size:32px"></i> Visa</li>
                                                <li><i class="fab fa-cc-amex" style="color:blue; font-size:32px"></i> American Express</li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>

                    </div>

                    <div class="row text-center">
                        <div class="col-xs-6 col-xs-offset-6 col-sm-3 col-sm-offset-9 col-md-2 col-md-offset-10">
                            <div class="form-group">
                                <label>Total: &euro; <%=cost %></label>
                                <input type="hidden" name="totalCost" value="<%=cost%>">
                                <button type="submit" class="btn btn-round enterprice-blue" style="margin-bottom: 15px; font-size: 16px; font-weight: 550; width: 50%">
                                    Pay
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

        </div>
    </div>


    <script>
    /* Η συνάρτηση αυτή  ρυθμίζει εάν θα φαίνεται η φόρμα συμπλήρωσης των στοιχείων της κάρτας και ενεργοποείται κάθε φορά που ο χρήστης χρησιμοποιεί το toggle button. */
        function disappear() {
        	var $inputs = $('#card-payment :input');
        	var ids = {};
            $inputs.each(function (index)
            {
            	ids[index] = $(this).attr('id');
            });
    	
            var cardBlock = document.getElementById("card-payment");
            if (cardBlock.style.display === "none") {
                cardBlock.style.display = "block";
                for(var i = 0; i < $inputs.length; i++) {
                	document.getElementById(ids[i]).setAttribute("required", "");
                }
            } else {
                cardBlock.style.display = "none";
                for(var i = 0; i < $inputs.length; i++) {
                	document.getElementById(ids[i]).removeAttribute("required");
                }
            }
            
        }

    </script>
<jsp:include page="footer.jsp"></jsp:include>
</body>
