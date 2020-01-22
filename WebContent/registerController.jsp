<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.database.UserDAO" %>
<%! 

public boolean passwordsMatch(String password, String confirmPassword) {
    return password.equals(confirmPassword);
}

public boolean usernameIsUnique(String username) throws Exception {
    return (!new UserDAO().checkIfUserExists(username));
}

%>