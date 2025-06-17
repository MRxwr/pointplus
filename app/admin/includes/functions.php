<?php
/*
 * PointPlus - Custom Functions File
 * 
 * This file contains unique functions specific to the PointPlus application.
 * Common database and utility functions have been moved to the functions/ subdirectory
 * to avoid duplication and improve code organization.
 * 
 * Remaining functions:
 * - randomCode() - Generate random codes for subLeagues
 * - randomCodeQuiz() - Generate random codes for quiz rooms
 * - popupMsg() - Handle multilingual popup messages
 * - selectDBUpdated() - Updated version of selectDB with prepared statements
 * - selectDataDB() - Select specific data fields from database
 * - updatePredictionDB() - Update predictions with numeric values
 * - updateUserDB() - Update user data with string values
 * - payment() - Handle payment API integration
 * - checkPayment() - Check payment status
 * - newOrderNoti() - Send new order notifications
 * - updateOrderStatusNotification() - Send order status update notifications
 * - getTop30() - Get top 30 users for a date range
 * - submitCalculatePredictions() - Calculate and update prediction points
 * 
 * For database operations (selectDB, insertDB, updateDB, deleteDB, etc.),
 * see: includes/functions/sql.php
 * 
 * For general utilities (direction, outputData, array_sort, etc.),
 * see: includes/functions/general.php
 */

// Include all function files from the functions subdirectory
require_once(__DIR__ . '/functions/sql.php');
require_once(__DIR__ . '/functions/general.php');
require_once(__DIR__ . '/functions/system.php');
require_once(__DIR__ . '/functions/payment.php');
require_once(__DIR__ . '/functions/cart.php');
require_once(__DIR__ . '/functions/currency.php');
require_once(__DIR__ . '/functions/notification.php');
require_once(__DIR__ . '/functions/products.php');
require_once(__DIR__ . '/functions/svg.php');
require_once(__DIR__ . '/functions/vouchers.php');


function randomCode(){
	jump:
	$permitted_chars = '0123456789abcdefghijklmnopqrstuvwxyz';
	$code = substr(str_shuffle($permitted_chars), 0, 8);
	if ( selectDB("subLeagues","`code` LIKE '{$code}'") ){
		goto jump;
	}else{
		return $code;
	}
}

function randomCodeQuiz(){
	jump:
	$permitted_chars = '0123456789abcdefghijklmnopqrstuvwxyz';
	$code = substr(str_shuffle($permitted_chars), 0, 8);
	if ( selectDB("quiz_room","`code` LIKE '{$code}'") ){
		goto jump;
	}else{
		return $code;
	}
}





function popupMsg($lang,$valEn,$valAr){
	if ( $lang == "ar" ){
		$response = $valAr;
	}else{
		$response = $valEn;
	}
	return $response;
}

function selectDBUpdated($table, $where){
    GLOBAL $dbconnect;
    $check = [';', '"'];
    $where = str_replace($check, "", $where);
    $sql = "SELECT * FROM `{$table}`";
    if (!empty($where)) {
        $sql .= " WHERE {$where}";
    }
    if ($stmt = $dbconnect->prepare($sql)) {
        $stmt->execute();
        $result = $stmt->get_result();
        $array = array();
        while ($row = $result->fetch_assoc()) {
            $array[] = $row;
        }
        if (isset($array) && is_array($array)) {
            return $array;
        } else {
            return 0;
        }
    } else {
        $error = array("msg" => "select table error");
        return outputError($error);
    }
}



function selectDataDB($select, $table, $where){
	GLOBAL $dbconnect;
	GLOBAL $date;
	$check = [';','"'];
	$where = str_replace($check,"",$where);
	$sql = "SELECT {$select} FROM `{$table}`";
	if ( !empty($where) ){
		$sql .= " WHERE " . $where;
	}
	if($result = $dbconnect->query($sql)){
		while($row = $result->fetch_assoc() ){
			$array[] = $row;
		}
		if ( isset($array) AND is_array($array) ){
			return $array;
		}else{
			return 0;
		}
	}else{
		$error = array("msg"=>"select table error");
		return outputError($error);
	}
}







