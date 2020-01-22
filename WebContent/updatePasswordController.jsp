<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.model.User" %>
<%@ page import="group48.enterprice.database.UserDAO" %>
<%@ page import="group48.enterprice.utilities.PasswordValidator" %>
<%@ page import="org.eclipse.jdt.core.compiler.InvalidInputException" %>
<!DOCTYPE html>
<meta charset="UTF-8">
<%
User user = (User) session.getAttribute("enterpriceUser");
String password = request.getParameter("password");
String confirmPassword = request.getParameter("confirm_password");

if(!password.trim().isEmpty() && !confirmPassword.trim().isEmpty()) {
    if(password.equals(confirmPassword)) {
        PasswordValidator validator = new PasswordValidator(password);
        try {
            if(validator.passwordIsValid()) {
                user.setPassword(password);
                UserDAO udao = user.getDAO();
                udao.update(user);
            }
        } catch(InvalidInputException e) {
            request.setAttribute("wrongPasswordMessage", e.getMessage());
        }
    } else {
        request.setAttribute("wrongPasswordMessage", "Passwords do not match!");
    }
}
%>
<jsp:forward page="editProfile.jsp"></jsp:forward>