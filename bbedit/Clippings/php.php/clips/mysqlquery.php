#indent#
$sql = "#insertion#";
$dbq = mysql_query ($sql, DBK) or die (mysql_error(DBK)."\nsql:".$sql);
if (!$dbk) { die (mysql_error ()); }
