<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.model.User" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="Efthymia Kostaki- 8170055">
    <meta name="author" content="Paris Mpampaniotis - 8170080">
    <meta name="author" content="Theodosis Tsaklanos - 8170136">
    <title>About us - EnterPrice</title>
    <link rel="icon" href="icons/logo-lg.png" type="image/x-icon">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.css">
    <link rel="stylesheet" href="css/navbar-theme.css">
    <link rel=stylesheet href="css/core-theme.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>

<body>
    <style>
        body {
            background: url(wallpapers/background-bit-bytes-2004161.jpg) no-repeat;
            background-position: center;
            background-size: cover;
        }

    </style>
    
    <%
    User user = null;
    if(session.getAttribute("enterpriceUser") != null) {
        user = (User) session.getAttribute("enterpriceUser");
        %><jsp:include page="<%=user.getNavbarSrc() %>" /><%
    } else {
        %><jsp:include page="defaultNavbar.jsp"></jsp:include><%
    }
    %>
    
    <div class="container">
        <div class="row">
            <div class="col-md-offset-3 col-md-3">
                <div class="thumbnail" style="background-color: aliceblue">
                    <img class="img-responsive" src="developers/Theodosis.jpg" alt="Theodosis Tsaklanos" style="border-radius: 5%">
                    <div class="caption">
                        <h3><b>Theodosis<br>Tsaklanos</b><br><small>8170136</small></h3>
                        <p><span class="glyphicon glyphicon-envelope" aria-hidden="true"></span><a href="mailto:"> t8170136@aueb.gr</a> </p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="thumbnail" style="background-color: aliceblue">
                    <img class="img-responsive" src="developers/Effie.jpg" alt="Efthymia Kostaki" style="border-radius: 5%">
                    <div class="caption">
                        <h3><b>Efthymia<br>Kostaki</b><br><small>8170055</small></h3>
                        <p><span class="glyphicon glyphicon-envelope" aria-hidden="true"></span><a href="mailto:"> t817055@aueb.gr</a> </p>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-offset-3 col-md-3">
                    <div class=" thumbnail" style="background-color: aliceblue">
                        <img class="img-responsive" src="developers/Paris.jpg" alt="Paris Mpampaniotis" style="border-radius: 5%">
                        <div class="caption">
                            <h3><b>Paris<br>Mpampaniotis</b><br><small>8170080</small></h3>
                            <p><span class="glyphicon glyphicon-envelope" aria-hidden="true"></span><a href="mailto:"> t8170080@aueb.gr</a> </p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="thumbnail" style="background-color: aliceblue">
                        <img class="img-responsive" src="developers/Nikolas.jpg" alt="Nikolas Tamvakis" style="border-radius: 5%">
                        <div class="caption">
                            <h3><b>Nickolas<br>Tamvakis</b><br><small>8170131</small></h3>
                            <p><span class="glyphicon glyphicon-envelope" aria-hidden="true"></span><a href="mailto:"> t8170131@aueb.gr</a> </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />

</body>

</html>
    