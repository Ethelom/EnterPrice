package group48.enterprice.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {
    private final String dbServer = "195.251.249.131";
    private final String dbServerPort = "3306";
    private final String dbName = "ismgroup48";
    private final String dbusername = "ismgroup48";
    private final String dbpassword = "e3xn#2";
    private Connection connection;

    public Connection getConnection() throws Exception {

        try {
            Class.forName("com.mysql.jdbc.Driver").getDeclaredConstructor().newInstance();
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        }

        try {

            connection = DriverManager.getConnection("jdbc:mysql://"
                + dbServer + ":" + dbServerPort + "/" + dbName, dbusername, dbpassword);

            return connection;

        } catch (Exception e) {
            throw new Exception("Could not establish connection with the Database Server: "
                + e.getMessage());
        }

    }

    public void close() throws SQLException {

        try {
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {

            throw new SQLException("Could not close connection with the Database Server: "
                + e.getMessage());
        }
    }
}
