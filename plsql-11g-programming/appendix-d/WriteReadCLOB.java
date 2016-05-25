// --------------------------------------------------------------------
// WriteReadCLOB.java
// Appendix D, Oracle Database 11g PL/SQL Programming
// by Michael McLaughlin
//
// This code demonstrates reading an image file and displaying
// the image in a JLabel in a JFrame.
//
// The UPDATE and SELECT statements have dependencies on the
// create_store.sql script downloadable from the publisher's
// website.
// --------------------------------------------------------------------

// Java Application class imports.
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GridLayout;
import java.io.Reader;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

// Generic JDBC imports.
import java.sql.CallableStatement;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

// Oracle JDBC import.
import oracle.jdbc.driver.OracleDriver;
import oracle.jdbc.pool.OracleDataSource;

// Include book libraries (available at publisher website).
import plsql.jdbc.DataConnectionPane;
import plsql.fileio.FileIO;
// -------------------------------------------------------------------/
public class WriteReadCLOB extends JFrame {
  // Define database connections.
  private String host;
  private String port;
  private String dbname;
  private String userid;
  private String passwd;

  // Define data connection pane.
  private DataConnectionPane message = new DataConnectionPane();

  // Construct the class.
  public WriteReadCLOB (String s) {
    super(s);

    // Get database connection values or exit.
    if (JOptionPane.showConfirmDialog(this,message
          ,"Set Oracle Connection String Values"
          ,JOptionPane.OK_CANCEL_OPTION) == 0) {

      // Set class connection variables.
      host = message.getHost();
      port = message.getPort();
      dbname = message.getDatabase();
      userid = message.getUserID();
      passwd = message.getPassword();

      // Print connection to console (debugging tool).
      message.getConnection();

      // Create a JPanel for data display.
      ManageCLOB panel = new ManageCLOB();

      // Configure the JPanel.
      panel.setOpaque(true);
      setContentPane(panel);

      // Configure the JFrame.
      setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      setLocation(100,100);
      pack();
      setVisible(true); }
    else
      System.exit(1); }
  // -------------------------------------------------------------------/
  private class ManageCLOB extends JPanel {

