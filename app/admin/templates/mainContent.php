<?php
if ( !isset($_GET["page"]) ){
	require_once('pages/home.php');
}elseif( $_GET["page"] == "home" ){
	require_once('pages/home.php');
}elseif( $_GET["page"] == "banners" ){
	require_once('pages/banners.php');
}elseif( $_GET["page"] == "leagues" ){
	require_once('pages/leagues.php');
}elseif( $_GET["page"] == "userLeagues" ){
	require_once('pages/userLeagues.php');
}elseif( $_GET["page"] == "teams" ){
	require_once('pages/teams.php');
}elseif( $_GET["page"] == "matches" ){
	require_once('pages/matches.php');
}elseif( $_GET["page"] == "predictions" ){
	require_once('pages/predictions.php');
}elseif( $_GET["page"] == "products" ){
	require_once('pages/products.php');
}elseif( $_GET["page"] == "employees" ){
	require_once('pages/employees.php');
}elseif( $_GET["page"] == "users" ){
	require_once('pages/users.php');
}elseif( $_GET["page"] == "notification" ){
	require_once('pages/notification.php');
}elseif( $_GET["page"] == "faq" ){
	require_once('pages/faq.php');
}elseif( $_GET["page"] == "complains" ){
	require_once('pages/complains.php');
}elseif( $_GET["page"] == "settings" ){
	require_once('pages/settings.php');
}elseif( $_GET["page"] == "addresses" ){
	require_once('pages/addresses.php');
}elseif( $_GET["page"] == "orders" ){
	require_once('pages/orders.php');
}elseif( $_GET["page"] == "orderView" ){
	require_once('pages/orderView.php');
}elseif( $_GET["page"] == "logout" ){
	require_once('pages/logout.php');
}elseif( $_GET["page"] == "adminReports" ){
	require_once('pages/adminReports.php');
}elseif( $_GET["page"] == "winners" ){
	require_once('pages/winners.php');
}elseif( $_GET["page"] == "tops" ){
	require_once('pages/tops.php');
}else{
	require_once('pages/home.php');
}
?>