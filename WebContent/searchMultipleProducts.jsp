<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="group48.enterprice.database.ProductDAO" %>
<%@ page import="group48.enterprice.model.ProductKeeper" %>
<%@ page import="group48.enterprice.model.Filter" %>
<%@ page import="group48.enterprice.model.Product" %>
<%@ page import="group48.enterprice.model.Store" %>
<%@ page import="group48.enterprice.model.User" %>
<%@ page import="group48.enterprice.utilities.Utility" %>
<%@ page import="group48.enterprice.exceptions.IntruderException" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.Random" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page errorPage="errorPage.jsp" %>
<!DOCTYPE HTML>
<html lang="en">
<%
if(session.getAttribute("enterpriceUser") != null) {
    if(session.getAttribute("enterpriceUser") instanceof Store) {
        throw new IntruderException();
    }
}
List<Product> allSubcategoryProducts = null;
List<Product> products = null;
String title = null;
String requestedSubcategory = null;
ArrayList<String> potentialFilters = null;
String[] checkedFilters = null;
if(request.getParameter("resetFilters") != null) {
    String answer = request.getParameter("resetFilters");
    if(answer.equals("yes")) {
        session.removeAttribute("checkedFilters");
    } else {
        throw new Exception("There has been an unexpected violation!");
    }
}
if(request.getParameter("cameFrom") != null) {
    String cameFrom = request.getParameter("cameFrom");
    if(cameFrom.equals("home")) {
        session.removeAttribute("savedProducts");
    }
}
if(request.getParameter("subcategory") != null) {    
    requestedSubcategory = request.getParameter("subcategory");
    if(Product.subcategoryIsValid(requestedSubcategory)) {
        allSubcategoryProducts = new ProductDAO().findProductsBySubcategory(requestedSubcategory);
        session.setAttribute("allSubcategoryProducts", new ProductKeeper(allSubcategoryProducts));
        products = new Utility().cloneList(allSubcategoryProducts);
        if (request.getParameter("search") != null) {
            title = request.getParameter("search");
        } else {
            title = requestedSubcategory;
        }
        if(request.getSession().getAttribute("savedProducts") != null) {
            ProductKeeper pk = (ProductKeeper)request.getSession().getAttribute("savedProducts");
            if(pk.getSavedProducts().size() > 0) {
                if(request.getParameter("cameFrom") != null) {
                    String cameFrom = request.getParameter("cameFrom");
                    if(cameFrom.equals("search")) {
                        products = pk.getRequestedSubcategoryProducts(requestedSubcategory);
                    } else {
                        throw new Exception("There has been an unexpected violation!");
                    }
                } else {
                    products = pk.getSavedProducts();
                }
                
            }
        }
        if(session.getAttribute("checkedFilters") != null) {
            checkedFilters = (String[]) session.getAttribute("checkedFilters");
        }


        //all products have the same specs (considering that they belong to the same subcategory)
        Product p = products.get(0);
        potentialFilters = new ArrayList<String>(p.getSpecs().keySet());
    } else {
        throw new Exception("The subcategory you searched for does not exist");
    }
} else {
    throw new Exception("Unspecified subcategory of products!");
}
%>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="author" content="Theodosis Tsaklanos - 8170136">
    <title>Search Results - <%=title %></title>
    <link rel="icon" href="icons/logo-lg.png" type="image/x-icon">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/css/all.css">
    <link rel="stylesheet" href="css/navbar-theme.css">
    <link rel="stylesheet" href="css/core-theme.css">
    <link rel="stylesheet" href="css/table-theme.css">
    <link rel="stylesheet" href="css/checkbox-theme.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <script src="js/MiniFunctions.js"></script>
</head>

<body>
    <style>
        #filters.in,
        #filters.collapsing {
            display: block !important;
        }

        @media screen and (min-width:768px) {
            #filters {
                display: block !important;
                visibility: visible !important;
            }
        }

    </style>
<%    

%>


