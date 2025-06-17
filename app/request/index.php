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

$settingsAdmin = selectDB("settings","`id` = '1'");

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
}elseif( isset($_GET["action"]) && $_GET["action"] == "compare" ){
	require("compare.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "top" ){
	require("top.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "quizCategories" ){
	require("quizCategories.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "quizQestions" ){
	require("quizQestions.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "rooms" ){
	require("rooms.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "appFire" ){
	require("appFire.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "submitRoom" ){
	require("submitRoom.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "version" ){
	require("version.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "firebaseToken" ){
	require("firebaseToken.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "firebaseTopic" ){
	require("firebaseTopic.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "firebaseNotification" ){
	require("firebaseNotification.php");
}elseif( isset($_GET["action"]) && $_GET["action"] == "publicLeagues" ){
	require("publicLeagues.php");
}else{
	$error = array("msg"=>"please select the correct action");
	echo outputError($error);die();
}
?>