function updatePredictionDB($table ,$data, $where){
	GLOBAL $dbconnect;
	GLOBAL $date;
	$check = [';','"'];
	$data = str_replace($check,"",$data);
	$where = str_replace($check,"",$where);
	$keys = array_keys($data);
	$sql = "UPDATE `".$table."` SET ";
	for($i = 0 ; $i < sizeof($data) ; $i++ ){
		$sql .= "`".$keys[$i]."` = {$data[$keys[$i]]}";
		if ( isset($keys[$i+1]) ){
			$sql .= ", ";
		}
	}		
	$sql .= " WHERE " . $where;
	if($dbconnect->query($sql)){
		return 1;
	}else{
		$error = array("msg"=>"update table error");
		return outputError($error);
	}
}

function updateUserDB($table ,$data, $where){
	GLOBAL $dbconnect;
	GLOBAL $date;
	$check = [';','"'];
	$data = str_replace($check,"",$data);
	$where = str_replace($check,"",$where);
	$keys = array_keys($data);
	$sql = "UPDATE `".$table."` SET ";
	for($i = 0 ; $i < sizeof($data) ; $i++ ){
		$sql .= "`".$keys[$i]."` = '{$data[$keys[$i]]}'";
		if ( isset($keys[$i+1]) ){
			$sql .= ", ";
		}
	}		
	$sql .= " WHERE " . $where;
	if($dbconnect->query($sql)){
		return 1;
	}else{
		$error = array("msg"=>"update table error");
		return outputError($error);
	}
}










function newOrderNoti($orderId){
	$server_key = 'AAAAxivBwO8:APA91bGTS7WajBuXnAJeDKxD2cd4s5ZlwzJ_OhA887ofazTNVozq5aRydpI0zXJnMvvl4JSOYA934Aa50aBjnM3D56K2yyGOW3TpyI0Oh-xrUFCrYm8WTEYQL3YX2C0GI9YZO-PtqxqO'; 
	$url = 'https://fcm.googleapis.com/fcm/send';
	$headers = array(
		'Content-Type:application/json',
		'Authorization:key='.$server_key
	);
	$order = selectDB("orders","`orderId` = '{$orderId}'");
	$vendor = selectDB("vendors","`id` = '{$order[0]["vendorId"]}'");
		$to = $vendor[0]["deviceToken"];
		$title = "New order - {$orderId}";
		$body = "You have recevied a new order.";
		$json_data = array(
			"to" => "{$to}",
			"notification" => array(
				"body" => "{$body}",
				"text" => "{$body}",
				"title" => "{$title}",
				"sound" => "default",
				"content_available" => "true",
				"priority" => "high",
				"badge" => "1"
			),
			"data" => array(
				"body" => "{$body}",
				"title" => "{$title}",
				"text" => "{$body}",
				"sound" => "default",
				"content_available" => "true",
				"priority" => "high",
				"badge" => "1"
			)
		);
		$data = json_encode($json_data);
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_POST, true);
		curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
		echo $response = curl_exec($ch);
		curl_close($ch);
}

