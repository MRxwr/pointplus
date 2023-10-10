<?php
if ( !isset($_COOKIE["createSystem"]) || ( isset( $_GET["page"] ) && $_GET["page"] == "logout" ) || empty($_COOKIE["createSystem"]) ){
	setcookie("createSystem", "", time() - 3600, '/');
	header('LOCATION: pages/logout.php');die();
}else{
	if ( $user = selectDB("user"," `cookie` LIKE '{$_COOKIE["createSystem"]}'") ){
		$userId = $user[0]["id"];
		$username = $user[0]["username"];
		$userType = $user[0]["type"];
	}else{
		setcookie("createSystem", "", time() - 3600, '/');
		header('LOCATION: pages/logout.php');die();
	}
}
?>