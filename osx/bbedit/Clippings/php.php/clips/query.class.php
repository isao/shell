<?php
class query
{
	var $dbq;
	var $dbk;

	function query ($sql, $dbk)
	{
		$this->dbk = $dbk;
		$this->dbq = mysql_query ($sql, $this->dbk);
		$this->errorif (!$this->dbq, "query failed for $sql", __FILE__, __CLASS__, __FUNCTION__);
	}

	function row ()
	{
		$row = mysql_fetch_assoc ($this->dbq, $this->dbk);
		$this->errorif (!$this->dbq, "fetch failed for $sql", __FILE__, __CLASS__, __FUNCTION__);
		return $row;
	}

}

?>