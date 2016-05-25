/*
 * HelloWorld3.java
 * Chapter 15, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script builds an internal or server-side Java class file
 * that queries the local instance.
 */

// Oracle class imports.
import java.sql.*;
import oracle.jdbc.driver.*;

// Class definition.
public class HelloWorld3 {

  public static void doDML(String statement
                          ,String name) throws SQLException {
    // Declare an Oracle connection.
    Connection conn = DriverManager.getConnection("jdbc:default:connection:");

    // Declare prepared statement, run query and read results.
    PreparedStatement ps = conn.prepareStatement(statement);
    ps.setString(1,name);
    ps.execute(); }

  public static String doDQL(String statement) throws SQLException {
    // Define and initialize a local return variable.
    String result = new String();

    // Declare an Oracle connection.
    Connection conn = DriverManager.getConnection("jdbc:default:connection:");

    // Declare prepared statement, run query and read results.
    PreparedStatement ps = conn.prepareStatement(statement);
    ResultSet rs = ps.executeQuery();
    while (rs.next())
      result = rs.getString(1);

    return result; }
}
