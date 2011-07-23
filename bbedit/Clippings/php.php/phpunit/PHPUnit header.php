<?php
set_include_path(
	dirname(dirname(__FILE__)).PATH_SEPARATOR.
	get_include_path()
);

require_once 'PHPUnit/Framework.php';
require_once '#selstart##BASENAME##selend#.php';


class #BASENAME# extends PHPUnit_Framework_TestCase
{
	
}