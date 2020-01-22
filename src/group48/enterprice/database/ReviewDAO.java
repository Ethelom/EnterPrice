package group48.enterprice.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import group48.enterprice.model.Product;
import group48.enterprice.model.ProductReview;

public class ReviewDAO {

    public void submitProductReview(ProductReview review) throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        Query query = new Query();
        String sqlQuery = query.getSubmitReviewQuery();

        try {
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setInt(1, review.getRating());
            stmt.setString(2, review.getReviewBody());
            stmt.setString(3, review.getCustomer().getUsername());
            stmt.setString(4, review.getProduct().getProductName());
            stmt.executeUpdate();

            stmt.close();
            database.close();

        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
    }

    public List<ProductReview> findProductReviews(Product product) throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<ProductReview> reviews = new ArrayList<ProductReview>();
        Query query = new Query();
        String sqlQuery = query.getProductReviewsQuery();

        try {
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setString(1, product.getProductName());
            rs = stmt.executeQuery();

            while (rs.next()) {
                String timestamp = String.valueOf(rs.getTimestamp("review_date"));
                timestamp = timestamp.substring(0, timestamp.indexOf(" ")).replace("-", "/");
                ProductReview review = new ProductReview(rs.getString(3), product, rs.getInt(1), rs.getString(2), timestamp);
                reviews.add(review);
            }

            rs.close();
            stmt.close();
            database.close();
            return reviews;

        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
            }
        }

    }

    public void deleteReview(String username, String productName) throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        Query query = new Query();
        String sqlQuery = query.getDeleteReviewQuery();
        try {
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setString(1, username);
            stmt.setString(2, productName);
            stmt.executeUpdate();

            stmt.close();
            database.close();

        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
    }

}
