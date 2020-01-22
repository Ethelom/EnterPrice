package group48.enterprice.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import group48.enterprice.model.Product;
import group48.enterprice.model.Provision;
import group48.enterprice.model.Store;
import group48.enterprice.model.Supply;

public class SupplyDAO {

    public void addNewProduct(Supply sp) throws Exception {
        Database database = new Database();
        PreparedStatement stmt2 = null;
        Connection connection = database.getConnection();
        String sqlQuery2 = new Query().ADD_PRODUCT_STORE;
        try {
            stmt2 = connection.prepareStatement(sqlQuery2);
            stmt2.setString(1, sp.getProvision().getProduct().getProductName());
            stmt2.setString(2, sp.getProvision().getStore().getUsername());
            stmt2.setInt(3, sp.getStock());
            stmt2.setDouble(4, sp.getProvision().getPrice());
            stmt2.executeUpdate();
            stmt2.close();
        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if(connection != null) {
                connection.close();
            }
        }

    }

    public void updateProductStoreInformation(Supply sp) throws Exception {
        Database database = new Database();
        PreparedStatement stmt2 = null;
        Connection connection = database.getConnection();
        String sqlQuery2 = Query.UPDATE_PRODUCT_STORE;
        try {
            stmt2 = connection.prepareStatement(sqlQuery2);
            stmt2.setInt(1, sp.getStock());
            stmt2.setDouble(2, sp.getProvision().getPrice());
            stmt2.setString(3, sp.getProvision().getProduct().getProductName());
            stmt2.setString(4, sp.getProvision().getStore().getUsername());
            stmt2.executeUpdate();
            stmt2.close();
        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if(connection != null) {
                connection.close();
            }
        }

    }

    public Supply findProductStoreInfo(Store store, Product product) throws Exception {
        Database database = new Database();
        PreparedStatement stmt2 = null;
        ResultSet rs2 = null;
        Supply sp = null;
        Connection connection = database.getConnection();
        String sqlQuery2 = Query.FIND_PRODUCT_STORE_INFO;
        try {
            stmt2 = connection.prepareStatement(sqlQuery2);
            stmt2.setString(1, store.getUsername());
            stmt2.setString(2, product.getProductName());
            rs2 = stmt2.executeQuery();
            if (!rs2.next()) {
                sp = null;
            } else {
                double price = rs2.getDouble("price");
                int quantity = rs2.getInt("stock");
                sp = new Supply(new Provision(product, store, price), quantity);
            }
            rs2.close();
            stmt2.close();
            return sp;
        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if(connection != null) {
                connection.close();
            }
        }

    }

}