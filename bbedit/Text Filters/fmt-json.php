#!/usr/bin/env php
<?php
print json_indent(file_get_contents('php://stdin')).PHP_EOL;

/**
 * pretty print JSON string
 * based on http://php.net/manual/en/function.json-encode.php#92539
 * by damon1977@gmail.com
 */
function json_indent($json) {
	$json = json_encode(json_decode($json));//remove formatting hack
	$tabcount = 0;
	$result = '';
	$inquote = false;
	$ignorenext = false;
	$tab = "  ";

	for($i = 0; $i < strlen($json); $i++) {
		$char = $json[$i];
		if($ignorenext) {
			$result .= $char;
			$ignorenext = false;
		} else {
			switch($char) {
				case '{':
				case '[':
					$tabcount++;
					$result .= $char.PHP_EOL.str_repeat($tab, $tabcount);
					break;
				case '}':
				case ']':
					$tabcount--;
					$result = trim($result).PHP_EOL.str_repeat($tab, $tabcount).$char;
					break;
				case ',':
					$result .= $inquote ? $char : $char.PHP_EOL.str_repeat($tab, $tabcount);
					break;
				case '"':
					$inquote = !$inquote;
					$result .= $char;
					break;
				case '\\':
					$ignorenext |= $inquote;
					$result .= $char;
					break;
				default:
					$result .= $char;
			}
		}
	}

	return $result;
}
