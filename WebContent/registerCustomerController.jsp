<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.database.UserDAO" %>
<%@ page import="group48.enterprice.model.AddressInfo" %>
<%@ page import="group48.enterprice.model.Customer" %>
<%@ page import="group48.enterprice.model.User" %>
<%@ page import="group48.enterprice.utilities.Validator" %>
<%@ page import="group48.enterprice.utilities.PasswordValidator" %>
<%@ page import="group48.enterprice.utilities.UserDataValidator" %>
<%@ page import="org.eclipse.jdt.core.compiler.InvalidInputException" %>

<%@include file = "registerController.jsp" %>

<%
request.setCharacterEncoding("utf-8");

    String customerMessage = "";
    UserDataValidator validator = new UserDataValidator();
    
    String username = request.getParameter("username");
    try {
        if(usernameIsUnique(username)) {
            if(username.trim().isEmpty()) {
                customerMessage = "Username must not be epmty!";          
            }
        }else {
            customerMessage ="Username is already taken!"; 
        }
    }catch (Exception e) {
            customerMessage = e.getMessage();
    }

    String fullname = request.getParameter("fullname");
    if(!fullname.trim().isEmpty()) {
        try {
            validator.fullnameIsValid(fullname);
        } catch(InvalidInputException e) {
            customerMessage = e.getMessage();
        }
    } else {
        customerMessage ="Fullname must not be epmty!";          
    }
    
    String email = request.getParameter("email");
    if(!email.trim().isEmpty()) {
        try {
          validator.emailIsValid(email, 45);
          
        } catch(InvalidInputException e) {
        customerMessage = e.getMessage();
        }
    }else {
        customerMessage = "Email must not be epmty!";
    }
    
    String country = request.getParameter("country");
    if(!country.trim().isEmpty()) {
        try {
            validator.countryIsValid(country);
        } catch(InvalidInputException e) {
            customerMessage = e.getMessage();
        }
    } else {
        customerMessage = "Country must not be epmty!";
    }
    
    String city = request.getParameter("city");
    if(!city.trim().isEmpty()) {
        try {
            validator.cityIsValid(city);
        } catch(InvalidInputException e) {
            customerMessage = e.getMessage();
        }
    } else {
        customerMessage = "City must not be epmty!";
    }
    
    String address = request.getParameter("address");
    if(!address.trim().isEmpty()) {
       try { 
           validator.addressIsValid(address, 100);
       } catch(InvalidInputException e) {
           customerMessage =e.getMessage();
       }
    } else {
        customerMessage = "Address must not be epmty!";
    }
    
    String zip = request.getParameter("zip");
    if(!zip.trim().isEmpty()) {
       try {
           validator.zipIsValid(zip, 5);
       } catch(InvalidInputException e) {
           customerMessage = e.getMessage();
       }
    }else {
        customerMessage = "Zip must not be epmty!";
    }

    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirm_password");
    
    if(!password.trim().isEmpty() && !confirmPassword.trim().isEmpty()) {
        if(password.equals(confirmPassword)) {
            PasswordValidator passvalidator = new PasswordValidator(password);
            try {
                passvalidator.passwordIsValid();
            } catch(InvalidInputException e) {
                customerMessage = e.getMessage();
            }
        } else {
            customerMessage = "Passwords do not match!";
        }
    } else {
        customerMessage = "Password and confirm must not be epmty!";
    }
    if(!customerMessage.isEmpty()) {
        request.setAttribute("customerMessage",customerMessage);
        %>
        <jsp:forward page="register.jsp"></jsp:forward>
        <%  
    } else {
        AddressInfo adInfo = new AddressInfo(country, city, address, zip);
        User customer = new Customer(username, fullname, email, password, adInfo, User.CUSTOMER_DEFAULT_IMAGE);
        System.out.println(customer.getUsername());
        customer.getDAO().register(customer);
        System.out.println(customerMessage);
        request.setAttribute("successRegisterMessage", "You have registered successfully. Please login to continue");
        %>
        <jsp:forward page="login.jsp"></jsp:forward>
        <%
    }

%>
