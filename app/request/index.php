<?php
header("Content-Type: application/json");
require_once('../admin/includes/config.php');
require_once('../admin/includes/functions.php');

if( isset($_GET["page"]) && $_GET["page"] == "success" ){
	die();
}elseif( isset($_GET["page"]) && $_GET["page"] == "failure" ){
	die();
}

if ( isset(getallheaders()["pointsheader"]) ){
	$headerAPI =  getallheaders()["pointsheader"];
}else{
	$error = array("msg"=>"Please set headres");
	echo outputError($error);die();
}

if ( $headerAPI != "pointsCreateKW" ){
	$error = array("msg"=>"headers value is wrong");
	echo outputError($error);die();
}

$unsetData = ["userId","status","date", "username", "password", "cookie", "name", "email", "forgetPassword"];

if( isset($_GET["action"]) && $_GET["action"] == "home" ){
	require("home.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "user" ){
	require("user.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "league" ){
	require("league.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "settings" ){
	require("settings.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "items" ){
	require("item.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "order" ){
	require("order.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "address" ){
	require("address.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "teams" ){
	require("teams.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "predictions" ){
	require("predictions.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "faq" ){
	require("faq.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "complain" ){
	require("complain.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "notifications" ){
	require("notifications.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "coins" ){
	require("coins.php");
}else{
	$error = array("msg"=>"please select the correct action");
	echo outputError($error);die();
}
?>