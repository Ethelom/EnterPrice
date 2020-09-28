<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.model.Customer, group48.enterprice.model.Product, group48.enterprice.model.Supply" %>
<%@ page import="group48.enterprice.model.User" %>
<%@ page import="group48.enterprice.model.Provision" %>
<%@ page import="group48.enterprice.database.ProductDAO" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="group48.enterprice.model.ProductReview" %>
<%@ page import="group48.enterprice.database.ReviewDAO" %>
<%@ page import="group48.enterprice.database.WishlistDAO" %>
<%@ page import="group48.enterprice.utilities.Utility" %>
<%@ page import="group48.enterprice.utilities.Caster" %>
<%@ page errorPage="errorPage.jsp" %>
<!DOCTYPE HTML>
<html lang="en">

<%
Product product = null;
if(request.getParameter("productName") != null) {
    product = new ProductDAO().findProduct(request.getParameter("productName").replace("-", " "));
    if(product != null) {
        session.setAttribute("lastViewedProduct", product);  
    } else {
        throw new Exception("The requested product does not exist!");
    }
}
%>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="author" content="Paris Mpampaniotis - 8170080">
    <meta name="author" content="Theodosis Tsaklanos - 8170136">
    <title><%=product.getProductName() %></title>
    <link rel="icon" href="icons/logo-lg.png" type="image/x-icon">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.css">
    <link rel="stylesheet" href="css/navbar-theme.css">
    <link rel="stylesheet" href="css/core-theme.css">
    <link rel="stylesheet" href="css/table-theme.css">
    <link rel="stylesheet" href="css/rating-theme.css">

    <script src="js/MiniFunctions.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

</head>

