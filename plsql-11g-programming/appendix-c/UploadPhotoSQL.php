<html>
<! UploadPhotoSQL.php                                         >
<! Appendix C, Oracle Database 11g PL/SQL Programming         >
<! by Michael McLaughlin                                      >
<!                                                            >
<! This script demonstrates uploading, moving an uploaded     >
<! file, storing the content in an Oracle BFILE column using  >
<! a stored PL/SQL procedure, and then accesses the stored    >
<! content from the database and renders the page.            >
<head>
<title>
  Appendix C : UploadPhotoSQL.php
</title>
<style>
.e {background-color: #ccccff; font-weight: bold; color: #000000;}
.v {background-color: #cccccc; color: #000000;}
</style>
</head>
<body>
<?php
  // Displayed moved file in web page.
  $f_name = process_uploaded_file();

  // Return successful attempt to connect to the database.
  if ($c = @oci_connect("php","php","xe"))
  {
    // Declare input variables.
    (isset($_POST['id'])) ? $id = (int) $_POST['id'] : $id = 1;
    (isset($_POST['name'])) ? $name = $_POST['name'] : $name = "Washington";

    // Declare a PL/SQL execution command.
    $stmt = "UPDATE    president
             SET       photograph = BFILENAME('MY_DIRECTORY',:f_name)
             WHERE     president_id = :id";

    // Strip special characters to avoid ORA-06550 and PLS-00103 errors.
    $stmt = strip_special_characters($stmt);

    // Parse a query through the connection.
    $s = oci_parse($c,$stmt);

    // Bind PHP variables to the OCI types.
    oci_bind_by_name($s,':id',$id);
    oci_bind_by_name($s,':f_name',$f_name);

    // Execute the PL/SQL statement.
    if (oci_execute($s))
    {
       query_insert($id,$name);
    }

    // Disconnect from database.
    oci_close($c);
  }
  else
  {
    // Assign the OCI error and format double and single quotes.
    $errorMessage = oci_error();
    print htmlentities($errorMessage['message'])."<br />";
  }

  // Query results afret an insert.
  function query_insert($id,$name)
  {
    // Return successful attempt to connect to the database.
    if ($c = @oci_new_connect("php","php","xe"))
    {
      // Declare a PL/SQL execution command.
      $stmt = "BEGIN biography.view_photograph(:id,:alias,:f_name); END;";

      // Parse a query through the connection.
      $s = oci_parse($c,$stmt);

      // Bind PHP variables to the OCI types.
      oci_bind_by_name($s,':id',$id,-1,SQLT_INT);

      // Set OUT mode procedure variables physical runtime size.
      // Avoids an ORA-21560: argument 2 is null, invalid, or out of range
      oci_bind_by_name($s,':alias',$alias,255,SQLT_CHR);
      oci_bind_by_name($s,':f_name',$f_name,255,SQLT_CHR);

      // Execute the PL/SQL statement.
      if (oci_execute($s,OCI_DEFAULT))
      {
        // Format HTML table to display photograph.
        $out = '<table border="1" cellpadding="3" cellspacing="0">';
        $out .= '<tr>';
        $out .= '<td align="center" class="e">Photo of '.$name.'</td>';
        $out .= '</tr>';
        $out .= '<tr>';
        $out .= '<td align="center" class="v" valign="center">';
        if (!is_null($f_name))
          $out .= '<img src="http://hostname.domain_name/mydirectory/'.$f_name.'">';
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
  }

  // Manage file upload and return file as string.
  function process_uploaded_file()
  {
    // Declare a variable for file contents.
    $contents = "";

    $demodir = "C:\\Program Files\\Apache Group\\Apache2\\htdocs\\";

    // Define the upload file name for Windows or Linux.
    if (ereg("Win32",$_SERVER["SERVER_SOFTWARE"]))
      $upload_file = $demodir."\\photo\\".$_FILES['userfile']['name'];
    else
      $upload_file = getcwd()."/temp/".$_FILES['userfile']['name'];

    // Check for and move uploaded file.
    if (is_uploaded_file($_FILES['userfile']['tmp_name']))
      move_uploaded_file($_FILES['userfile']['tmp_name'],$upload_file);

    return $filename = basename($upload_file);

  }

  // Strip special characters, like carriage or line returns and tabs.
  function strip_special_characters($str)
  {
    $out = "";
    for ($i = 0;$i < strlen($str);$i++)
      if ((ord($str[$i]) != 9) && (ord($str[$i]) != 10) &&
          (ord($str[$i]) != 13))
        $out .= $str[$i];

    // Return pre-parsed SQL statement.
    return $out;
  }
?>
</body>
</html>