<%if(session.getAttribute("enterpriceUser") != null) {
    User user = (User)session.getAttribute("enterpriceUser");
    %>
    <jsp:include page="navbarCustomer.jsp" />
    <%    
} else {
    %>
    <jsp:include page="defaultNavbar.jsp" />
    <%
}
%>


    <div class="container-fluid" id="container">
        <div class="col-xs-12 col-sm-4 col-md-3 col-lg-2" style="margin-bottom: 25px">

            <div class="text-center">
                <h2>Filters</h2>
            </div>
            <button class="btn btn-round enterprice-blue visible-xs" data-toggle="collapse" data-target="#filters">
                <i class="fas fa-sliders-h fa-2x"></i></button>

<form method="post" action="filterController.jsp?subcategory=<%=requestedSubcategory %>">
            <div id="filters" class="hidden-xs">
               <%   
               LinkedHashMap<String, ArrayList<String>> filterBox = 
                    new LinkedHashMap<String, ArrayList<String>>();
               
               int filterCounter = 0;
               for (String filterKey : potentialFilters) {                   
                   ArrayList<String> uniqueValues = new ArrayList<String>();
                   
                    for (Product product : allSubcategoryProducts) {
                        String candidateValue = product.getSpecs().get(filterKey);
                        if(candidateValue != null & !uniqueValues.contains(candidateValue)) {
                            uniqueValues.add(candidateValue);
                        }     
                    }
                    /*
                    
                    The methods used below are written at the end of the page
                    
                    
                    if(!uniqueValues.isEmpty()) {
                        if(checkIfListRepresentsNumbers(uniqueValues)) {
                            uniqueValues = sortStringListOfIntegers(uniqueValues);
                        }                        
                    }
                    if(filterKey.equals("Size")) {
                        if(requestedSubcategory.equals("Shirt") 
                                || requestedSubcategory.equals("Suit") 
                                || requestedSubcategory.equals("Dress")) {
                            
                            uniqueValues = sortSize(uniqueValues);                            
                        }
                    }
                    
                    if(!uniqueValues.isEmpty()) {
                        if(checkIfListContainsSortableUnit(uniqueValues) && 
                            !filterKey.equals("Dimensions") &&
                            !filterKey.equals("Screen resolution")) {
                            uniqueValues = sortNumericUnit(uniqueValues);
                        }
                    }
                    */
                    filterBox.put(filterKey, uniqueValues);
                    %>
                    <%
                    if(filterBox.get(filterKey).size() > 0) { %>
                        <div class="list-group" style="margin: 6px 0;">
                            <div>
                                <button class="btn" type="button" data-toggle="collapse" data-target="#collapseExample<%=filterCounter %>" aria-expanded="false" aria-controls="collapseExample<%=filterCounter %>" 
                                    style="margin-bottom:10px; box-shadow: none">
                                    <i class="fa fa-plus" style="color:#315b96"></i>
                                </button>
                                <h4 style="display:inline-block"><%=filterKey %></h4>
                            </div>
                            <div class="collapse" id="collapseExample<%=filterCounter %>" style="max-height: 223px; overflow-y: auto; overflow-x: hidden;">    
                                <%
                                for(String value : filterBox.get(filterKey)) { %>
                                    <div class="list-group-item checkbox">
                                        <%
                                        String checkedToggle = ""; //default state: unchecked
                                        if(checkedFilters != null) {
                                            for(String checkedFilter : checkedFilters) {
                                                Filter decodedFilter = new Utility().decodeFilterFromString(checkedFilter);
                                                if(decodedFilter.getKey().equals(filterKey)) {
                                                    if(decodedFilter.getValue().equals(value)) {
                                                        checkedToggle = "checked";                                                    
                                                    }
                                                }
                                            }                                            
                                        }
                                        %>
                                        <label><input type="checkbox" name="cb" class="common_selector" value='<%=filterKey + "-" + value %>' <%=checkedToggle %>> <%=value %></label>
                                    </div>
                                <%
                                }
                                %>
                            </div>
                        </div>
                    <%
                    }
                    %>
                <%
                    filterCounter++;
                }
                %>
                <div class="form-group" style="margin-top: 15px">
                    <button name="clearFilters" class="col-xs-5 btn btn-danger btn-round" onclick="clearAllFilters('cb')">Clear</button>
                    <button name="applyFilters" class="col-xs-offset-1 col-xs-5 btn enterprice-blue btn-round">Apply</button>
                </div>
            </div>
