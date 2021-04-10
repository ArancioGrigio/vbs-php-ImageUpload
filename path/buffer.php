<?php
	$ip = $_SERVER['REMOTE_ADDR'];
	$str = str_replace(" ", "+", $_GET['piece']);
	$myfile = fopen($ip.".txt", "a+") or die("Unable to open file!");
	fwrite($myfile, $str);
	fclose($myfile);
?> 