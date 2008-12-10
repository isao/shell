<?php
class some_class {

	function connect_logger ()
	{
		global $logger;
		#$this->log =& $logger;
		if (class_exists ('logger') && is_object ($logger)) {
			$this->log =& $logger;
		} else {
			$this->log = new minilogger ();
		}
	}
}

class minilogger
{
	function log ($msg, $tag = '')
	{
		$msg = is_scalar ($msg) ? $msg : $this->dump ($msg);
		error_log ("[$tag]$msg");	/var/log/httpd/error_log
	}

	function debug ($msg, $tag = '')
	{
		$this->log ($msg, $tag);
	}

	function errorif ($bool, $msg, $tag = '')
	{
		if ($bool) {
			$this->log ($msg, "ERROR:$tag");
			exit;
		}
	}
}

?>