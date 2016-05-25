// --------------------------------------------------------------------
// QueryTable.java
// Appendix D, Oracle Database 11g PL/SQL Programming
// by Michael McLaughlin
//
// This code demonstrates reading scalar variables into a JTable.
// --------------------------------------------------------------------

// Java Application class imports.
import java.awt.Component;
import java.awt.Dimension;
import java.awt.image.BufferedImage;
import java.awt.GridLayout;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumn;
import javax.swing.table.TableModel;

// Generic JDBC imports.
import java.sql.Clob;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

// Oracle class imports.
import oracle.jdbc.driver.OracleDriver;
// -------------------------------------------------------------------/
public class QueryTable extends JPanel {
  // Define database connections.
  private String host = "mclaughlin-dev.techtinker.com";
  private String port = "1521";
  private String dbname = "XE";
  private String userid = "PHP";
  private String passwd = "PHP";

  // Define target table and query row size variable.
  private String target = "CONTACT";
  private int querySize = 0;

  // Define containers.
  private Object[][] data = getQuery(host,port,dbname,userid,passwd,target);
  private Object[][] cells = getData();
  private Object[] columns = getColumnHeaders();

  // Define display variables.
  private JTable table = new JTable(cells,columns);
  private JScrollPane scrollPane;
  private TableModel tableModel;
  // -----------------------------------------------------------------/
  public QueryTable () {
    super(new GridLayout(1,0));
    decorate(300,100); }
  // -----------------------------------------------------------------/
  private String[] getColumnHeaders() {
    // Size container, copy column headers and return data.
    String[] headers = new String[data[0].length];
    for (int i = 0;i < data[0].length;i++)
      headers[i] = (String) data[0][i];
    return headers; }
  // -----------------------------------------------------------------/
  private Object[][] getData() {
    // Size container, copy cells and return data.
    Object[][] cells = new Object[querySize][];
    for (int i = 0;i < querySize;i++) {
      cells[i] = new Object[data[i + 1].length];
      for (int j = 0;j < data[i + 1].length;j++)
        cells[i][j] = data[i + 1][j]; }
    return cells; }
  // -----------------------------------------------------------------/
  private void decorate (int width, int height) {
    // Configure JPanel.
    setSize(width,height);

    // Configure and initialize JTable.
    table.setPreferredScrollableViewportSize(new Dimension(width,height));
    table.setFillsViewportHeight(true);
    initColumns(table);

    // Assign JScrollPane.
    scrollPane = new JScrollPane(table);
    add(scrollPane); }
  // -----------------------------------------------------------------/
  private void initColumns(JTable table) {
    // Initialize cell width.
    int headerWidth = 0;
    int cellWidth = 0;

    // Define display variables.
    Component component = null;
    TableColumn tableColumn = null;
    TableCellRenderer headerRenderer =
      table.getTableHeader().getDefaultRenderer();

    // Initialize TableModel class.
    tableModel = table.getModel();

    // Initialize columns.
    for (int i = 0;i < table.getColumnCount();i++)
      tableColumn = table.getColumnModel().getColumn(i); }
  // -----------------------------------------------------------------/
  private Object[][] getQuery(String host,String port,String dbname
                             ,String user,String pswd,String table) {
    // Define return type container.
    Object[][] dataset = null;
    String[] datatype = null;

    try {
      // Load driver, initialize connection, metadata and statement..
      DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
      Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@" +
                          host + ":" + port + ":" + dbname, userid, passwd);
      DatabaseMetaData dmd = conn.getMetaData();
      Statement stmt = conn.createStatement();

      // Declare result set, initialize dataset and close result set.
      ResultSet rset = stmt.executeQuery("SELECT COUNT(*) FROM " + table);
      while (rset.next())
        dataset = new Object[rset.getInt(1) + 1][];
      rset.close();

      // Reusing result set and get result set metadata.
      rset = stmt.executeQuery("SELECT * FROM " + table);
      ResultSetMetaData rsmd = rset.getMetaData();

      // Declare row counter.
      int row = 0;

      // Assign array sizes.
      dataset[row] = new Object[rsmd.getColumnCount()];
      datatype = new String[rsmd.getColumnCount()];

      // Assign column labels and types.
      for (int col = 0;col < rsmd.getColumnCount();col++) {
        dataset[row][col] = rsmd.getColumnName(col + 1);
        datatype[col] = rsmd.getColumnTypeName(col + 1); }

      // Size nested arrays and assign column values for rows.
      while (rset.next()) {
        dataset[++row] = new Object[rsmd.getColumnCount()];
        for (int col = 0;col < rsmd.getColumnCount();col++)
          if (datatype[col] == "DATE")
            dataset[row][col] = rset.getDate(col + 1);
          else if (datatype[col] == "NUMBER")
            dataset[row][col] = rset.getLong(col + 1);
          else if (datatype[col] == "VARCHAR2")
            dataset[row][col] = rset.getString(col + 1); }

      // Set query return size.
      querySize = row;

      // Close resources.
      rset.close();
      stmt.close();
      conn.close();

      // Return data.
      return dataset; }
    catch (SQLException e) {
      // Check for and return connection error or SQL error.
      if (e.getSQLState() == null) {
        System.out.println(
          new SQLException("Oracle Thin Client Net8 Connection Error.",
                           "ORA-" + e.getErrorCode() +
                           ": Incorrect Net8 thin client arguments:\n\n" +
                           "  host name     [" + host + "]\n" +
                           "  port number   [" + port + "]\n" +
                           "  database name [" + dbname + "]\n"
                           , e.getErrorCode()).getSQLState());
        return dataset; }
      else {
        System.out.println(e.getMessage());
        return dataset; }}}
  // -----------------------------------------------------------------/
  public static void main(String[] args) {
    // Define window.
    JFrame frame = new JFrame("Query Table");

    // Define and configure panel.
    QueryTable panel = new QueryTable();
    panel.setOpaque(true);

    // Configure window and enable default close operation.
    frame.setContentPane(panel);
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    frame.setLocation(100,100);
    frame.pack();
    frame.setVisible(true); }}