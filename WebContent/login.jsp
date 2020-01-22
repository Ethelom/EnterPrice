<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="author" content="Theodosis Tsaklanos - 8170136">
    <title>EnterPrice - Login</title>
    <link rel="icon" href="icons/logo-lg.png" type="image/x-icon">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.css">
    <link rel="stylesheet" href="css/login-theme.css">
    <link rel="stylesheet" href="css/christmas-theme.css">

</head>

<body>
    <style>
        main {
            height: 100vh;
            background: url(wallpapers/minimal_tech_background.jpg) fixed no-repeat;
            background-position: center;
            background-size: cover;
        }

    </style>
    
<div class="snowflakes" aria-hidden="true" id="snowflakes">
  <div class="snowflake">
  ❅
  </div>
  <div class="snowflake">
  ❅
  </div>
  <div class="snowflake">
  ❆
  </div>
  <div class="snowflake">
  ❄
  </div>
  <div class="snowflake">
  ❅
  </div>
  <div class="snowflake">
  ❆
  </div>
  <div class="snowflake">
  ❄
  </div>
  <div class="snowflake">
  ❅
  </div>
  <div class="snowflake">
  ❆
  </div>
  <div class="snowflake">
  ❄
  </div>
  <div class="snowflake">
  ❆
  </div>
  <div class="snowflake">
  ❄
  </div>
  <div class="snowflake">
  ❅
  </div>
  <div class="snowflake">
  ❄
  </div>
  <div class="snowflake">
  ❆
  </div>
</div>

    <main>
        <div id="container">
            <form method="post" action="loginController.jsp">
                <img src="icons/logo-lg.png"><br>
                <input type="text" name="username" placeholder="&#xf007; Username" maxlength="20" style="font-family: sans-serif, FontAwesome" maxlength="20" required><br>
                <input type="password" name="password" placeholder="&#xf023; Password" style="font-family: sans-serif, FontAwesome" required><br>
                <input type="submit" value="SIGN IN"><br>
                <span><a href="#">Forgot Password?</a></span><br><br>
                <span>No account? <a href="register.jsp">Register here</a></span>
            </form>
        </div>
            <% 
            if(request.getAttribute("message") != null) { %>
                <div class="alert alert-danger text-center" role="alert"><%=(String)request.getAttribute("message") %></div>
            <% } %>
            
            <% 
            if(request.getAttribute("successRegisterMessage") != null) { %>
                <div class="alert alert-success text-center" role="alert"><%=(String)request.getAttribute("successRegisterMessage") %></div>
            <% } %>
    </main>
</body>

</html>
