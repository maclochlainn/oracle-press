/*
 * ReadFile1.java
 * Chapter 15, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script demonstrates how to read a file in Java.
 * It is designed as a Java library file.
 */

// Class imports.
import java.io.*;

// Class defintion.
public class ReadFile1
{
  // Convert the string to a file resource and call private method.
  public static String readString(String s) {
    return readFileString(new File(s)); }

  // Read an external file.
  private static String readFileString(File file) {
    // Define local variables.
    int c;
    String s = new String();
    FileReader inFile;

    try {
      inFile = new FileReader(file);
      while ((c = inFile.read()) != -1) {
        s += (char) c; }
    }
    catch (IOException e) {
      return e.getMessage(); }

    return s;
  }

  // Testing method.
  public static void main(String[] args) {
    String file = new String("/tmp/file.txt");
    System.out.println(ReadFile1.readString(file)); }
}
