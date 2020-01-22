<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.database.UserDAO" %>
<%@ page import="group48.enterprice.model.AddressInfo" %>
<%@ page import="group48.enterprice.model.Store" %>
<%@ page import="group48.enterprice.model.User" %>
<%@ page import="group48.enterprice.utilities.Validator" %>
<%@ page import="group48.enterprice.utilities.PasswordValidator" %>
<%@ page import="group48.enterprice.utilities.UserDataValidator" %>
<%@ page import="org.eclipse.jdt.core.compiler.InvalidInputException" %>

<%@include file = "registerController.jsp" %>

<%
    request.setCharacterEncoding("utf-8");
    
    String storeMessage = "";
    
    UserDataValidator validator = new UserDataValidator();
    
    String username = request.getParameter("username");
    try {
        if(usernameIsUnique(username)) {
            if(username.trim().isEmpty()) {
                storeMessage = "Username must not be epmty!";          
            }
        }else {
            storeMessage ="Username is already taken!"; 
        }
    }catch (Exception e) {
        storeMessage = e.getMessage();
    }

    String ownerName = request.getParameter("owner_name");
    if(!ownerName.trim().isEmpty()) {
        try {
            validator.fullnameIsValid(ownerName);
        } catch(InvalidInputException e) {
            storeMessage = e.getMessage();
        }
    } else {
        storeMessage ="Owner name must not be epmty!";          
    }
    
    String email = request.getParameter("email");
    if(!email.trim().isEmpty()) {
        try {
          validator.emailIsValid(email, 45);
          
        } catch(InvalidInputException e) {
            storeMessage = e.getMessage();
        }
    }else {
        storeMessage = "Email must not be epmty!";
    }
    
    String country = request.getParameter("country");
    if(!country.trim().isEmpty()) {
        try {
            validator.countryIsValid(country);
        } catch(InvalidInputException e) {
            storeMessage = e.getMessage();
        }
    } else {
        storeMessage = "Country must not be epmty!";
    }
    
    String city = request.getParameter("city");
    if(!city.trim().isEmpty()) {
        try {
            validator.cityIsValid(city);
        } catch(InvalidInputException e) {
            storeMessage = e.getMessage();
        }
    } else {
        storeMessage = "City must not be epmty!";
    }
    
    String address = request.getParameter("address");
    if(!address.trim().isEmpty()) {
       try { 
           validator.addressIsValid(address, 100);
       } catch(InvalidInputException e) {
           storeMessage =e.getMessage();
       }
    } else {
        storeMessage = "Address must not be epmty!";
    }
    
    String zip = request.getParameter("zip");
    if(!zip.trim().isEmpty()) {
       try {
           validator.zipIsValid(zip, 5);
       } catch(InvalidInputException e) {
           storeMessage = e.getMessage();
       }
    }else {
        storeMessage = "Zip must not be epmty!";
    }
    
    String websiteURL = request.getParameter("website");
    if(!websiteURL.trim().isEmpty()) {
        try {
            validator.websiteIsValid(websiteURL, 100);
        } catch(Exception e) {
            request.setAttribute("storeMessage", e.getMessage());
        }
    } else {
        storeMessage = "Website must not be epmty!";
    }

    String bankAccountNumber = request.getParameter("bank_account_number");
    if(!bankAccountNumber.trim().isEmpty()) {
        try {
            validator.ibanIsValid(bankAccountNumber);
        } catch (InvalidInputException e) {
            request.setAttribute("editProfileMessage", e.getMessage());
        }
    } else {
        storeMessage = "Bank account number must not be epmty!";
    }
    
    String storeName = request.getParameter("store_name");
    if(!storeName.trim().isEmpty()) {
        if(!validator.lengthIsValid(storeName, 1, 40)) {
            request.setAttribute("editProfileMessage", "Please insert a valid store name (max. 40 characters)");
        } 
    } else {
        storeMessage = "Store name must not be epmty!!";
    }
     
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirm_password");
    
    if(!password.trim().isEmpty() && !confirmPassword.trim().isEmpty()) {
        if(password.equals(confirmPassword)) {
            PasswordValidator passvalidator = new PasswordValidator(password);
            try {
                passvalidator.passwordIsValid();
            } catch(InvalidInputException e) {
                storeMessage = e.getMessage();
            }
        } else {
            storeMessage = "Passwords do not match!";
        }
    } else {
        storeMessage = "Password and confirm must not be epmty!";
    }
    
    if(!storeMessage.isEmpty()) {
        request.setAttribute("storeMessage",storeMessage);
        %>
        <jsp:forward page="register.jsp"></jsp:forward>
        <%  
    } else {
        AddressInfo adInfo = new AddressInfo(country, city, address, zip);
        User store = new Store(username, ownerName, storeName, email, password, adInfo, User.STORE_DEFAULT_IMAGE, websiteURL, bankAccountNumber);
        store.getDAO().register(store);
        request.setAttribute("successRegisterMessage", "You have registered successfully. Please login to continue");
        %>
        <jsp:forward page="login.jsp"></jsp:forward>
        <%
    }
%>