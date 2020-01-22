package group48.enterprice.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

import group48.enterprice.model.AddressInfo;
import group48.enterprice.model.Customer;
import group48.enterprice.model.Store;
import group48.enterprice.model.User;


public class UserDAO {

    public List<String> loadAvatars() throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<String> avatars = new ArrayList<String>();
        String sqlQuery = "SELECT * FROM avatar";
        try {
            stmt = connection.prepareStatement(sqlQuery);
            rs = stmt.executeQuery();

            while(rs.next()) {
                avatars.add(rs.getString(1));
            }
            rs.close();
            stmt.close();
            database.close();
            return avatars;

        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if (connection != null) {
                connection.close();
            }
        }
    }

    public boolean checkIfUserExists(String username) throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean found;
        String sql = "SELECT * FROM account WHERE username=?;";
        try {
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();
            if(rs.next()) {
                found = true;
            } else {
                found = false;
            }
            rs.close();
            stmt.close();
            database.close();
            return found;
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if(connection != null) {
                connection.close();
            }
        }
    }

    public void register(User user) throws Exception {
        Database database = new Database();
        Connection con = database.getConnection();
        PreparedStatement stmt = null;
        String sqlQuery = "INSERT INTO account VALUES(?,?,?,?,?,?,?,?,?);";
        try {
            stmt = con.prepareStatement(sqlQuery);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getFullname());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getAdInfo().getCountry());
            stmt.setString(5, user.getAdInfo().getCity());
            stmt.setString(6, user.getAdInfo().getAddress());
            stmt.setString(7, user.getAdInfo().getZip());
            stmt.setString(8, user.getPassword());

            PreparedStatement stmt2 = null;
            if(user instanceof Customer) {
                stmt.setString(9, "icons/navbar-user-icon.png");

                String sqlQuery2 = "INSERT INTO customer_account VALUES (?);";
                stmt2 = con.prepareStatement(sqlQuery2);
                stmt2.setString(1, user.getUsername());
            } else if (user instanceof Store) {
                stmt.setString(9, "icons/online-store.png");

                String sqlQuery2 = "INSERT INTO business_account VALUES (?,?,?,?)";
                stmt2 = con.prepareStatement(sqlQuery2);
                stmt2.setString(1, user.getUsername());
                stmt2.setString(2, ((Store) user).getStoreName());
                stmt2.setString(3, ((Store) user).getAccountNumber());
                stmt2.setString(4, ((Store) user).getWebsite());
            }
            stmt.executeUpdate();
            stmt.close();
            stmt2.executeUpdate();
            stmt2.close();
            database.close();
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if(con != null) {
                con.close();
            }
        }
    }

    public void updateProfilePicture(String username, String src) throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        String sqlQuery = "UPDATE account SET user_image=? WHERE username=?";
        try {
            stmt = connection.prepareStatement(sqlQuery);
            stmt.setString(1, src);
            stmt.setString(2, username);
            stmt.executeUpdate();
        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if(connection != null) {
                connection.close();
            }
        }
    }

    public void update(User user) throws Exception {
        Database database = new Database();
        Connection con = database.getConnection();
        PreparedStatement stmt = null;
        String sqlQuery = "UPDATE account SET username = ?, fullname = ?, email = ?, country = ?, city = ?, address = ?, zip = ?, password = ?, user_image=? WHERE username=?;";
        try {
            stmt = con.prepareStatement(sqlQuery);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getFullname());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getAdInfo().getCountry());
            stmt.setString(5, user.getAdInfo().getCity());
            stmt.setString(6, user.getAdInfo().getAddress());
            stmt.setString(7, user.getAdInfo().getZip());
            stmt.setString(8, user.getPassword());
            stmt.setString(9, user.getImage());
            stmt.setString(10, user.getUsername());
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

    public LinkedHashMap<String, Integer> getUserStatistics() throws Exception {
        return null;

    }


    /* DANGER */
    public static Store findStore(String username) throws Exception {
        Database database = new Database();
        Connection connection = database.getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Store user;
        String sql = "select * from (SELECT * FROM business_account left join account on account.username = business_account.b_username) as store where b_username = ?;";
        try {
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();
            if(rs.next()) {
                String fullname = rs.getString("fullname");
                String email = rs.getString("email");
                String password = rs.getString("password");
                String storeName = rs.getString("store_name");
                String image = rs.getString("user_image");
                String website = rs.getString("website");
                String accountNumber = rs.getString("bank_number");
                AddressInfo adInfo = new AddressInfo(rs.getString("country"), rs.getString("city"),
                    rs.getString("address"), rs.getString("zip"));
                user = new Store(username, fullname, storeName, email, password, adInfo, image, website, accountNumber);
            } else {
                user = null;
            }
            rs.close();
            stmt.close();
            database.close();
            return user;
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if(connection != null) {
                connection.close();
            }
        }
    }
}