<?php

if( !isset($_POST["itemId"]) || empty($_POST["itemId"]) ){
	$response["msg"] = "Please enter item id";
	echo outputError($response);die();
}elseif( !isset($_POST["userId"]) || empty($_POST["userId"]) ){
	$response["msg"] = "Please enter user id";
	echo outputError($response);die();
}elseif( !isset($_POST["addressId"]) || empty($_POST["addressId"]) ){
	$response["msg"] = "Please enter address id";
	echo outputError($response);die();
}elseif( $user = selectDB("user","`status` = '0' AND `id` = '{$_POST["userId"]}'") && $item = selectDB("products","`status` = '0' AND `id` = '{$_POST["itemId"]}'") && $address = selectDB("addresses","`status` = '0' AND `id` = '{$_POST["addressId"]}'") ){
	$user = selectDB("user","`status` = '0' AND `id` = '{$_POST["userId"]}'");
	$item = selectDB("products","`status` = '0' AND `id` = '{$_POST["itemId"]}'");
	$_POST["coins"] = $item[0]["coins"];
	$_POST["remainingCoins"] = $user[0]["coins"] - $item[0]["coins"];
	if( insertDB("orders",$_POST) ){
		$order = selectDataDB("`id`","orders","`itemId` = '{$_POST["itemId"]}' AND `userId` = '{$_POST["userId"]}' AND `addressId` = '{$_POST["addressId"]}'");
		$coins = $user[0]["coins"] - $item[0]["coins"];
		updateDB("user",array("coins"=>$coins),"`id` = '{$_POST["userId"]}'");
		$response["order"] = $order;
		$response["msg"] = "Order has been submitted.";
		echo outputData($response);die();
	}else{
		$response["msg"] = "Could not make order, please try again.";
		echo outputError($response);die();
	}
}else{
	$response["msg"] = "Please check inputed data, something is wrong";
	echo outputError($response);die();
}

?>