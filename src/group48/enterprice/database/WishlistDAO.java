package group48.enterprice.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import group48.enterprice.model.Customer;
import group48.enterprice.model.Product;
import group48.enterprice.model.Product.Category;

public class WishlistDAO {

    public void updateWishlist(Customer customer, String productName) throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String sqlQuery = new Query().getFindProductInWishlistQuery();

        try {
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setString(1, customer.getUsername());
            stmt.setString(2, productName);
            rs = stmt.executeQuery();

            PreparedStatement stmt2 = null;
            String sqlQuery2 = null;
            if(rs.next()) {
                sqlQuery2 = new Query().getRemoveFromWishlistQuery();
            } else {
                sqlQuery2 = new Query().getAddToWishlistQuery();
            }
            stmt2 = connection.prepareStatement(sqlQuery2);
            stmt2.setString(1, customer.getUsername());
            stmt2.setString(2, productName);
            stmt2.executeUpdate();

            stmt2.close();
            rs.close();
            stmt.close();
            database.close();
        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if(connection != null) {
                connection.close();
            }
        }
    }

    public ArrayList<Product> loadWishlist(Customer customer) throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        ArrayList<Product> wishlist = new ArrayList<Product>();
        String sqlQuery = new Query().getFindWishlistQuery();

        try {
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setString(1, customer.getUsername());
            rs = stmt.executeQuery();

            while(rs.next()) {
                String productName = rs.getString(1);
                String productImage = rs.getString(2);
                String category = rs.getString(3).toUpperCase();
                String subcategory = rs.getString(4);
                String brand = rs.getString(5);
                String color = rs.getString(6);
                Product product =
                    new Product(productName, productImage, Category.valueOf(category), subcategory, brand, color);
                wishlist.add(product);

            }
            rs.close();
            stmt.close();
            database.close();
            return wishlist;
        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if(connection != null) {
                connection.close();
            }
        }
    }
}
