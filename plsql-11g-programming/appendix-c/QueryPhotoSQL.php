<html>
<! QueryPhotoSQL.php                                          >
<! Appendix C, Oracle Database 11g PL/SQL Programming         >
<! by Michael McLaughlin                                      >
<!                                                            >
<! This script demonstrates how to return BFILE into a web    >
<! by using a SQL SELECT statement.                           >
<head>
<title>
  Appendix C: QueryPhotoSQL.php
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
    (isset($_GET['id'])) ? $id = (int) $_GET['id'] : $id = 1;
    (isset($_GET['name'])) ? $name = $_GET['name'] : $name = "Washington";

    // Declare a PL/SQL execution command.
    $stmt = "SELECT   GET_BFILENAME(president_id) AS file_name
             FROM     president
             WHERE    president_id = :id";

    // Parse a query through the connection.
    $s = oci_parse($c,$stmt);

    // Bind PHP variables to the OCI types.
    oci_bind_by_name($s,':id',$id,-1,SQLT_INT);

    // Execute the PL/SQL statement.
    if (oci_execute($s))
    {
       // Return a LOB descriptor as the value.
	   while (oci_fetch($s))
	   {
	      for ($i = 1;$i <= oci_num_fields($s);$i++)
	        $file_name = oci_result($s,$i);

       } // End of the while(oci_fetch($s)) loop.

      // Format HTML table to display photograph.
      $out = '<table border="1" cellpadding="3" cellspacing="0">';
      $out .= '<tr>';
      $out .= '<td align="center" class="e">Photo of '.$name.'</td>';
      $out .= '</tr>';
      $out .= '<tr>';
      $out .= '<td align="center" class="v" valign="center">';
      if (!is_null($file_name))
        $out .= '<img src="http://hostname.domain_name/mydirectory/'.$file_name.'">';
      else
        $out .= 'No available photo';
      $out .= '</td>';
      $out .= '</tr>';
      $out .= '</table>';
    }

    // Print the HTML table.
    print $out;

    // Disconnect from database.
    oci_close($c);
  }
  else
  {
    // Assign the OCI error and format double and single quotes.
    $errorMessage = oci_error();
    print htmlentities($errorMessage['message'])."<br />";
  }
?>
</body>
</html>