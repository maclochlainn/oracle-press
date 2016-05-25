// --------------------------------------------------------------------
// ReadImage.java
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

// Include book libraries (available at publisher website).
import plsql.jdbc.DataConnectionPane;
import plsql.fileio.FileIO;
// -------------------------------------------------------------------/
public class ReadImage extends JPanel {
  // Use to read and diaplay BFILE image file.
  private BufferedImage image;
  private JLabel label;
  // -----------------------------------------------------------------/
  public ReadImage () {
    // Set layout manager.
    super(new GridLayout(1,0));

    // Read image file.
    try {
      image = ImageIO.read(FileIO.findFile()); }
    catch (IOException e) {
      System.out.println(e.getMessage()); }

    // Put the image into a container and add container to JPanel.
    label = new JLabel(new ImageIcon(image));
    add(label); }
  // -----------------------------------------------------------------/
  public static void main(String[] args) {
    // Define window.
    JFrame frame = new JFrame("Read BFILE Image");

    // Define and configure panel.
    ReadImage panel = new ReadImage();
    panel.setOpaque(true);

    // Configure window and enable default close operation.
    frame.setContentPane(panel);
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    frame.setLocation(100,100);
    frame.pack();
    frame.setVisible(true); }}