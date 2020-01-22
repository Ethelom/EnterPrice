<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.model.Store" %>
<%@ page import="group48.enterprice.model.User" %>
<%@ page import="group48.enterprice.database.UserDAO" %>
<%@ page import="group48.enterprice.utilities.Validator" %>
<%@ page import="group48.enterprice.utilities.UserDataValidator" %>
<%@ page import="java.util.regex.Matcher" import="java.util.regex.Pattern" import="java.util.Locale"%>
<%@ page import="org.eclipse.jdt.core.compiler.InvalidInputException" %>
<%@ page errorPage="errorPage.jsp" %>
<%
request.setCharacterEncoding("utf-8");
User user = null;
if(session.getAttribute("enterpriceUser") != null) {

	user = (User)session.getAttribute("enterpriceUser");		

} else {
	
	request.setAttribute("message", "You are not authorized to access this resource. Please login.");
	
    %>
    
    <jsp:forward page="login.jsp" />
    
    <%
    
}
if(request.getParameter("updateAccountButton") != null) {

    UserDataValidator validator = new UserDataValidator();

    String username = request.getParameter("username");
    if(!username.trim().isEmpty()) {
        request.setAttribute("editProfileMessage", "We attended all of your lectures!");
    }

    String fullname = request.getParameter("fullname");
    if(!fullname.trim().isEmpty()) {
        try {
            if(validator.fullnameIsValid(fullname)) {
                user.setFullname(fullname);
            }
        } catch(InvalidInputException e) {
            request.setAttribute("editProfileMessage", e.getMessage()); 
        }
    }
    

    String email = request.getParameter("email");
    if(!email.trim().isEmpty()) {
        try {
            if(validator.emailIsValid(email, 45)) {
                user.setEmail(email);
            }
        } catch(InvalidInputException e) {
            request.setAttribute("editProfileMessage", e.getMessage());
        }
    }

    String country = request.getParameter("country");
    if(!country.trim().isEmpty()) {
        try {
            if(validator.countryIsValid(country)) {
                user.getAdInfo().setCountry(country);
            }
        } catch(InvalidInputException e) {
            request.setAttribute("editProfileMessage", e.getMessage());
        }
    }

    String city = request.getParameter("city");
    if(!city.trim().isEmpty()) {
        try {
            if(validator.cityIsValid(city)) {
                user.getAdInfo().setCity(city);
            }
        } catch(InvalidInputException e) {
            request.setAttribute("editProfileMessage", e.getMessage());
        }
    }

    String address = request.getParameter("address");
    if(!address.trim().isEmpty()) {
       try { 
           if(validator.addressIsValid(address, 100)) {
               user.getAdInfo().setAddress(address);
           }
       } catch(InvalidInputException e) {
           request.setAttribute("editProfileMessage", e.getMessage());
       }
    }

    String zip = request.getParameter("zip");
    if(!zip.trim().isEmpty()) {
       try {
           if(validator.zipIsValid(zip, 5)) {
               user.getAdInfo().setZip(zip);
           }   
       } catch(InvalidInputException e) {
           request.setAttribute("editProfileMessage", e.getMessage());
       }
    }
    
    if(user instanceof Store) {
        Store store = (Store) user;
        
        String website = null;
        if(request.getParameter("website") != null) {
            website = request.getParameter("website");
            if(!website.trim().isEmpty()) {
                try {
                    if(validator.websiteIsValid(website, 100)) {
                        store.setWebsite(website);
                    }
                } catch(Exception e) {
                    request.setAttribute("editProfileMessage", e.getMessage());
                }
            }
        }
        
        if(request.getAttribute("bankNumber") != null) {
            String iban = request.getParameter("bankNumber");
            if(!iban.trim().isEmpty()) {
                try {
                    if(validator.ibanIsValid(iban)) {
                        store.setAccountNumber(iban);
                    }
                } catch (InvalidInputException e) {
                    request.setAttribute("editProfileMessage", e.getMessage());
                }
            }
        }
        
        if(request.getParameter("storeName") != null) {
            String storeName = request.getParameter("storeName");
            if(!storeName.trim().isEmpty()) {
                if(validator.lengthIsValid(storeName, 1, 40)) {
                    store.setStoreName(storeName);
                } else {
                    request.setAttribute("editProfileMessage", "Please insert a valid store name (max. 40 characters)");
                }
            }      
        }        
    }
    
    UserDAO udao = user.getDAO();
    udao.update(user);
%>
    <jsp:forward page="editProfile.jsp" />

<%
} else if (request.getParameter("keep-profile-picture-src") != null) {
    String src = request.getParameter("keep-profile-picture-src");
    if (src != null && !src.isEmpty()) {
        user.setImage(src);
        new UserDAO().updateProfilePicture(user.getUsername(), src);
    %>
        <jsp:forward page="editProfile.jsp"></jsp:forward>
    <%    
    }
} else {
    throw new Exception("If you play with fire, you get burnt!");
}
%>
