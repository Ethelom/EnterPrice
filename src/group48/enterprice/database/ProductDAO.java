package group48.enterprice.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

import group48.enterprice.model.AddressInfo;
import group48.enterprice.model.Product;
import group48.enterprice.model.Product.Category;
import group48.enterprice.model.Provision;
import group48.enterprice.model.Store;
import group48.enterprice.model.Supply;

public class ProductDAO {

    public Product findProduct(String productName) throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        Product product = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String sqlQuery = Query.FIND_PRODUCT;

        try {
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setString(1, productName);
            rs = stmt.executeQuery();

            if (! rs.next()) {
                return null;
            } else {
                product = createProductFromResultSet(rs);
                findProductSpecs(product, connection);

                stmt.close();
                rs.close();
                database.close();
                return product;
            }
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
    }

    public List<Product> findProducts(String key) throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        List<Product> products = new ArrayList<Product>();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String sqlQuery = "SELECT * FROM product WHERE product_name LIKE ?";

        try {
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setString(1, "%" + key + "%");
            rs = stmt.executeQuery();

            while (rs.next()) {
                Product product = createProductFromResultSet(rs);
                products.add(product);
                findProductSpecs(product, connection);
            }

            stmt.close();
            rs.close();
            database.close();
            return products;

        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
    }

    protected static Product createProductFromResultSet(ResultSet rs) throws SQLException {
        try {
            String productName = rs.getString(1);
            String productImage = rs.getString(2);
            String category = rs.getString(3).toUpperCase();
            String subCategory = rs.getString(4);
            String brand = rs.getString(5);
            String color = rs.getString(6);
            return new Product(productName, productImage, Category.valueOf(category), subCategory, brand, color);
        } catch (SQLException e) {
            throw new SQLException(e.getMessage());
        }
    }

    private static void findProductSpecs(Product product, Connection connection) throws Exception {
        PreparedStatement stmt2 = null;
        ResultSet rs2 = null;
        String sqlQuery2 = "SELECT * FROM " + product.getCategory().toString().toLowerCase() + " WHERE product_name = ?;";
        try {
            stmt2 = connection.prepareStatement(sqlQuery2);
            stmt2.setString(1, product.getProductName());
            rs2 = stmt2.executeQuery();
            ResultSetMetaData rsmd = rs2.getMetaData();
            int numberOfColumns = rsmd.getColumnCount();
            int colCounter = 2; //skipping the first column (product_name)

            if (rs2.next()) {
                while (colCounter <= numberOfColumns) {
                    String specNameDerivedFromDatabase = rsmd.getColumnName(colCounter);
                    String specName = Query.formatDatabaseString(specNameDerivedFromDatabase);
                    String value = rs2.getString(colCounter);
                    product.addToSpecs(specName, value);
                    colCounter++;
                }
            }

            rs2.close();
            stmt2.close();

        } catch(Exception e) {
            throw new Exception(e.getMessage());
        }

    }

    public static LinkedHashMap<String, Integer> getDistinctCategoriesAndOccurences(String searchKey) throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        LinkedHashMap<String, Integer> categoriesAndOccurences = new LinkedHashMap<String, Integer>();
        String sqlQuery = "SELECT category, COUNT(*) as counter "
            + "FROM product "
            + "WHERE product_name LIKE ? "
            + "GROUP BY category ORDER BY counter DESC;";

        try {
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setString(1, "%" + searchKey + "%");
            rs = stmt.executeQuery();
            while (rs.next()) {
                String category = rs.getString(1);
                int occurences = rs.getInt(2);
                categoriesAndOccurences.put(category, occurences);
            }

            rs.close();
            stmt.close();
            database.close();
            return categoriesAndOccurences;
        } catch (SQLException e) {
            throw new SQLException(e.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
            }
        }

    }


    public static LinkedHashMap<String, Integer> getDistinctSubcategoriesAndOccurences(String searchKey) throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        LinkedHashMap<String, Integer> subcategoriesAndOccurences = new LinkedHashMap<String, Integer>();
        String sqlQuery = "SELECT sub_category, COUNT(*) as counter "
            + "FROM product "
            + "WHERE product_name LIKE ? "
            + "GROUP BY sub_category ORDER BY counter DESC;";

        try {
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setString(1, "%" + searchKey + "%");
            rs = stmt.executeQuery();
            while (rs.next()) {
                String subcat = rs.getString(1);
                int occurences = rs.getInt(2);
                subcategoriesAndOccurences.put(subcat, occurences);
            }

            rs.close();
            stmt.close();
            database.close();
            return subcategoriesAndOccurences;
        } catch (SQLException e) {
            throw new SQLException(e.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
            }
        }

    }

    /* Nerd Solution
    public static List<Category> getDistinctCategories(List<Product> products) {
        return products.stream().map(Product::getCategory).distinct().collect(Collectors.toList());
    }

    public static HashMap<String, Integer> getDistinctSubCategoriesAndOccurences(List<Product> products) {
        HashMap<String, Integer> distinctSubCategoriesAndOccurencies = new HashMap<>();
        List<String> distinctSubCategories = products.stream().map(Product::getSubCategory).distinct().collect(Collectors.toList());
        for (String subCategory : distinctSubCategories) {
            int frequency = Collections.frequency(products.stream().map(Product::getSubCategory).collect(Collectors.toList()), subCategory);
            distinctSubCategoriesAndOccurencies.put(subCategory, frequency);
        }
        return distinctSubCategoriesAndOccurencies;
    }
     */

    public List<Supply> findStoresThatSellThisProduct(Product product) throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String sqlQuery = Query.FIND_ALL_STORES_THAT_SELL_A_PRODUCT;
        List<Supply> availabilities = new ArrayList<Supply>();

        try {
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setString(1, product.getProductName());
            rs = stmt.executeQuery();

            while (rs.next()) {
                String username = rs.getString(1);
                String ownerName = rs.getString(2);
                String email = rs.getString(3);

                AddressInfo adInfo = new AddressInfo(rs.getString(4), rs.getString(5),
                    rs.getString(6), rs.getString(7));

                String password = rs.getString(8);
                String image = rs.getString(9);
                String storeName = rs.getString(10);
                String accountNumber = rs.getString(11);
                String website = rs.getString(12);

                Store store = new Store(username, ownerName, storeName,
                    email, password, adInfo, image, website, accountNumber);

                Supply supply = new Supply(new Provision(product, store, rs.getDouble(14)), rs.getInt(13));
                availabilities.add(supply);
            }

            return availabilities;

        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
    }

    public List<Product> findProductsBySubcategory(String subcategory) throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Product> products = new ArrayList<Product>();
        Query query = new Query();
        String sqlQuery = query.getFindProductsBySubcategoryQuery();

        try {
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setString(1, subcategory);
            rs = stmt.executeQuery();
            while(rs.next()) {
                Product product = createProductFromResultSet(rs);
                products.add(product);
                findProductSpecs(product, connection);
            }

            return products;

        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
    }

    public List<Product> findAllProducts() throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        List<Product> products = new ArrayList<Product>();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String sqlQuery = "SELECT * FROM product";

        try {
            stmt = connection.prepareStatement(sqlQuery);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Product product = createProductFromResultSet(rs);
                products.add(product);
                findProductSpecs(product, connection);
            }

            stmt.close();
            rs.close();
            database.close();
            return products;

        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
    }
}
