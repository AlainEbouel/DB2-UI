package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConnexionOracle {
    private static final String HOST = "localhost";
    private static final String PORT = "1521";
    private static final String SERVICE_NAME = "FREEPDB1";
    private static final String USERNAME = "SMI1002_059";
    private static final String PASSWORD = "23sxfn43";

    public static Connection getConnection() throws Exception {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        String jdbcUrl = "jdbc:oracle:thin:@//" + HOST + ":" + PORT + "/" + SERVICE_NAME;
        return DriverManager.getConnection(jdbcUrl, USERNAME, PASSWORD);
    }
}