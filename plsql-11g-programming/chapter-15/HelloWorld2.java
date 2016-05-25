/*
 * HelloWorld2.java
 * Chapter 15, Oracle Database 11g PL/SQL Programming
 * by Michael McLaughlin
 *
 * ALERTS:
 *
 * This script builds an internal or server-side Java class file.
 */

// Oracle class imports.
import oracle.jdbc.driver.*;

// Class definition.
public class HelloWorld2 {

  public static String hello() {
    return "Hello World."; }

  public static String hello(String name) {
    return "Hello " + name + "."; }

  public static void main(String args[]) {
    System.out.println(HelloWorld2.hello());
    System.out.println(HelloWorld2.hello("Larry")); }
}
