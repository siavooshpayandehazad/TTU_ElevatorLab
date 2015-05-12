<?php
error_reporting(E_ALL);
ini_set('display_errors',1);

$target_dir = "bit/";
$target_filename = "upload.bit";
$target_path = $target_dir . $target_filename;
$file_type = pathinfo($target_file, PATHINFO_EXTENSION);

$cookie_res = "upload_result";
$cookie_msg = "err_message";

//header('Content-Type: text/plain; charset=utf-8');

try {

	// check for attack
	if (
	!isset($_FILES['userfile']['error']) ||
	is_array($_FILES['userfile']['error'])
	) {
		throw new RuntimeException('Invalid parameters.');
	}

	// Check for errors
	switch ($_FILES['userfile']['error']) {
	case UPLOAD_ERR_OK:
	    break;
	case UPLOAD_ERR_NO_FILE:
	    throw new RuntimeException('No file sent.');
	case UPLOAD_ERR_INI_SIZE:
	case UPLOAD_ERR_FORM_SIZE:
	    throw new RuntimeException('Exceeded filesize limit.');
	default:
	    throw new RuntimeException('Unknown errors.');
	}

	// check filesize and make an assumption on the file being a bit file
	if ($_FILES['userfile']['size'] < 149605 || $_FILES['userfile']['size'] > 149608 ) {
		throw new RuntimeException('Not a valid bit file');
	}

	if(!move_uploaded_file($_FILES['userfile']['tmp_name'], $target_path)) {
		throw new RuntimeException('Error occurred while uploading the file.');
	} else {
		//success - let's set a cookie, so main page would know also
		setcookie($cookie_res, 0, time()+2, "/");
	}

} catch (RuntimeException $e) {
	echo $e->getMessage();
	setcookie($cookie_res, 1, time()+2, "/");
	setcookie($cookie_msg, $e->getMessage(), time()+60, "/");
}
$url = "http://$_SERVER[HTTP_HOST]";
header('Location:'.$url);
?>
