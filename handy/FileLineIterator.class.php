<?php
/**
	usage

	require_once('FileLineIterator.class.php');

	$fobj = new FileLineIterator('test.tdt');

	print $fobj->getLine();
	print "----\n";

	foreach ($fobj as $num => $line) {
		print("$num:$line");
	}

**/

class FileLineIterator implements Iterator
{
	protected $fh;    ///! (resource) file resource handle
	protected $limit; ///! (integer)  max number of bytes to read per line
	protected $line;  ///! (string)   line
	protected $key;   ///! (integer)  line number
	protected $valid; ///! (boolean)  line data valid/available

	public function __construct($f, $l = 1024)
	{
		$this->fh = fopen($f, 'r');
		$this->limit = $l;
		ini_set('auto_detect_line_endings', true);
	}

	public function __destruct()
	{
		return fclose($this->fh);
	}

	public function rewind()
	{
		rewind($this->fh);
		$this->key = 0;
		$this->valid = $this->loadLine();
	}

	public function valid()
	{
		return $this->valid;
	}

	public function current()
	{
		return $this->line;
	}

	public function key()
	{
		return $this->key;
	}

	public function next()
	{
		$this->key++;
		$this->valid = $this->loadLine();
	}

	///! return one line safely, and increment line pointer
	public function getLine()
	{
		$this->next();
		return $this->line;
	}

	protected function loadLine()
	{
		return ($this->line = fgets($this->fh)) !== false;
	}
}

/**
	usage

	// line-endings must be unix or dos
	$fobj = new FileTabIterator('test.tdt');
	$fobj->setKeys($fobj->getLine());	// data file's 1st line contains keys
	vprintf("%s\t%s\t%s\n", $fobj->getKeys());
	print "-----\t-----\t-----\n";
	foreach ($fobj as $row) {
		printf("%s\t%s\t%s\n", $row['col_a'], $row['col_b'], $row['col_c']);
	}

**/
class FileCsvIterator extends FileLineIterator
{
	protected $delim; ///! (string) one-character field delimiter
	protected $quote; ///! (string) one-character field enclosure character
	protected $keys;  ///! (array)  keynames/hashnames of each row array item
	protected $line;  ///! (array)  line (it's a string in parent)

	public function __construct($f, $d = ',', $q = '"', $l = 1024)
	{
		$this->fh = fopen($f, 'r');
		$this->delim = $d;
		$this->quote = $q;
		$this->limit = $l;
		$this->keys = array();
	}

	protected function loadLine()
	{
		return (
			$this->line = fgetcsv($this->fh, $this->limit, $this->delim, $this->quote)
		) !== false;
	}

	public function setKeys($a)
	{
		$this->keys = (array) $a;
	}

	public function getKeys()
	{
		return (array) $this->keys;
	}

	public function current()
	{
		if (sizeof($this->keys)) {
			return array_combine($this->keys, $this->line);
		}
		return $this->line;
	}
}

/**
	usage same as FileCsvIterator, except assumes tab delimiter
**/
class FileTabIterator extends FileCsvIterator
{
	public function __construct($f, $l = 1024)
	{
		parent::__construct($f, $d = "\t", $q = '"', $l);
	}
}
?>