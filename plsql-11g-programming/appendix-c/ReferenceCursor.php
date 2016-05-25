<html>
<! ReferenceCursor.php                                        >
<! Appendix C, Oracle Database 11g PL/SQL Programming         >
<! by Michael McLaughlin                                      >
<!                                                            >
<! This code demonstrates reading an image file and           >
<! displaying the image in a JLabel in a JFrame.              >
<head>
<title>
  Chapter 14: ReferenceCursor .php
</title>
<style>
.e {background-color: #ccccff; font-weight: bold; color: #000000;}
.v {background-color: #cccccc; color: #000000;}
</style>
</head>
<body>
<?php
  // Return successful attempt to connect to the database.
  if ($c = @oci_connect("php","php","xe"))
  {
    // Declare input variables.
    (isset($_GET['begin']))   ? $t_start = (int) $_GET['begin']
                              : $t_start = 1787;
    (isset($_GET['end']))     ? $t_end = (int) $_GET['end']
                              : $t_end = (int) date("Y",time());
    (isset($_GET['country'])) ? $country = $_GET['country']
                              : $country = "USA";

    // Declare a PL/SQL execution command.
    $stmt = "BEGIN
               world_leaders.get_presidents(term_start_in => :term_start
                                           ,term_end_in => :term_end
                                           ,country_in => :country
                                           ,presidents => :return_cursor);
             END;";

    // Strip special characters to avoid ORA-06550 and PLS-00103 errors.
    $stmt = strip_special_characters($stmt);

    // Parse a query through the connection.
    $s = oci_parse($c,$stmt);

    // Declare a return cursor for the connection.
    $rc = oci_new_cursor($c);

    // Bind PHP variables to the OCI input or in mode variables.
    oci_bind_by_name($s,':term_start',$t_start,SQLT_INT);
    oci_bind_by_name($s,':term_end',$t_end,SQLT_INT);
    oci_bind_by_name($s,':country',$country,SQLT_CHR);

    // Bind PHP variables to the OCI output or in/out mode variable.
    oci_bind_by_name($s,':return_cursor',$rc,-1,OCI_B_CURSOR);

    // Execute the PL/SQL statement.
    oci_execute($s);

    // Access the returned cursor.
    oci_execute($rc);

    // Print the table header with known labels.
    print '<table border="1" cellpadding="3" cellspacing="0">';

    // Set dynamic labels control variable true.
    $label = true;

    // Read the contents of the reference cursor.
    while($row = oci_fetch_assoc($rc))
    {
      // Declare header and data variables.
      $header = "";
      $data = "";

      // Read the reference cursor into a table.
      foreach ($row as $name => $column)
      {
        // Capture labels for the first row.
        if ($label)
        {
          $header .= '<td class="e">'.$name.'</td>';
          $data .= '<td class="v">'.$column.'</td>';
        }
        else
          $data .= '<td class=v>'.$column.'</td>';
      }

      // Print the header row once.
      if ($label)
      {
        print '<tr>'.$header.'</tr>';
        $label = !$label;
      }

      // Print the data rows.
      print '<tr>'.$data.'</tr>';

    }

    // Print the HTML table close.
    print '</table>';

    // Disconnect from database.
    oci_close($c);
  }
  else
  {
    // Assign the OCI error and format double and single quotes.
    $errorMessage = oci_error();
    print htmlentities($errorMessage['message'])."<br />";
  }

  // Strip special characters, like carriage or line returns and tabs.
  function strip_special_characters($str)
  {
    $out = "";
    for ($i = 0;$i < strlen($str);$i++)
      if ((ord($str[$i]) != 9) && (ord($str[$i]) != 10) &&
          (ord($str[$i]) != 13))
        $out .= $str[$i];

    // Return character only strings.
    return $out;
  }
?>
</body>
</html>
