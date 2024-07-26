<?php
if( !isset($_POST["name"]) || empty($_POST["name"]) ){
	$response["msg"] = "Please enter name";
	echo outputError($response);die();
}elseif( !isset($_POST["userId"]) || empty($_POST["userId"]) ){
	$response["msg"] = "Please enter user id";
	echo outputError($response);die();
}elseif( !isset($_POST["email"]) || empty($_POST["email"]) ){
	$response["msg"] = "Please enter email";
	echo outputError($response);die();
}elseif( !isset($_POST["mobile"]) || empty($_POST["mobile"]) ){
	$response["msg"] = "Please enter mobile";
	echo outputError($response);die();
}elseif( !isset($_POST["country"]) || empty($_POST["country"]) ){
	$response["msg"] = "Please enter country";
	echo outputError($response);die();
}elseif( !isset($_POST["address1"]) || empty($_POST["address1"]) ){
	$response["msg"] = "Please enter address 1";
	echo outputError($response);die();
}else{
	$check = ["'",'"',";"];
	$_POST = str_replace($check,"",$_POST);
	if( insertDB("addresses",$_POST) ){
		$address = selectDataDB("`id`","addresses","`name` = '{$_POST["name"]}' AND `userId` = '{$_POST["userId"]}' AND `email` = '{$_POST["email"]}' AND `mobile` = '{$_POST["mobile"]}' AND `country` = '{$_POST["country"]}' AND `address1` = '{$_POST["address1"]}' ORDER BY `id` DESC LIMIT 1");
		$response["address"] = $address[0];
		$response["msg"] = "address has been added successfully.";
		echo outputData($response);die();
	}else{
		$response["msg"] = "Could not add address, please try again.";
		echo outputError($response);die();
	}
}

?>