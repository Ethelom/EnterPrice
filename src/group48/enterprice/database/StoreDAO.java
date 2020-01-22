package group48.enterprice.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

import group48.enterprice.model.Product;
import group48.enterprice.model.Provision;
import group48.enterprice.model.Store;
import group48.enterprice.model.Supply;
import group48.enterprice.model.User;

public class StoreDAO extends UserDAO {

    private Store store;

    public StoreDAO(Store store) {
        super();
        this.store = store;
    }

    @Override
    public void update(User user) throws Exception {
        super.update(user);
        Database database = new Database();
        Connection con = database.getConnection();
        PreparedStatement stmt = null;
        String sqlQuery = new Query().UPDATE_STORE_QUERY;
        try {
            stmt = con.prepareStatement(sqlQuery);
            stmt.setString(1, store.getWebsite());
            stmt.setString(2, store.getStoreName());
            stmt.setString(3, store.getAccountNumber());
            stmt.setString(4, user.getUsername());
            stmt.executeUpdate();
            stmt.close();
            database.close();
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if(con != null) {
                con.close();
            }
        }
    }

    @Override
    public LinkedHashMap<String, Integer> getUserStatistics() throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        LinkedHashMap<String, Integer> statistics = new LinkedHashMap<String, Integer>();
        ArrayList<String> queriesToBeExecuted = new ArrayList<String>();
        String ordersQuery = "SELECT count(*) as Orders FROM purchase WHERE b_username = ?;";
        String productsQuery = "SELECT count(*) as Products FROM product_store WHERE b_username=?";
        queriesToBeExecuted.add(ordersQuery);
        queriesToBeExecuted.add(productsQuery);

        try {
            for(String query : queriesToBeExecuted) {
                stmt = connection.prepareStatement(query);
                stmt.setString(1, store.getUsername());
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

    public List<Supply> findProductsThatStoreSells() throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String sqlQuery = Query.FIND_ALL_PRODUCTS_THAT_A_STORE_SELLS;
        List<Supply> availabilities = new ArrayList<Supply>();

        try {
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setString(1, store.getUsername());
            rs = stmt.executeQuery();

            while (rs.next()) {
                Product product = ProductDAO.createProductFromResultSet(rs);
                Supply supply = new Supply(new Provision(product, store, rs.getDouble("price")), rs.getInt("stock"));
                availabilities.add(supply);
            }
            rs.close();
            stmt.close();
            database.close();
            return availabilities;

        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
                database.close();
            }
        }
    }

    public void deleteProductFromStore(String productName) throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        String sqlQuery = "DELETE FROM product_store WHERE product_name= ? and b_username=?;";

        try {
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setString(1, productName);
            stmt.setString(2, store.getUsername());
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

    public Store getStore() {
        return store;
    }

    public void setStore(Store store) {
        this.store = store;
    }

}
