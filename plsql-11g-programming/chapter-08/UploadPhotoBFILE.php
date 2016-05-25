<html>
<! UploadItemBFILE.php                                         >
<! Chapter 8, Oracle Database 11g PL/SQL Programming          >
<! by Michael McLaughlin                                      >
<!                                                            >
<! This script demonstrates uploading, moving an uploaded     >
<! file, storing the content in an Oracle CLOB column using a >
<! stored PL/SQL procedure, and then accesses the stored      >
<! content from the database and renders the page.            >
<head>
<title>
  Chapter 8 : UploadItemBFILE.php
</title>
<style>
.e {background-color: #ccccff; font-weight: bold; color: #000000;}
.v {background-color: #cccccc; color: #000000;}
</style>
</head>
<body>
<?php
  // Displayed moved file in web page.
  $item_photo = process_uploaded_file();

  // Return successful attempt to connect to the database.
  if ($c = @oci_connect("plsql","plsql","orcl"))
  {
    // Declare input variables.
    (isset($_POST['id']))    ? $id = (int) $_POST['id'] : $id = 1021;
    (isset($_POST['title'])) ? $title = $_POST['title'] : $title = "Harry #1";

    // Declare a PL/SQL execution command.
    $stmt = "UPDATE item
             SET    item_photo = BFILENAME('IMAGES',:item_photo)
             WHERE  item_id = :item_id";

    // Strip special characters to avoid ORA-06550 and PLS-00103 errors.
    $stmt = strip_special_characters($stmt);

    // Parse a query through the connection.
    $s = oci_parse($c,$stmt);

    // Bind PHP variables to the OCI types.
    oci_bind_by_name($s,':item_id',$id);
    oci_bind_by_name($s,':item_photo',$item_photo);

    // Execute the PL/SQL statement.
    if (oci_execute($s,OCI_DEFAULT))
    {
      oci_commit($c);
      query_insert($id,$title);
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

  // Query results after an insert.
  function query_insert($id,$title)
  {
    // Return successful attempt to connect to the database.
    if ($c = @oci_new_connect("plsql","plsql","orcl"))
    {
      // Declare a SQL SELECT statement returning a CLOB.
      $stmt = "SELECT   item_desc
               FROM     item
               WHERE    item_id = :id";

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
              {
                $data = oci_result($s,$i)->read($size);
              }
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

        // Free statement resources.
        oci_free_statement($s);

        // Format HTML table to display BLOB photo and CLOB description.
        $out = '<table border="1" cellpadding="5" cellspacing="0">';
        $out .= '<tr>';
        $out .= '<td align="center" class="e">'.$title.'</td>';
        $out .= '</tr>';
        $out .= '<tr><td class="v">';
        $out .= '<div>';
        $out .= '<div style="margin-right:5px;float:left">';
        $out .= '<img src="ReadCanonicalFileToImage.php?id='.$id.'">';
        $out .= '</div>';
        $out .= '<div style="position=relative;">'.$data.'</div>';
        $out .= '</div>';
        $out .= '</td></tr>';
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
      $upload_file = getcwd()."\\images\\".$_FILES['userfile']['name'];
    else
      $upload_file = getcwd()."/images/".$_FILES['userfile']['name'];

    // Check for and move uploaded file.
    if (is_uploaded_file($_FILES['userfile']['tmp_name']))
      move_uploaded_file($_FILES['userfile']['tmp_name'],$upload_file);

    // Return file content as string.
    return $_FILES['userfile']['name'];
  }

  // Strip special characters, like carriage or line returns and tabs.
  function backquote_apostrophe($str)
  {
    $out = "";
    for ($i = 0;$i < strlen($str);$i++)
      if (ord($str[$i]) != 39)
        $out .= $str[$i];
      else
        $out .= "'".$str[$i];
    // Return pre-parsed SQL statement.
    return $out;
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