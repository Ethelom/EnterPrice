<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.database.UserDAO"%>
<%@ page import="group48.enterprice.model.Avatar" %>
<%@ page import="group48.enterprice.model.Store"%>
<%@ page import="group48.enterprice.model.User"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>

<%@ page errorPage="errorPage.jsp" %>


<!DOCTYPE HTML>

<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">

    <meta name="author" content="Nickolas Tamvakis - 8170131">

    <title>EnterPrice - MyProfile</title>
    <link rel="icon" href="icons/logo-lg.png" type="image/x-icon">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.css">
    <link rel="stylesheet" href="css/navbar-theme.css">
    <link rel="stylesheet" href="css/core-theme.css">
    <link rel="stylesheet" href="css/edit-profile-theme.css">


    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>
<style>
 body {
     background: url(wallpapers/art-art-materials-bright-743986.jpg) fixed no-repeat;
     background-position: center;
     background-size: cover;
 }
</style>
<body>
    <%
    User user = null;
    LinkedHashMap<String, Integer> statistics = null;
    if(session.getAttribute("enterpriceUser") != null) {
        user = (User)session.getAttribute("enterpriceUser");
        UserDAO udao = user.getDAO();
        statistics = udao.getUserStatistics();
    } else {
        request.setAttribute("message", "You are not authorised to access this source! Please log in to continue!");
        %>
        <jsp:forward page="login.jsp"></jsp:forward>
        <%
    }
    %> 
   
    <jsp:include page="<%=user.getNavbarSrc() %>" />

    <div class="container-fluid" style="margin:50px 0;">
        <div class="col-md-3">
            <div class="thumbnail">
                <div class="caption text-center">
                </div>

                <div class="position-relative text-center">
                    <a href="avatarPickerModal" data-toggle="modal" data-target="#avatarPickerModal">
                    <img class="img-size-sm" src="<%=user.getImage() %>" style="margin-bottom: 10px; border-radius: 50%; border:2px solid black;">
                    </a>
                </div>
                               
                <div class="thumbnail-description">
                    <hr>
                    <div class="text-center">
                        <h3><i class="fa fa-chart-line" style="color:#315b96"></i> Statistics</h3>
                    </div>
                    <div class="text-center">
                        <ul class="list-group">
                            <%for(Map.Entry<String, Integer> stat : statistics.entrySet()) { %>
                            <li class="list-group-item"><b><%=stat.getKey() %>:</b> <%=statistics.get(stat.getKey()) %></li>
                            <%} %>
                        </ul>
                    </div>
                </div>

            </div>
        </div>

        <div class="col-sm-12 col-md-6">
            <% 
            if(request.getAttribute("editProfileMessage") != null) { %>
                <div class="alert alert-danger text-center" id="editProfileMessage" role="alert"><%=(String)request.getAttribute("editProfileMessage") %></div>
            <% } %>
            <div class="thumbnail" style="background-color: aliceblue">
                <div class="caption text-center">
                    <h2>Account Info</h2>
                    <hr>
                    <br>
                </div>
                <form class="form-horizontal" method="post" action="editProfileController.jsp">

                    <div class="form-group">
                        <label for="username" class="col-sm-2 col-md-offset-1 control-label">Username: </label>
                        <div class="col-sm-10 col-md-8 col-lg-6">
                            <input type="text" id="username" name="username" class="form-control" placeholder="<%=user.getUsername() %>" readonly>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="username" class="col-sm-2 col-md-offset-1 control-label">Fullname: </label>
                        <div class="col-sm-10 col-md-8 col-lg-6">
                            <input type="text" id="fullname" name="fullname" class="form-control" placeholder="<%=user.getFullname() %>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="email" class="col-sm-2 col-md-offset-1 control-label">Email: </label>
                        <div class="col-sm-10 col-md-8 col-lg-6">
                            <input type="email" id="email" name="email" class="form-control" placeholder="<%=user.getEmail() %>">
                        </div>
                    </div>
                     <div class="form-group">
                      <label for="sel1" class="col-sm-2 col-md-offset-1 control-label">Country:</label>
                        <div class="col-sm-10 col-md-8 col-lg-6">
                        <select class="form-control" id="country" name="country" style="border-top-right-radius: 0px; border-bottom-right-radius: 0px">
                            
                            <%
                            String[] locales = Locale.getISOCountries();
                            for (String countryCode : locales) {
                                String country = new Locale("", countryCode).getDisplayCountry();
                                String selected = "";
                                if(country.equals(user.getAdInfo().getCountry())) {
                                    selected = "selected";
                                }
                            %>
                                <option value="<%=country %>" <%=selected%>> <%=country %></option>                            
                            <%
                            }
                            %>
                        </select>
                      </div>
                    </div> 
                    <div class="form-group">
                        <label for="city" class="col-sm-2 col-md-offset-1 control-label">City: </label>
                        <div class="col-sm-10 col-md-8 col-lg-6">
                            <input type="text" id="city" name="city" class="form-control" placeholder="<%=user.getAdInfo().getCity() %>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="address" class="col-sm-2 col-md-offset-1 control-label">Address: </label>
                        <div class="col-sm-10 col-md-8 col-lg-6">
                            <input type="text" id="address" name="address" class="form-control" placeholder="<%=user.getAdInfo().getAddress() %>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="address" class="col-sm-2 col-md-offset-1 control-label">Zip: </label>
                        <div class="col-sm-10 col-md-8 col-lg-6">
                            <input type="text" id="zip" name="zip" class="form-control" placeholder="<%=user.getAdInfo().getZip() %>">
                        </div>
                    </div>
                    <%
                    
                    if(user instanceof Store) {
                        Store store = (Store) user;
                        
                    %>
                    <div class="form-group">
                        <label for="address" class="col-sm-2 col-md-offset-1 control-label">Website: </label>
                        <div class="col-sm-10 col-md-8 col-lg-6">
                            <input type="text" id="website" name="website" class="form-control" placeholder="<%=store.getWebsite() %>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="address" class="col-sm-2 col-md-offset-1 control-label">IBAN: </label>
                        <div class="col-sm-10 col-md-8 col-lg-6">
                            <input type="text" id="accountNumber" name="accountNumber" class="form-control" placeholder="<%=store.getAccountNumber() %>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="address" class="col-sm-2 col-md-offset-1 control-label">Store Name: </label>
                        <div class="col-sm-10 col-md-8 col-lg-6">
                            <input type="text" id="storeName" name="storeName" class="form-control" placeholder="<%=store.getStoreName() %>">
                        </div>
                    </div>
                                            
                    <% } %>
                    
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-3 col-md-offset-3 col-md-4 col-lg-3" style="margin-top: 20px;">
                            <button type="submit" class="btn btn-round enterprice-blue" name="updateAccountButton">
                                <span class="fa fa-check"></span> Save Changes
                            </button>
                        </div>
                    </div>

                 </form>  
            </div>                 

        </div>
        <div class="col-sm-12 col-md-3">
            <% 
            if(request.getAttribute("wrongPasswordMessage") != null) { %>
                <div class="alert alert-danger text-center" id="editProfileMessage" role="alert"><%=(String)request.getAttribute("wrongPasswordMessage") %></div>
            <% } %>
            <!-- password card -->
            <div class="thumbnail" style="background-color:aliceblue">
                <div class="caption text-center">
                    <h2>Change Password</h2>
                    <hr>
                    <br>
                </div>
                 <form class="form-horizontal" method="post" action="updatePasswordController.jsp">
                                     <div class="form-group">
                        <label for="password" class="col-xs-2 control-label">Password: </label>
                        <div class="col-sm-10 col-md-12">
                            <input type="password" id="password" name="password" class="form-control" placeholder="<%=user.getPassword().replaceAll(".", "*") %>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="confirm_password" class="col-sm-2 control-label">Confirm: </label>
                        <div class="col-sm-10 col-md-12">
                            <input type="password" id="confirm_password" name="confirm_password" class="form-control" placeholder="<%=user.getPassword().replaceAll(".", "*") %>">
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-10 col-md-offset-0" style="margin-top: 20px;">
                            <button type="submit" class="btn btn-round enterprice-blue">
                                <span class="fa fa-lock"></span> Change Password
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        
        <div id="avatarPickerModal" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Pick an avatar:</h4>
                </div>
                <div class="modal-body">
                    <form method="post" action="editProfileController.jsp">
                        <div style="margin-bottom: 15px">
                        <%
                        List<Avatar> avatarKeeper;
                        if(session.getAttribute("avatarKeeper") != null) {
                            avatarKeeper = (List<Avatar>) session.getAttribute("avatarKeeper");
                        } else {
                            avatarKeeper = new ArrayList<Avatar>(loadAvatars());
                            session.setAttribute("avatarKeeper", avatarKeeper);
                        }
                        for(Avatar avatar : avatarKeeper) {
                        %>
                            <img src="<%=avatar.getSrc() %>" class="avatar">
                        <%
                        }
                        %>
                        <input type="hidden" id="h" name="keep-profile-picture-src">
                        </div> 
                        <button type="submit" class="btn btn-round enterprice-blue">Update profile picture</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    </div>
    
    <%!
    protected ArrayList<Avatar> loadAvatars() throws Exception {
        ArrayList<Avatar> avatars = new ArrayList<Avatar>();
        try {
            for(String avatarSrc : new UserDAO().loadAvatars()) {
                avatars.add(new Avatar(avatarSrc));
            }
            return avatars;
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }
    }
    %>
    
    <script>
    setTimeout(function() {
          $("#editProfileMessage").fadeOut();
        }, 4000);
    </script>
    
    <script>
    $('.avatar').click(function() {
        var $this = $(this);
        if ($this.hasClass('activated')) {
            $this.removeClass('activated');
        } else {
            $('.activated').removeClass('activated');
            $this.addClass('activated');
            var selectedPic = $(this).attr('src');
            document.getElementById('h').value = selectedPic;
        }
    });
    </script>
    <jsp:include page="footer.jsp"></jsp:include>
    
</body>

</html>
    