    // Define display variables.
    private String clobText;
    private JScrollPane scrollPane;
    private JTextArea textArea;
    // -----------------------------------------------------------------/
    public ManageCLOB () {
      // Set layout manager.
      super(new GridLayout(1,0));

      // Assign file read to String.
      clobText = FileIO.openFile(FileIO.findFile(this));

      // Insert record before querying it.
      if (clobText.length() > 0) {
        if (insertClob(host,port,dbname,userid,passwd,clobText))
          clobText = getQuery(host,port,dbname,userid,passwd); }
      else
        System.exit(2);

      // Construct text area and format it.
      textArea = new JTextArea(clobText);
      textArea.setEditable(false);
      textArea.setFont(new Font(Font.SANS_SERIF,Font.PLAIN,14));
      textArea.setLineWrap(true);
      textArea.setRows(10);
      textArea.setSize(400,100);
      textArea.setWrapStyleWord(true);

      // Put the image in container, and add label to panel.
      scrollPane = new JScrollPane(textArea);
      add(scrollPane); }
    // ---------------------------------------------------------------/
    private Boolean insertClob(String host,String port,String dbname
                              ,String user,String pswd,String fileString) {

      try
      {
        // Set the Pooled Connection Source
        OracleDataSource ods = new OracleDataSource();
        String url = "jdbc:oracle:thin:@//"+host+":"+port+"/"+dbname;
        ods.setURL(url);
        ods.setUser(userid);
        ods.setPassword(passwd);

        // Define connection.
        Connection conn = ods.getConnection();

        // Create statement.
        CallableStatement stmt =
          conn.prepareCall("UPDATE item "+
                           "SET    item_desc = ? "+
                           "WHERE  item_title = "+
                           "'The Lord of the Rings - Fellowship of the Ring'"+
                           "AND    item_subtitle = 'Widescreen Edition'");

        // Set string into statement.
        stmt.setString(1,fileString);

        // Execute query.
        if (stmt.execute())
          conn.commit();

        // Close resources.
        stmt.close();
        conn.close();

        // Return CLOB as a String data type.
        return true; } // End of connection try-block.

      catch (SQLException e) {
        if (e.getSQLState() == null) {
          System.out.println(
            new SQLException("Oracle Thin Client Net8 Connection Error.",
                             "ORA-" + e.getErrorCode() +
                             ": Incorrect Net8 thin client arguments:\n\n" +
                             "  host name     [" + host + "]\n" +
                             "  port number   [" + port + "]\n" +
                             "  database name [" + dbname + "]\n"
                             , e.getErrorCode()).getSQLState());

          // Return an empty String on error.
          return false; }
        else {
          System.out.println(e.getMessage());

          // Return an empty String on error.
          return false; }}}
    // -----------------------------------------------------------------/
    private String getQuery(String host,String port,String dbname
                           ,String user,String pswd) {

      // Define method variables.
      char[] buffer;
      int count = 0;
      int length = 0;
      String data = null;
      String[] type;
      StringBuffer sb;

      try {
        // Set the Pooled Connection Source
        OracleDataSource ods = new OracleDataSource();
        String url = "jdbc:oracle:thin:@//"+host+":"+port+"/"+dbname;
        ods.setURL(url);
        ods.setUser(userid);
        ods.setPassword(passwd);

        // Define connection.
        Connection conn = ods.getConnection();

        // Define metadata object.
        DatabaseMetaData dmd = conn.getMetaData();

        // Create statement.
        Statement stmt = conn.createStatement();

        // Execute query.
        ResultSet rset =
          stmt.executeQuery(
            "SELECT item_desc " +
            "FROM   item " +
            "WHERE  item_title = " +
            "'The Lord of the Rings - Fellowship of the Ring'"+
            "AND    item_subtitle = 'Widescreen Edition'");

        // Get the query metadata, size array and assign column values.
        ResultSetMetaData rsmd = rset.getMetaData();
        type = new String[rsmd.getColumnCount()];
        for (int col = 0;col < rsmd.getColumnCount();col++)
          type[col] = rsmd.getColumnTypeName(col + 1);

        // Read rows and only CLOB data type columns.
        while (rset.next()) {
          for (int col = 0;col < rsmd.getColumnCount();col++) {
            if (type[col] == "CLOB") {
              // Assign result set to CLOB variable.
              Clob clob = rset.getClob(col + 1);

              // Check that it is not null and read the character stream.
              if (clob != null) {
                Reader is = clob.getCharacterStream();

                // Initialize local variables.
                sb = new StringBuffer();
                length = (int) clob.length();

                // Check CLOB is not empty.
                if (length > 0) {

                  // Initialize control structures to read stream.
                  buffer = new char[length];
                  count = 0;

                  // Read stream and append to StringBuffer.
                  try {
                    while ((count = is.read(buffer)) != -1)
                      sb.append(buffer);

                    // Assign StringBuffer to String.
                    data = new String(sb); }
                  catch (Exception e) {} }
                else
                  data = (String) null; }
              else
                data = (String) null; }
            else {
              data = (String) rset.getObject(col + 1); }}}

        // Close resources.
        rset.close();
        stmt.close();
        conn.close();

        // Return CLOB as a String data type.
        return data; }
      catch (SQLException e) {
        if (e.getSQLState() == null) {
          System.out.println(
            new SQLException("Oracle Thin Client Net8 Connection Error.",
                             "ORA-" + e.getErrorCode() +
                             ": Incorrect Net8 thin client arguments:\n\n" +
                             "  host name     [" + host + "]\n" +
                             "  port number   [" + port + "]\n" +
                             "  database name [" + dbname + "]\n"
                             , e.getErrorCode()).getSQLState());

          // Return an empty String on error.
          return data; }
        else {
          System.out.println(e.getMessage());
          return data; }}
        finally {
          if (data == null) System.exit(1); }}}
  // -----------------------------------------------------------------/
  public static void main(String[] args) {
    // Define window.
    WriteReadCLOB frame = new WriteReadCLOB("Write & Read CLOB Text"); }}