</form>
        </div>
        
        
        <div class="col-xs-12 col-sm-8 col-md-8 col-md-offset-1 col-lg-9" style="margin-top: 60px;">    
            <%
            //fix
            ArrayList<String> thumbnailSpecs = new ArrayList<String>();
            int counter = 1;
            do {
                String key = potentialFilters.get(new Random().nextInt(potentialFilters.size()-1) + 1);
                if(!thumbnailSpecs.contains(key)) {
                    thumbnailSpecs.add(key);
                    counter++;
                }
            } while(counter <= 2);
            for(Product product : products) { %>
                <div class="col-xs-12 col-md-6 col-lg-4">
                        <div class="thumbnail">
                            <div class="caption text-center">
                                <div class="position-relative">
                                    <img src="<%=product.getProductImage() %>" class="img-size-sm" />
                                </div>
                                <h4 id="thumbnail-label"><a href="viewProduct.jsp?productName=<%=product.getProductName().replace(" ", "-") %>"><%=product.getProductName() %></a></h4>
                                <p><i class="glyphicon glyphicon-list light-red lighter bigger-120"></i> <%=product.getCategory() %></p>
                            </div>
                            <div class="thumbnail-description">
                                <ul class="list-group">
                                    <%
                                    for(String thumbnailSpec : thumbnailSpecs) {
                                        if(product.getSpecs().get(thumbnailSpec) != null) {
                                            %>
                                            <li class="list-group-item text-center">
                                                <label><%=thumbnailSpec %>:</label>
                                                <%=product.getSpecs().get(thumbnailSpec) %>
                                            </li>
                                        <%
                                        }
                                    }
                                    %>
                                </ul>
                            </div>
                        </div>  
                    </div> 
            <%
            }
            %>
        </div>
    </div>
    <jsp:include page="footer.jsp"></jsp:include>
</body>

<%!
/*

These methods do no

private boolean checkIfListRepresentsNumbers(ArrayList<String> list) {
    boolean nonNumericFound = false;
    for(String item : list) {
        if(!StringUtils.isNumeric(item)) {
            nonNumericFound = true;
            break;
        }
    }
    return !nonNumericFound;
}

private ArrayList<String> sortStringListOfIntegers(ArrayList<String> list) {
    Collections.sort(list, new Comparator<String>() {
        @Override
        public int compare(String number1, String number2) {
            return Integer.valueOf(number1).compareTo(Integer.valueOf(number2));
        }
    });
    return list;
}

private ArrayList<String> sortSize(ArrayList<String> list) {
    List<String> ascendingOrderOfSize = 
        Arrays.asList("S", "M", "L", "XL", "2XL");
    Comparator<String> sizeOrder = Comparator.comparingInt(ascendingOrderOfSize::indexOf);
    list.sort(sizeOrder);
    return list;
}

private boolean checkIfListContainsSortableUnit(ArrayList<String> list) {
    boolean nonSortableFound = false;
    for(String item : list) {
        if(!item.matches(".*\\d.*")) {
            nonSortableFound = true;
            break;
        }
    }
    return !nonSortableFound;
}

private ArrayList<String> sortNumericUnit(ArrayList<String> list) {
    Collections.sort(list, new Comparator<String>() {
        @Override
        public int compare(String o1, String o2) {
            return extractInt(o1) - extractInt(o2);
        }

        int extractInt(String s) {
            String num = s.replaceAll("\\D", "");
            return num.isEmpty() ? 0 : Integer.parseInt(num);
        }
    });
    return list;
}
*/
%>
</html>
