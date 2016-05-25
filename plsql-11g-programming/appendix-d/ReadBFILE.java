// --------------------------------------------------------------------
// ReadBFILE.java
// Appendix D, Oracle Database 11g PL/SQL Programming
// by Michael McLaughlin
//
// This code demonstrates reading an image file and displaying
// the image in a JLabel in a JFrame.
// --------------------------------------------------------------------

// Required imports.
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import java.awt.GridLayout;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.File;
import javax.imageio.ImageIO;

// Generic JDBC imports.
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;

// Oracle JDBC import.
import oracle.jdbc.driver.*;

// Class definition.
public class ReadBFILE extends JPanel {

  // Define database connections.
  private String host = "mclaughlin-dev.techtinker.com";
  private String port = "1521";
  private String dbname = "XE";
  private String userid = "PHP";
  private String passwd = "PHP";

  // Use to read and diaplay BFILE image file.
  private BufferedImage image;
  private JLabel label;
  private String canonicalFileName;

  // -----------------------------------------------------------------/
  public ReadBFILE () {

    // Set layout manager.
    super(new GridLayout(1,0));

    // Query the database and read canonical file name.
    canonicalFileName = getQuery(host,port,dbname,userid,passwd);
    try {
      image = ImageIO.read(new File(canonicalFileName)); }
    catch (IOException e) {
      System.out.println(e.getMessage()); }

    // Put the image into a container and add container to JPanel.
    label = new JLabel(new ImageIcon(image));
    add(label); }
  // -----------------------------------------------------------------/
  private String getQuery(String host,String port,String dbname
                         ,String user,String pswd) {

    // Define return variable.
    String data = null;

    try
    {
      // Load Oracle JDBC driver.
      DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());

      // Define and initialize a JDBC connection.
      Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@" +
                          host + ":" + port + ":" + dbname, userid, passwd);

      // Create statement.
      CallableStatement stmt =
        conn.prepareCall("BEGIN " +
                         "  ? := get_canonical_bfilename(?,?,?,?);" +
                         "END;");

      // Register the OUT mode variable.
      stmt.registerOutParameter(1,Types.VARCHAR);

      // Register the IN mode variables.
      stmt.setString(2,"item");
      stmt.setString(3,"item_photo");
      stmt.setString(4,"item_title");
      stmt.setString(5,"Star Wars I");

      // Execute query.
      if (stmt.execute());

      // Read rows and only CLOB data type columns.
      data = (String) stmt.getString(1);

      // Close resources.
      stmt.close();
      conn.close();

      // Return CLOB as a String data type.
      return data; } // End of connection try-block.

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
      else { System.out.println("here");
        System.out.println(e.getMessage());

        // Return an empty String on error.
        return data; }}
      finally {
		if (data == null) System.exit(1); }}
  // -----------------------------------------------------------------/
  public static void main(String[] args) {
    JFrame frame = new JFrame("Read BFILE Image");
    ReadBFILE panel = new ReadBFILE();
    panel.setOpaque(true);
    frame.setContentPane(panel);
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    frame.setLocation(100,100);
    frame.pack();
    frame.setVisible(true); }}
