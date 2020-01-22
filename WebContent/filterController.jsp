<!--
  - Author(s): Theodosis Tsaklanos - 8170136
  -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.database.ProductDAO" %>
<%@ page import="group48.enterprice.model.Product" %>
<%@ page import="group48.enterprice.model.Filter" %>
<%@ page import="group48.enterprice.model.ProductKeeper" %>
<%@ page import="group48.enterprice.model.Customer" %>
<%@ page import="group48.enterprice.utilities.Utility" %>
<%@ page import="group48.enterprice.utilities.Caster" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page errorPage="errorPage.jsp" %>
<%
if(session.getAttribute("enterpriceUser") != null) {
    Customer customer = 
        Caster.castObjectToTypeOfUser(session.getAttribute("enterpriceUser"), Customer.class);
}
String subcategory = null;
List<Product> returnedProducts = new ArrayList<Product>();
if (request.getParameter("subcategory") != null) {
    subcategory = request.getParameter("subcategory");
    if(!Product.subcategoryIsValid(subcategory)) {
        throw new Exception("Unspecified subcategory of products!");
    }
    List<Product> superset = new ArrayList<Product>();
    if(session.getAttribute("allSubcategoryProducts") != null) {
        superset = ((ProductKeeper)session.getAttribute("allSubcategoryProducts")).getSavedProducts();
    } else {
        superset = new ProductDAO().findProductsBySubcategory(subcategory);        
    }
    if(request.getParameter("applyFilters") != null) {
        String[] checkedBoxes = request.getParameterValues("cb");
        session.setAttribute("checkedFilters", checkedBoxes);
        
        ArrayList<Filter> filters = new ArrayList<Filter>();
        if(checkedBoxes != null) {
            if(checkedBoxes.length > 0) {
                for(String filter : checkedBoxes) {
                    String[] filterParts = filter.split("-");
                    String filterKey = filterParts[0];
                    String filterValue = filterParts[1];
                    filters.add(new Filter(filterKey, filterValue));
                }
                
                List<Product> subset = new Utility().cloneList(superset);
                Queue<Filter> queue = new LinkedList<Filter>();
                
                for(int i = 0; i < filters.size(); i++) {   
                    
                    queue.add(filters.get(i));
                    
                    if(i < filters.size() - 1) {
                        if(filters.get(i).getKey().equals(filters.get(i+1).getKey())) {
                            continue;
                        }
                    }
                    
                    if(queue.size() > 0) {
                        List<List<Product>> unionSubset = new ArrayList<List<Product>>();
                        int queueSize = queue.size();
                        for(int k = 0; k < queueSize; k++) {
                            Filter filter = queue.remove();//get the first element
                            List<Product> filteredList = filter.applyFilter(subset);
                            unionSubset.add(filteredList);
                        }
                        subset = getUniqueOccurencesList(unionSubset);
                    }
                }
                returnedProducts = subset;
                
            } else {
                returnedProducts = superset;
            }
        }
    } else {
        //either clearing the filters or searching for a valid subcategory will show
        //all the products of this subcategory
        returnedProducts = superset;
        session.setAttribute("checkedFilters", null);
    }
    ProductKeeper productKeeper = new ProductKeeper(returnedProducts);
    session.setAttribute("savedProducts", productKeeper);
    %><jsp:forward page="searchMultipleProducts.jsp?subcategory=<%=subcategory %>"></jsp:forward>
    <%
} else {
    throw new Exception("Unspecified subcategory of products!");
}
%>

<%!
private List<Product> getUniqueOccurencesList(List<List<Product>> listOfLists) {
    List<Product> uniqueOccurences = new ArrayList<Product>();
    for(List<Product> productSubset : listOfLists) {
        uniqueOccurences.addAll(productSubset);
    }
    return uniqueOccurences;
}
%>