<body>
    <style>
        .button-heart {
            background-color: inherit;
            outline: none !important;
            box-shadow: none !important;
            color: #202020;
        }
        
        .button-heart.activated {
            color: #f46353;
        }
        
        .center {
            display: block;
            margin-top: 100px;
            margin-left: auto;
            margin-right: auto;
            width: 50%;
        }

    </style>
   
   <%
   User user = null;
   Customer customer = null;
   if(session.getAttribute("enterpriceUser") != null) {
       user = (User) session.getAttribute("enterpriceUser");
       customer = Caster.castObjectToTypeOfUser(user, Customer.class);
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
   List<Supply> availabilities = new ProductDAO().findStoresThatSellThisProduct(product);
   session.setAttribute("availabilities", availabilities);
   
   List<Supply> allAvailabilities = new ArrayList<Supply>();
   if(session.getAttribute("allAvailabilities") != null) {
       allAvailabilities = (List<Supply>) session.getAttribute("allAvailabilities");
       allAvailabilities.addAll(availabilities);
   } else {
       allAvailabilities = new Utility().cloneList(availabilities);
   }
   session.setAttribute("allAvailabilities", allAvailabilities);
   %>
    <div class="container-fluid" style="margin-top:30px;">

        <div class="col-xs-12 col-sm-6 col-md-4">
            <div class="thumbnail">
                <form method="post" action="wishlistController.jsp">
                    <input type="hidden" id="heartId" name="heart" value='<%=product.getProductName() %>'>
                    <%
                    session.setAttribute("caller",  "viewProduct.jsp"); 
                    %>
                    <button class="btn button-heart">
                        <%
                        String color = "#202020";
                        if(customer != null) {
                            color = customer.hasInWishlist(product) ? "#f46353" : "#202020";                            
                        }
                        %>
                        <i id="heart" class="fa fa-heart fa-2x" style="vertical-align: middle; color:<%=color %>"></i>
                    </button>
                </form>
                <div class="caption text-center">
                    <div class="position-fixed">
                        <img src="<%=product.getProductImage() %>" class="img-size-lg" />
                    </div>

                    <h4 id="thumbnail-label"><a href="#"><%=product.getProductName() %></a></h4>
                    <p><i class="glyphicon glyphicon-list light-red lighter bigger-120"></i> <%=product.getCategory() %></p>
                    <div class="thumbnail-description">
                        <div class="row">
                            <div class="col-xs-12">
                                <div class="table">
                                    <table id="product-details" class="table table-bordered table-hover">
                                        <%
                                        for(Map.Entry<String, String> specsPair : product.getSpecs().entrySet()) {
                                            if(specsPair.getValue() == null) {
                                                continue;
                                            }
                                        %>
                                        <tr>
                                            <th><%=specsPair.getKey() %></th>
                                            <td><%=specsPair.getValue() %></td>
                                        </tr>
                                        <%
                                        }
                                        %>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="caption card-footer text-center">
                        <ul class="list-inline">
                            <li>&nbsp; <i class="glyphicon glyphicon-info-sign lighter"></i> Available at <%=availabilities.size() %> stores</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        
        
        
        <!--Store Cards   -->
        <div class="col-xs-12 col-sm-6 col-md-8">
            <% 
            if(request.getAttribute("reviewMessage") != null) { %>
                <div class="alert alert-danger text-center" role="alert" id="messageBox"><%=(String)request.getAttribute("reviewMessage") %></div>
            <% } %>
            <%if(availabilities.size() > 0) { %>
                <h3>Stores that sell this product:</h3>
                <%int counter = 0; %>
                <%for(Supply supply : availabilities) { %>
                    <div class="thumbnail col-xs-12">
                        <div class="col-xs-12 col-lg-3">
                            <div class="caption text-center">
                                <div class="position-relative">
                                    <h4 id="thumbnail-label"><a href="#"><%=supply.getProvision().getStore().getStoreName() %></a></h4>
                                    <img src="<%=supply.getProvision().getStore().getImage() %>" class="img-size-sm" />
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-12 col-lg-9">
                            <div class="caption" style="text-align: right">
                                <form method="post" action="cartController.jsp">
                                    <div class="position-relative">
                                    <button class="btn btn-round enterprice-blue" name="addToCart" value="<%=counter %>" 
                                        <%if(supply.getStock() == 0) { %> disabled <% }  %>>
                                        <i class="glyphicon glyphicon-shopping-cart" style="font-size:16px;"></i> Add to cart
                                    </button>
                                    </div>
                                </form>
                            </div>
                            <div class="thumbnail-description">
                                <div class="table">
                                    <table id="product-details" class="table table-bordered table-hover">
                                        <tr>
                                            <th>Price</th>
                                            <td><%=supply.getProvision().getPrice() %> &euro;</td>
                                        </tr>
                                        <tr>
                                            <th>Website</th>
                                            <%String website = supply.getProvision().getStore().getWebsite(); %>
                                            <td><a href="<%=website %>" target="_blank"><%=website %></a></td>
                                        </tr>
                                        <tr>
                                            <th>Address</th>
                                            <td><%=supply.getProvision().getStore().getAdInfo().getAddress() %></td>
                                        </tr>
                                        <%if(supply.getStock() == 0) { %>
                                            <tr>
                                                <th>Stock</th>
                                                <td class="alert-danger">
                                                     Out of stock!
                                                </td>
                                            </tr>
                                        <%
                                        }
                                        %>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>     
                <%
                    counter++;
                }
            } else {
            %>    
              <img src="icons/sad-face.png" class="center" />
              <div class="alert alert-warning text-center" style="margin-top:40px; font-size:18px;" role="alert">
                No store sells this product currently!
              </div>
            <%    
            } %>
            
            
        
        <!-- Review Product -->
        <hr>
        <h3>Review this product:</h3>
        <div class="thumbnail col-xs-12">
            <form action="productReviewController.jsp" method="post" id="review_product">
                <div class="caption">
                    <h4>Rate:</h4>
                </div>
                <div class="col-xs-12 col-lg-6">
                    <div class="caption">
                        <div class="position-relative">
                        <input id="rating" name="rating" value="1" type="hidden">
                        <%
                        for(int i = 1; i <=5 ; i++) {
                            %>
                            <span id = "<%=i %>" class="fa fa-star fa-lg <%if(i==1){%>checked<%}else{%>coloronmouse<%}%>" onclick="fillStars(this.id)"></span>
                            <%
                        }
                        %>
                    </div>
                </div>
                </div>
                <br>
                <br>
                <div class="caption">
                    <h4>Write your comments:</h4>
                </div>
                <div class="col-xs-12 col-md-12" style="margin-top: 10px">
                    <div id="textarea-feedback"></div>
                    <br>
                    <textarea class="form-control animated" id="review-body" name="comment" placeholder="Write your comments here..." maxlength="500"></textarea>
                    <div class="form-group">
                        <div class="col-sm-12 col-xs-12" >
                            <button type="submit" class="btn btn-round enterprice-blue" style="margin-top: 10px;margin-bottom: 10px;">
                                <span class="fa fa-check"></span> Submit Review
                            </button>
                            <button type="reset" class="btn btn-round delete-button" onclick="resetForm();resetTextarea()" style="margin-top: 10px;margin-bottom: 10px;">
                                <span class="fa fa-broom"></span> Clear Review
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <%
        List<ProductReview> reviews = new ReviewDAO().findProductReviews(product);
        int[] starCounters = calculateReviewPercentages(reviews);
        double totalReviews = (double) reviews.size();
        double averageRating = calculateMean(starCounters);
        if(averageRating > 0D) {
        %>
            <h3>Rating Breakdown:</h3>
            <div class="thumbnail col-xs-12">
            <div class="col-xs-12 col-md-4">
                <div class="rating-block">
                    <h4>Average user rating</h4>
                    <h2 class="bold padding-bottom-7"><%=averageRating %> <small>/ 5</small></h2>
                    <%
                    for(int button = 1; button < 6; button++) {
                        if(button < averageRating + 0.5) {
                        %>
                            <button type="button" class="btn btn-primary btn-xs" aria-label="Left Align">
                                <span class="glyphicon glyphicon-star" aria-hidden="true"></span>
                            </button>
                        <%  
                        } else {
                        %>
                            <button type="button" class="btn btn-default btn-grey btn-xs" aria-label="Left Align">
                                <span class="glyphicon glyphicon-star" aria-hidden="true"></span>
                            </button>
                        <%    
                        }
                    }
                    %>
                </div>
            </div>
                    
            <div class="col-xs-12 col-md-8" style="margin-top:20px;">
                <%
                for(int i = 4; i >= 0; i--) {
                %>
                    <div class="col-xs-12">  
                        <div class="row">
                            <div id="bar-label" class="pull-left">
                                <div style="height:9px; margin:5px 0;"><%= i+1 %> <span class="glyphicon glyphicon-star"></span></div>
                            </div>
                            <div class="col-xs-8 col-sm-9 col-lg-10">
                                <div class="progress" style="margin:8px 0;">
                                    <%
                                    String barColor = getBarColor(i);
                                    %>
                                    <div class="progress-bar progress-bar-striped <%=barColor %>" role="progressbar" aria-valuenow="<%=i+1 %>" aria-valuemin="0" aria-valuemax="5" 
                                        style="width: <%=(double)starCounters[i] / totalReviews * 100 %>%">
                                    </div>
                                </div>
                            </div>
                            <div class="badge"><%=starCounters[i] %></div>
                        </div>
                    </div>
                <%
                }
                %>
            </div>  
        
        </div>
        
        <h3>Other reviews:<small> (<%=reviews.size() %>)</small></h3>
        <%
        } else { %>
              <div class="alert alert-info text-center col-xs-12" style="margin-top:40px; font-size:18px;" role="alert">
                Would you like to make the first review of this product?
              </div>
        <%    
        }
        %>
        <%for(ProductReview review : reviews) { %>
         <div class="thumbnail col-xs-12">
            <div class="row">
                <div class="col-sm-12">
                    <%
                    if(session.getAttribute("enterpriceUser") != null) { 
                        if(review.getUsername().equals(user.getUsername())) {  
                        %>
                        <div class="pull-right" style="margin-top: 5px; margin-right: 10px">
                            <a href="productReviewController.jsp?deleteReviewFor=<%=review.getProduct().getProductName()%>" class="text-dark">
                                <i class="fa fa-times fa-lg"></i>
                            </a>
                        </div>
                        <%
                        }
                    }
                    %>
                    <div class="review-block">
                        <div class="row">
                            <div class="col-sm-3">
                                <div class="review-block-name"><a href="#"><%=review.getUsername() %></a></div>
                                <div class="review-block-date"><%=review.getTimestamp() %></div>
                            </div>
                            <div class="col-sm-9">
                            <div class="review-block-rate">
                                <%
                                int blueStarCounter = 1;
                                for(int i=0; i<5; i++) {
                                    if(blueStarCounter <= review.getRating()) { blueStarCounter++; %>
                                        <button type="button" class="btn btn-primary btn-xs" aria-label="Left Align">
                                            <span class="glyphicon glyphicon-star" aria-hidden="true"></span>
                                        </button>
                                    <%
                                    } else { %>
                                        <button type="button" class="btn btn-default btn-grey btn-xs" aria-label="Left Align">
                                            <span class="glyphicon glyphicon-star" aria-hidden="true"></span>
                                        </button>
                                    <%    
                                    }
                                }
                                %>
                            </div>
                            <div class="review-block-description"><%=review.getReviewBody() %></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%    
        } %>   
        </div>
    </div>
    
    <script>
    setTimeout(function() {
    	  $("#messageBox").fadeOut();
    	}, 3700);
    </script>
    
    <script>
    function resetTextarea() {
    	$('#textarea-feedback').html(500 + ' characters remaining');  
    }
    </script>
    
    <script>
    $(document).ready(function() {
        var text_max = 500;

        $('#review-body').keyup(function() {
            var text_length = $('#review-body').val().length;
        	var text_remaining = text_max - text_length;
            $('#textarea-feedback').html(text_remaining + ' characters remaining');            
        });
    });
    </script>
    
    <%!
    private int[] calculateReviewPercentages(List<ProductReview> reviews) {
        int[] starCounters = new int[5];
        for(ProductReview review : reviews) {
            starCounters[review.getRating() - 1] += 1;
        }
        return starCounters;
    }
    
    private double calculateMean(int[] frequencies) {
        int sum = 0;
        int denominator = 0;
        for(int i = 0; i < frequencies.length; i++) {
            sum += frequencies[i] * (i+1);
            denominator += frequencies[i];
        }
        try {
            double mean = (double) sum/denominator;
            return Math.round(mean * 10) / 10.0;
        } catch(ArithmeticException e) {
            return 0;
        }
    }
    
    private String getBarColor(int i) {
        String barColor = "";
        switch(i) {
        case 4:
            barColor = "progress-bar-enterprice-blue";
            break;
        case 3:
            barColor = "progress-bar-success";
            break;
        case 2: 
            barColor = "progress-bar-info";
            break;
        case 1:
            barColor = "progress-bar-warning";
            break;
        case 0:
            barColor = "progress-bar-danger";
            break;
        }
        return barColor;
    }
    
    %>
   <jsp:include page="footer.jsp" />
</body>

</html>
