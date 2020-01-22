package group48.enterprice.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.LinkedHashMap;

import group48.enterprice.model.Customer;
import group48.enterprice.model.User;

public class CustomerDAO extends UserDAO {

    private Customer customer;

    public CustomerDAO(Customer customer) {
        super();
        this.customer = customer;
    }

    @Override
    public void update(User user) throws Exception {
        super.update(user);
    }

    @Override
    public LinkedHashMap<String, Integer> getUserStatistics() throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        LinkedHashMap<String, Integer> statistics = new LinkedHashMap<String, Integer>();
        ArrayList<String> queriesToBeExecuted = new ArrayList<String>();
        String ordersQuery = "SELECT count(*) as Orders FROM purchase WHERE cust_username = ?;";
        String reviewsQuery = "SELECT count(*) as Reviews FROM product_review WHERE cust_username = ?;";
        queriesToBeExecuted.add(ordersQuery);
        queriesToBeExecuted.add(reviewsQuery);

        try {
            for(String query : queriesToBeExecuted) {
                stmt = connection.prepareStatement(query);
                stmt.setString(1, customer.getUsername());
                rs = stmt.executeQuery();
                ResultSetMetaData metadata = rs.getMetaData();
                if (rs.next()) {
                    statistics.put(metadata.getColumnName(1), rs.getInt(1));
                }
            }

            rs.close();
            stmt.close();
            database.close();
            return statistics;
        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if(connection != null) {
                connection.close();
            }
        }
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

}