function updateOrderStatusNotification($orderId, $status){
	$server_key = 'AAAAxivBwO8:APA91bGTS7WajBuXnAJeDKxD2cd4s5ZlwzJ_OhA887ofazTNVozq5aRydpI0zXJnMvvl4JSOYA934Aa50aBjnM3D56K2yyGOW3TpyI0Oh-xrUFCrYm8WTEYQL3YX2C0GI9YZO-PtqxqO'; 
	$url = 'https://fcm.googleapis.com/fcm/send';
	$headers = array(
		'Content-Type:application/json',
		'Authorization:key='.$server_key
	);
	$order = selectDB("orders","`orderId` = '{$orderId}'");
	$customers = selectDB("customers","`customerId` = '{$order[0]["customerId"]}'");
		$to = $customers[0]["firebase"];
		$title = "Boothaat Order status";
		if( $status == 2 ){
			$body = "You order #{$orderId} is being prepared.";
		}elseif( $status == 3 ){
			$body = "You order #{$orderId} is our for delivery.";
		}elseif( $status == 4 ){
			$body = "You order #{$orderId} is delivered.";
		}elseif( $status == 5 ){
			$body = "You order #{$orderId} is cancelled.";
		}elseif( $status == 6 ){
			$body = "You order #{$orderId} is refunded.";
		}else{
			$body = "You order #{$orderId} status being updated.";
		}
		$json_data = array(
			"to" => "{$to}",
			"notification" => array(
				"body" => "{$body}",
				"text" => "{$body}",
				"title" => "{$title}",
				"sound" => "default",
				"content_available" => "true",
				"priority" => "high",
				"badge" => "1"
			),
			"data" => array(
				"body" => "{$body}",
				"title" => "{$title}",
				"text" => "{$body}",
				"sound" => "default",
				"content_available" => "true",
				"priority" => "high",
				"badge" => "1"
			)
		);
		$data = json_encode($json_data);
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_POST, true);
		curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
		$response = curl_exec($ch);
		curl_close($ch);
}

function getTop30($startDate, $endDate){
	GLOBAL $dbconnect;
	$sql = "SELECT p.userId, u.username, SUM(p.points) as total_points
			FROM `predictions` as p 
			JOIN `user` as u 
			ON p.userId = u.id 
			WHERE p.date BETWEEN '{$startDate}' AND '{$endDate}' 
			AND u.status = '0'
			GROUP BY p.userId 
			ORDER BY `total_points` DESC 
			LIMIT 50;
			";
	if($result = $dbconnect->query($sql)){
		while($row = $result->fetch_assoc() ){
			$array[] = $row;
		}
		if ( isset($array) AND is_array($array) ){
			return $array;
		}else{
			return 0;
		}
	}else{
		$error = array("msg"=>"could not get the top 50 for this period");
		return outputError($error);
	}
}

function getPublicLeagueTopUsers($publicLeagueId, $startDate = null, $endDate = null, $limit = 20, $offset = 0){
	GLOBAL $dbconnect;
	
	// Build the date condition if dates are provided
	$dateCondition = "";
	if($startDate && $endDate) {
		$dateCondition = "AND p.date BETWEEN '{$startDate}' AND '{$endDate}'";
	}
	
	$sql = "SELECT 
				jpl.userId, 
				u.username, 
				u.points, 
				u.rank, 
				u.pRank,
				COALESCE(SUM(p.points), 0) as period_points
			FROM joinedPublicLeagues jpl
			JOIN user u ON jpl.userId = u.id
			LEFT JOIN predictions p ON u.id = p.userId {$dateCondition}
			WHERE jpl.publicLeagueId = '{$publicLeagueId}' 
			AND u.status = '0'
			GROUP BY jpl.userId, u.username, u.points, u.rank, u.pRank
			ORDER BY u.rank ASC 
			LIMIT {$limit} OFFSET {$offset}";
			
	if($result = $dbconnect->query($sql)){
		while($row = $result->fetch_assoc() ){
			$array[] = $row;
		}
		if ( isset($array) AND is_array($array) ){
			return $array;
		}else{
			return 0;
		}
	}else{
		$error = array("msg"=>"could not get the top users for this public league");
		return outputError($error);
	}
}

function getPublicLeagueUsersCount($publicLeagueId){
	GLOBAL $dbconnect;
	
	$sql = "SELECT COUNT(*) as total
			FROM joinedPublicLeagues jpl
			JOIN user u ON jpl.userId = u.id
			WHERE jpl.publicLeagueId = '{$publicLeagueId}' 
			AND u.status = '0'";
			
	if($result = $dbconnect->query($sql)){
		$row = $result->fetch_assoc();
		return (int)$row['total'];
	}else{
		return 0;
	}
}

// ...existing code...