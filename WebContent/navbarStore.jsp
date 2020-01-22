<%@ page import="group48.enterprice.model.Store" %>
<%@ page import="group48.enterprice.utilities.Caster" %>
<%@ page errorPage="errorPage.jsp" %>
<%
Store store = null;
if(session.getAttribute("enterpriceUser") != null) {
    store = Caster.castObjectToTypeOfUser(session.getAttribute("enterpriceUser"), Store.class);
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
                <a href="aboutModal" data-toggle="modal" data-target="#aboutModal" class="navbar-brand">EnterPrice
                </a>
            </div>
            <div id="navbar" class="collapse navbar-collapse">
                <ul class="nav navbar-nav">
                    <li class="active"><a href="homePageStore.jsp">Home</a></li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown">
                        <img class="dropdown-toggle" src="icons/online-store.png" alt="Profile Picture" data-toggle="dropdown" class="img-responsive">
                        <ul id="dropdown-menu-1" class="dropdown-menu">
                            <li><a href="editProfile.jsp"><i class="fa fa-user"></i> My Profile</a></li>
                            <li><a href="previousOrders.jsp"><i class="fa fa-box"></i> My Orders</a></li>
                            <li><a href="logout.jsp"><i class="fa fa-power-off" style="color: rgb(200,0,0)"></i> Log Out</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
            <!--/.nav-collapse -->
        </div>
    </nav>