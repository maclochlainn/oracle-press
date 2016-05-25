<html>
<! UploadBioSQL.php                                           >
<! Appendix C, Oracle Database 11g PL/SQL Programming         >
<! by Michael McLaughlin                                      >
<!                                                            >
<! This script demonstrates uploading, moving an uploaded     >
<! file, storing the content in an Oracle CLOB column using a >
<! SQL UPDATE statement, and then accesses the stored         >
<! content from the database and renders the page.            >
<head>
<title>
  Appendix C : UploadBioSQL.php
</title>
<style>
.e {background-color: #ccccff; font-weight: bold; color: #000000;}
.v {background-color: #cccccc; color: #000000;}
</style>
</head>
<body>
<?php

  // Displayed moved file in web page.
  $biography = process_uploaded_file();

  // Return successful attempt to connect to the database.
  if ($c = @oci_connect("php","php","xe"))
  {
    // Declare input variables.
    (isset($_POST['id'])) ? $id = (int) $_POST['id'] : $id = 1;
    (isset($_POST['name'])) ? $name = $_POST['name'] : $name = "Washington";

    // Declare a PL/SQL execution command.
    $stmt = "UPDATE    president
             SET       biography = empty_clob()
             WHERE     president_id = :id
             RETURNING biography
             INTO      :descriptor";

    // Strip special characters to avoid ORA-06550 and PLS-00103 errors.
    $stmt = strip_special_characters($stmt);

    // Parse a query through the connection.
    $s = oci_parse($c,$stmt);

    // Define a descriptor for a CLOB.
    $rlob = oci_new_descriptor($c,OCI_D_LOB);

    // Define a variable name to map to CLOB descriptor.
    oci_define_by_name($s,':descriptor',$rlob,SQLT_CLOB);

    // Bind PHP variables to the OCI types.
    oci_bind_by_name($s,':id',$id);
    oci_bind_by_name($s,':descriptor',$rlob,-1,SQLT_CLOB);

    // Execute the PL/SQL statement.
    if (oci_execute($s,OCI_DEFAULT))
    {
       $rlob->save($biography);
       oci_commit($c);
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

  // Query the updated record.
  function query_insert($id,$name)
  {
    // Return successful attempt to connect to the database.
    if ($c = @oci_new_connect("php","php","xe"))
    {
      // Declare a SQL SELECT statement returning a CLOB.
      $stmt = "SELECT   biography
               FROM     president
               WHERE    president_id = :id";

      // Parse a query through the connection.
      $s = oci_parse($c,$stmt);

      // Bind PHP variables to the OCI types.
      oci_bind_by_name($s,':id',$id);

      // Execute the PL/SQL statement.
      if (oci_execute($s))
      {
        // Return a LOB descriptor as the value.
        while (oci_fetch($s))
        {
          for ($i = 1;$i <= oci_num_fields($s);$i++)
            if (is_object(oci_result($s,$i)))
            {
              if ($size = oci_result($s,$i)->size())
                $data = oci_result($s,$i)->read($size);
              else
                $data = "&nbsp;";
            }
            else
            {
              if (oci_field_is_null($s,$i))
                $data = "&nbsp;";
              else
                $data = oci_result($s,$i);
            }
        } // End of the while(oci_fetch($s)) loop.

        // Format HTML table to display biography.
        $out = '<table border="1" cellpadding="3" cellspacing="0">';
        $out .= '<tr>';
        $out .= '<td align="center" class="e">Biography of '.$name.'</td>';
        $out .= '</tr>';
        $out .= '<tr>';
        $out .= '<td class="v">'.$data.'</td>';
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

    // Define the upload file name for Windows or Linux.
    if (ereg("Win32",$_SERVER["SERVER_SOFTWARE"]))
      $upload_file = getcwd()."\\temp\\".$_FILES['userfile']['name'];
    else
      $upload_file = getcwd()."/temp/".$_FILES['userfile']['name'];

    // Check for and move uploaded file.
    if (is_uploaded_file($_FILES['userfile']['tmp_name']))
      move_uploaded_file($_FILES['userfile']['tmp_name'],$upload_file);

    // Open a file handle and suppress an error for a missing file.
    if ($fp = @fopen($upload_file,"r"))
    {
      // Read until the end-of-file marker.
      while (!feof($fp))
        $contents .= fgetc($fp);

      // Close an open file handle.
      fclose($fp);
    }

    // Return file content as string.
    return $contents;
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