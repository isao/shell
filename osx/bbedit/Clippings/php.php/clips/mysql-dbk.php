<?php
define ('DBK', mysql_connect ('harpy', 'mysql', 'pavCAN7'));
mysql_select_db ('build_relations', DBK)
	or die ('error: could not select database '. mysql_error());
?>