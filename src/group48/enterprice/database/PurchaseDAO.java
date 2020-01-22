package group48.enterprice.database;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import group48.enterprice.model.AddressInfo;
import group48.enterprice.model.Customer;
import group48.enterprice.model.LineItem;
import group48.enterprice.model.Product;
import group48.enterprice.model.Product.Category;
import group48.enterprice.model.Provision;
import group48.enterprice.model.Purchase;
import group48.enterprice.model.Store;
import group48.enterprice.model.User;

/**
 *
 * @author Theodosis Tsaklanos - 8170136
 * @author Paris Mpampaniotis - 8170080
 *
 */
public class PurchaseDAO {

    public List<Purchase> getPreviousPurchases(User user) throws Exception {

        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Purchase> previousPurchases = new ArrayList<Purchase>();
        try {
            String sqlQuery = "";
            if(user instanceof Customer) {
                sqlQuery = Query.FIND_ALL_BOUGHT_PRODUCTS_CUSTOMER;;
            } else if(user instanceof Store) {
                sqlQuery = Query.FIND_ALL_BOUGHT_PRODUCTS_STORE;
            }
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setString(1, user.getUsername());
            rs = stmt.executeQuery();
            int previousCheckedPurchaseID = Integer.MAX_VALUE;
            Purchase purchase = null;
            Product product = null;
            Store store = null;
            while (rs.next()) {
                int purchaseID = rs.getInt(1);
                if(purchaseID < previousCheckedPurchaseID) {
                    Date date = rs.getDate(5);
                    double totalCost = rs.getDouble(6);
                    purchase = new Purchase(purchaseID, date, totalCost);
                    previousPurchases.add(purchase);
                }
                product = getProductOfPurchase(connection, rs.getString(2));
                double productPrice = rs.getDouble(4);
                store = getStoreOfPurchase(connection, rs.getString(7));
                Provision provision = new Provision(product, store, productPrice);
                LineItem item = new LineItem(provision, rs.getInt(3));
                purchase.addLineItemToProducts(item);
                previousCheckedPurchaseID = purchaseID;
            }

            rs.close();
            stmt.close();
            database.close();
            return previousPurchases;

        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
    }

    private Store getStoreOfPurchase(Connection connection, String username) throws Exception {
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String sqlQuery = new Query().getFindStoreInfoQuery();
        Store store = null;
        try {
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setString(1, username);
            rs = stmt.executeQuery();
            if(rs.next()) {
                String fullname = rs.getString(2);
                String email = rs.getString(3);
                String country = rs.getString(4);
                String city = rs.getString(5);
                String address = rs.getString(6);
                String zip = rs.getString(7);
                AddressInfo ad = new AddressInfo(country, city, address, zip);
                String password = rs.getString(8);
                String image = rs.getString(9);
                String storeName = rs.getString(11);
                String bankNumber = rs.getString(12);
                String website = rs.getString(13);
                return new Store(username, fullname, storeName, email,
                    password, ad, image, website, bankNumber);
            }
            return store;
        } catch(Exception e) {
            throw new Exception(e.getMessage());
        }
    }

    private Product getProductOfPurchase(Connection connection, String productName) throws Exception {
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String sqlQuery = Query.FIND_PRODUCT;
        Product product = null;
        try {
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setString(1, productName);
            rs = stmt.executeQuery();
            if (rs.next()) {
                String productImage = rs.getString(2);
                String category = rs.getString(3).toUpperCase();
                String subCategory = rs.getString(4);
                String brand = rs.getString(5);
                String color = rs.getString(6);
                product = new Product(productName, productImage, Category.valueOf(category), subCategory, brand, color);
            }
            rs.close();
            stmt.close();
            return product;
        } catch(Exception e) {
            throw new Exception(e.getMessage());
        }
    }

    public void insertPurchase(Purchase purchase, Customer customer) throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        ResultSet rs = null;
        PreparedStatement stmt = null;
        List<Purchase> subpurchases = purchase.divideIntoSubpurchases();
        String sqlQuery = "insert into purchase(total_cost,cust_username,b_username) values (?, ?, ?);";

        try {
            for(Purchase subpurchase : subpurchases) {
                stmt = connection.prepareStatement(sqlQuery);
                stmt.setDouble(1, subpurchase.getTotalCost());
                stmt.setString(2, customer.getUsername());
                //all the store objects in a subpurchase's products are referring
                //to the same store
                Store store = subpurchase.getProducts().get(0).getProvision().getStore();
                stmt.setString(3, store.getUsername());
                stmt.executeUpdate();

                String getLastPurchaseQuery = "SELECT purchase_id FROM purchase ORDER BY purchase_id DESC LIMIT 1";
                stmt = connection.prepareStatement(getLastPurchaseQuery);
                rs = stmt.executeQuery();
                int purchaseID = 0;
                if(rs.next()) {
                    purchaseID = rs.getInt(1);
                }

                String updateProductStoreQuery = "insert into product_purchase values (?,?,?,?);";
                String updateStockQuery = "UPDATE product_store SET stock = (stock - ?) WHERE product_name= ? AND b_username= ?;";
                for(LineItem item : subpurchase.getProducts()) {
                    stmt = connection.prepareStatement(updateProductStoreQuery);
                    stmt.setInt(1, purchaseID);
                    stmt.setString(2, item.getProvision().getProduct().getProductName());
                    stmt.setInt(3, item.getQuantity());
                    stmt.setDouble(4, item.getProvision().getPrice());
                    stmt.executeUpdate();

                    stmt = connection.prepareStatement(updateStockQuery);
                    stmt.setInt(1, item.getQuantity());
                    stmt.setString(2, item.getProvision().getProduct().getProductName());
                    stmt.setString(3, item.getProvision().getStore().getUsername());
                    stmt.executeUpdate();
                }
            }
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

}
