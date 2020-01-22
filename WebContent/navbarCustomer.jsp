<%@ page import="group48.enterprice.model.User , group48.enterprice.model.Customer" %>
<%@ page import="group48.enterprice.utilities.Caster" %>
<%@ page errorPage="errorPage.jsp" %>
<%
Customer customer = null;
if(session.getAttribute("enterpriceUser") != null) {
    customer = Caster.castObjectToTypeOfUser(session.getAttribute("enterpriceUser"), Customer.class);
}
%>
<nav class="navbar navbar-static-top">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar" id="three-stripes">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a href="aboutModal" data-toggle="modal" data-target="#aboutModal" class="navbar-brand">EnterPrice</a>
            </div>
            <div id="navbar" class="collapse navbar-collapse">
                <ul class="nav navbar-nav">
                    <li class="active"><a href="homePage.jsp">Home</a></li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown">
                        <img class="dropdown-toggle" src="icons/navbar-user-icon.png" alt="Profile Picture" data-toggle="dropdown" class="img-responsive">
                        <ul class="dropdown-menu">
                            <li><a href="cart.jsp"><i class="fa fa-shopping-cart"></i> My Cart <span class="badge"><%=customer.getCart().getProducts().size() %></span></a></li>
                            <li><a href="editProfile.jsp"><i class="fa fa-user"></i> My Profile</a></li>
                            <li><a href="previousOrders.jsp"><i class="fa fa-bookmark"></i> My Products</a></li>
                            <li><a href="wishlist.jsp"><i class="fa fa-heart" ></i> My Favorites</a></li>
                            <!--<li role="presentation" class="divider"></li> -->
                            <li><a href="logout.jsp"><i class="fa fa-power-off" style="color: rgb(200,0,0)"></i> Log Out</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
            <!--/.nav-collapse -->
        </div>
    </nav>