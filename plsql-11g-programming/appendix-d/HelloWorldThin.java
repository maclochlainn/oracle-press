/*
 * HelloWorldThin.java
 * Appendix D, Oracle Expert PL/SQL Programming
 * by Ron Hardman and Michael McLaughlin
 *
 * This script builds a stand alone Java program.
 */

// Class imports.
import java.io.IOException;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

// Oracle class imports.
import oracle.jdbc.driver.OracleDriver;
import oracle.jdbc.pool.OracleDataSource;

// -------------------------- Begin Class ----------------------------/
public class HelloWorldThin {

  // Define a static class String variable.
  private static String user;

  // ----------------------- Begin Methods ---------------------------/

  // Print line only method.
  private static void printLine() {
    printLine(null); }

  // Print text with a line method.
  private static void printLine(String s) {
    if (s != null) {
      System.out.println(s); }

    // Print line.
    System.out.print  ("---------------------------------------");
    System.out.println("---------------------------------------"); }

  // Read line from standard input.
  private static String readEntry() {
    try {

      // Define method variables.
      int c;
      StringBuffer buffer = new StringBuffer();

      // Read first character.
      c = System.in.read();

      // Read remaining characters.
      while (c != '\n' && c != -1) {
        buffer.append((char) c);
        c = System.in.read(); }

      // Return buffer.
      return buffer.toString().trim(); }
    catch (IOException e) {
      return null; }}

  // ------------------------ End Methods ----------------------------/

  // Static main to test JDBC connection, with exceptions thrown.
  public static void main(String args[]) throws SQLException, IOException
  {
    // Define method variables.
    boolean debug = false;
    int slashIndex;
    String userIn;
    String passwd;
    String host;
    String port;
    String db;
    String debugString = new String("DEBUG");

    // Print line.
    printLine();

    // Verify and print debug mode.
    if (args.length > 0) {
      if (args[0].toUpperCase().equals(debugString)) {
        debug = true;
        printLine("Debug mode is enabled."); }
      else {
        for (int i = 0;i < args.length;i++) {
          System.out.println("Incorrect argument(s): [" + args[i] + "]"); }

        // Print line and message.
        printLine();
        printLine("Valid case insensitive argument is: DEBUG."); }}

    // Prompt, read and capture credentials.
    System.out.print("Enter User [UID/PASSWD]: ");

    // Read input.
    userIn = readEntry();

    // Parse and check for token between user name and passwd.
    slashIndex = userIn.indexOf("/");
    if (slashIndex != -1) {
      user = userIn.substring(0, slashIndex);
      passwd = userIn.substring(slashIndex + 1); }
    else {
      user = userIn;
      System.out.print("Enter Password: ");
      passwd = readEntry(); }

    // Prompt, read and capture host name.
    System.out.print("Enter Host Name: ");
    host = readEntry();

    // Prompt, read and capture port number.
    System.out.print("Enter Port Number: ");
    port = readEntry();

    // Prompt, read and capture db name.
    System.out.print("Enter Database Name: ");
    db = readEntry();

    // Print line and message.
    printLine("Connecting to the db ...");
    printLine("jdbc:oracle:oci8:@" +
               host + ":" + port + ":" + db + "," +
               user + "," + passwd);

    // Attempt db connection.
    try {
      // Set the Pooled Connection Source
      OracleDataSource ods = new OracleDataSource();
      String url = "jdbc:oracle:thin:@//" + host + ":" + port + "/" + db;
      ods.setURL(url);
      ods.setUser(user);
      ods.setPassword(passwd);

      // Define connection.
      Connection conn = ods.getConnection();

      // Print message.
      printLine("Connected.");

      // Define metadata object.
      DatabaseMetaData dmd = conn.getMetaData();

      // Print db metadata.
      printLine("Driver Version: [" + dmd.getDriverVersion() + "]\n" +
                "Driver Name:    [" + dmd.getDriverName() + "]");

      // Create statement.
      Statement stmt = conn.createStatement();

      // Execute and assign statement result set.
      ResultSet rset = stmt.executeQuery("SELECT 'Hello World.' FROM dual");

      // Read row returns.
      while (rset.next()) {
        printLine(rset.getString(1)); }

      // Close result set.
      rset.close();
      stmt.close();
      conn.close();

      // Print line and message.
      printLine("The JDBC Connection worked."); }
    catch (SQLException e) {
      if (debug) {
        e.printStackTrace();
        printLine(); }
      else {
        if (e.getSQLState() == null) {
          System.out.println(
            new SQLException("Oracle Thin Client Net8 Connection Error.",
                      "ORA-" + e.getErrorCode() +
                      ": Incorrect Net8 thin client arguments:\n\n" +
                      "  host name     [" + host + "]\n" +
                      "  port number   [" + port + "]\n" +
                      "  db name [" + db + "]\n",
                      e.getErrorCode()).getSQLState()); }
        else {
          // Trim the postpended "\n".
          printLine(e.getMessage().substring(0,e.getMessage().length() - 1)); }}

      // Print line and message.
      printLine("The JDBC Connection failed."); }}}
