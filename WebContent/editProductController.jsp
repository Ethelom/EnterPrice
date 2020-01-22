<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.database.ProductDAO"%>
<%@ page import="group48.enterprice.database.SupplyDAO"%>
<%@ page import="group48.enterprice.model.Cart" %>
<%@ page import="group48.enterprice.model.Product" %>
<%@ page import="group48.enterprice.model.Provision" %>
<%@ page import="group48.enterprice.model.Store" %>
<%@ page import="group48.enterprice.model.Supply" %>
<%@ page import="group48.enterprice.utilities.Caster" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page errorPage="errorPage.jsp" %>
<%
Store store = null;
int quantity = 0;
double price = 0;
if(session.getAttribute("enterpriceUser") != null) {
    store = Caster.castObjectToTypeOfUser(session.getAttribute("enterpriceUser"), Store.class);
} else {
    request.setAttribute("message", "You are not authorised to access this source! Please log in to continue!");
    %><jsp:forward page="login.jsp"></jsp:forward><%
    
}
Supply supply = null;
if(session.getAttribute("editedSupply") != null) {
    supply = (Supply) session.getAttribute("editedSupply");
} else if (session.getAttribute("productToBeAdded") != null) {
        Product product = (Product) session.getAttribute("productToBeAdded");
        Provision provision = new Provision(product, store, price);
        supply = new Supply(provision, quantity);
} else {
    throw new Exception("If you play with fire, you get burnt!");
}
String priceStr = request.getParameter("productPrice");
String quantityStr = request.getParameter("productQuantity");
if (quantityStr != null) {
    if(!quantityStr.isEmpty()) {
            try {
                quantity = Integer.parseInt(quantityStr);                
            } catch(NumberFormatException e) {
                request.setAttribute("message", e.getMessage());
                %>
                <jsp:forward page="editProduct.jsp">
                    <jsp:param name="name" value="<%=supply.getProvision().getProduct().getProductName()%>"></jsp:param>
                </jsp:forward>
                <%
            }
            if(quantity >= 0) {
                supply.setStock(quantity);                
            }
    } else {
        request.setAttribute("message", "Quantity cannot be empty!");
        %>
        <jsp:forward page="editProduct.jsp">
            <jsp:param name="name" value="<%=supply.getProvision().getProduct().getProductName()%>"></jsp:param>
        </jsp:forward>
        <%
    }
}
if (priceStr != null) {
    if(!priceStr.isEmpty()) {
        if(priceStr.matches("[0-9.]*")) {
            try {
                price = Double.parseDouble(priceStr);                
            } catch(NumberFormatException e) {
                request.setAttribute("message", e.getMessage());
                %>
                <jsp:forward page="editProduct.jsp">
                    <jsp:param name="name" value="<%=supply.getProvision().getProduct().getProductName()%>"></jsp:param>
                </jsp:forward>
                <%
            }
            if(price >= 0) {
                supply.getProvision().setPrice(price);                
            }
        } else {
            request.setAttribute("message", "Price must be numberic and positive!");
            %>
            <jsp:forward page="editProduct.jsp">
                <jsp:param name="name" value="<%=supply.getProvision().getProduct().getProductName()%>"></jsp:param>
            </jsp:forward>
            <%
        }
    } else {
        request.setAttribute("message", "Price cannot be empty!");
        %>
        <jsp:forward page="editProduct.jsp">
            <jsp:param name="name" value="<%=supply.getProvision().getProduct().getProductName()%>"></jsp:param>
        </jsp:forward>
        <%
    }
}
if(request.getParameter("editProduct") != null) {
    new SupplyDAO().updateProductStoreInformation(supply);
} else if(request.getParameter("addProduct") != null) { 
    store.getProducts().add(supply);
    new SupplyDAO().addNewProduct(supply);
} else if (request.getParameter("setOutOfStockToggle") != null) {
    if (request.getParameter("setOutOfStockToggle").equals("true")) {
        supply.setStock(0);
        new SupplyDAO().updateProductStoreInformation(supply);       
    }
} else {
    throw new Exception("If you play with fire, you get burnt!");
}
%>
<jsp:forward page="homePageStore.jsp"/>