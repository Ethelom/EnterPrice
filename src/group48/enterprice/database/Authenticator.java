package group48.enterprice.database;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import group48.enterprice.model.AddressInfo;
import group48.enterprice.model.Customer;
import group48.enterprice.model.Store;
import group48.enterprice.model.User;

public class Authenticator {

    public User authenticate(String username, String password) throws Exception {
        Database database = new Database();
        Connection con = database.getConnection();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM account WHERE username=? AND password=?;";

        try {
            stmt = con.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String fullname = rs.getString(2);
                String email = rs.getString(3);
                AddressInfo address = new AddressInfo(rs.getString(4),
                    rs.getString(5), rs.getString(6), rs.getString(7));
                String image = rs.getString(9);

                //search the type of user
                String searchInStoreTable = "SELECT * FROM business_account WHERE b_username = ?;";
                PreparedStatement stmt2 = null;
                ResultSet rs2 = null;
                try {
                    stmt2 = con.prepareStatement(searchInStoreTable);
                    stmt2.setString(1, username);
                    rs2 = stmt2.executeQuery();
                    if(rs2.next()) {
                        String storeName = rs2.getString(2);
                        String bankNumber = rs2.getString(3);
                        String website = rs2.getString(4);
                        return new Store(username, fullname, storeName, email, password, address, image, website, bankNumber);
                    } else {
                        return new Customer(username, fullname, email, password, address, image);
                    }
                } catch (Exception e) {
                    throw new Exception(e.getMessage());
                } finally {
                    rs2.close();
                    stmt2.close();
                    rs.close();
                    stmt.close();
                    database.close();
                }
            } else {
                throw new Exception("Wrong username or password. Please try again!");
            }
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            if (con != null) {
                con.close();
            }
        }
    }

}
