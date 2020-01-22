<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <meta name="author" content="Paris Mpampaniotis - 8170080">
    <meta name="author" content="Theodosis Tsaklanos - 8170136">
    <meta name="author" content="Efthymia Kostaki - 8170055">
    <meta name="author" content="Nickolas Tamvakis - 8170131">

    <title>EnterPrice - Register</title>
    <link rel="icon" href="icons/logo-lg.png" type="image/x-icon">

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700" rel="stylesheet">
    <link rel="stylesheet" href="css/core-theme.css">
    <link rel="stylesheet" href="css/register-theme.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>

<body>
    <main>
        <div class="scene">
            <div class="container">
                <div class="card-container">
                    <div class="card-flip">
                        <div class="card front">
                            <div class="signup-control">
                                <form class="form-horizontal" action="registerCustomerController.jsp" method="post" id="front">
                                    <h2>Create Customer Account</h2>
                                    <hr>  
                                    <% 
                                    if(request.getAttribute("customerMessage") != null) { %>
                                        <div class="alert alert-danger text-center" role="alert"><%=(String)request.getAttribute("customerMessage") %></div>
                                    <% } %>
                                    <br>
                                    <div class="row">
                                        <div class="col-xs-12">
                                            <input type="text" name="fullname" placeholder="&#xf2c1; Fullname" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-xs-12 col-md-6">
                                            <input type="text" name="username" placeholder="&#xf007; Username" maxlength="20" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>

                                        <div class="col-xs-12 col-md-6">
                                            <input type="email" name="email" placeholder="&#xf1d8; Email Address" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-xs-12 col-md-6">
                                             <select class="form-control select" id="country" name="country" style="border-top-right-radius: 0px; border-bottom-right-radius: 0px" required="required">
                                                <%
                                                String[] locales = Locale.getISOCountries();
                                                
                                                for (String countryCode : locales) {
                                                    String country = new Locale("", countryCode).getDisplayCountry();
                                                    String selected = "";
                                                %>
                                                    <option value="<%=country %>"> <%=country %></option>                            
                                                <%
                                                }
                                                %>
                                            </select>
                                        </div>
                                        <div class="col-xs-12 col-md-6">
                                            <input type="text" name="city" placeholder="&#xf1ad; City" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>
                                    </div>

                                    <div class="row">

                                        <div class="col-xs-12 col-md-6">
                                            <input type="text" name="address" placeholder="&#xf041; Address" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>

                                        <div class="col-xs-12 col-md-6">
                                            <input type="text" name="zip" placeholder="&#xf0d1; Zip" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>

                                    </div>


                                    <div class="row">
                                        <div class="col-xs-12 col-md-6">
                                            <input type="password" name="password" placeholder="&#xf023; Password" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>

                                        <div class="col-xs-12 col-md-6">
                                            <input type="password" name="confirm_password" placeholder="&#xf023; Confirm Password" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>
                                    </div>

                                    <div class="text-center">
                                        <button id="signUpAsStoreButton" type="submit" class="btn enterprice-blue">Sign Up</button>
                                    </div>
                                    <p class="meduim text-center">Not a customer?<br><a href="#" onclick="flip()">Sign up as a store here.</a></p>
                                </form>
                            </div>
                            <br>

                            <div class="text-center">
                                Already have an account?<br>
                                <a href="login.jsp">Login here</a>.</div>
                        </div>


                        <div class="card back">
                            <div class="signup-control">
                                <form class="form-horizontal" action="registerStoreController.jsp" method="post" name="storeRegisterForm" id="back">
                                    <h2>Create Store Account</h2>
                                    <hr>
                                    <% 
                                    if(request.getAttribute("storeMessage") != null) { %>
                                        <div class="alert alert-danger text-center" role="alert"><%=(String)request.getAttribute("storeMessage") %></div>
                                    <% } %>
                                    <br>
                                    <div class="row">
                                        <div class="col-xs-12 col-md-6">
                                            <input type="text" name="store_name" placeholder="&#xf2c1; Store Name" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>
                                        <div class="col-xs-12 col-md-6">
                                            <input type="text" name="owner_name" placeholder="&#xf2c1; Owner Name" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-xs-12 col-md-6">
                                            <input type="text" name="bank_account_number" placeholder="&#xf19c; Bank Account Number" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>
                                        <div class="col-xs-12 col-md-6">
                                            <input type="url" name="website" placeholder="&#xf0c1; Website" style="font-family: sans-serif, FontAwesome">
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-xs-12 col-md-6">
                                            <input type="text" name="username" maxlength="20" placeholder="&#xf007; Username" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>

                                        <div class="col-xs-12 col-md-6">
                                            <input type="email" name="email" placeholder="&#xf1d8; Email Address" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-xs-12 col-md-6">
                                             <select class="form-control select" id="country" name="country" style="border-top-right-radius: 0px; border-bottom-right-radius: 0px" required="required">
                                                <%
                                                for (String countryCode : locales) {
                                                    String country = new Locale("", countryCode).getDisplayCountry();
                                                    String selected = "";
                                                %>
                                                    <option value="<%=country %>"> <%=country %></option>                            
                                                <%
                                                }
                                                %>
                                            </select>
                                        </div>
                                        <div class="col-xs-12 col-md-6">
                                            <input type="text" name="city" placeholder="&#xf1ad; City" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>
                                    </div>

                                    <div class="row">

                                        <div class="col-xs-12 col-md-6">
                                            <input type="text" name="address" placeholder="&#xf041; Address" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>

                                        <div class="col-xs-12 col-md-6">
                                            <input type="text" name="zip" placeholder="&#xf0d1; Zip" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>

                                    </div>


                                    <div class="row">
                                        <div class="col-xs-12 col-md-6">
                                            <input type="password" name="password" placeholder="&#xf023; Password" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>

                                        <div class="col-xs-12 col-md-6">
                                            <input type="password" name="confirm_password" placeholder="&#xf023; Confirm Password" style="font-family: sans-serif, FontAwesome" required="required">
                                        </div>
                                    </div>


                                    <div class="text-center">
                                        <button type="submit" class="btn enterprice-blue">Sign Up</button>
                                    </div>

                                    <p class="meduim text-center">Not a store?<br><a href="#" onclick="flip()">Sign up as a customer here.</a></p>
                                </form>
                            </div>
                            <br>

                            <div class="text-center" style="margin-bottom: 20px">
                                Already have an account?<br>
                                <a href="login.jsp">Login here</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <script>
    
        function triggerClick() {
            document.getElementById("signUpAsStoreButton").trigger('click');
        }
    
        function flip() {
            $('.card-flip').toggleClass('flip');
        }

    </script>
</body>

</html>
