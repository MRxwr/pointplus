<?php
function direction($valEn,$valAr){
	GLOBAL $directionHTML;
	if ( $directionHTML == "rtl" ){
		$response = $valAr;
	}else{
		$response = $valEn;
	}
	return $response;
}

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

function selectDB($table, $where){
	GLOBAL $dbconnect;
	GLOBAL $date;
	$check = [';','"'];
	$where = str_replace($check,"",$where);
	$sql = "SELECT * FROM `".$table."`";
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

function selectJoinDB($table, $joinData, $where){
	GLOBAL $dbconnect;
	GLOBAL $date;
	$check = [';','"'];
	$where = str_replace($check,"",$where);
	$sql = "SELECT ";
	for($i = 0 ; $i < sizeof($joinData["select"]) ; $i++ ){
		$sql .= $joinData["select"][$i];
		if ( $i+1 != sizeof($joinData["select"]) ){
			$sql .= ", ";
		}
	}
	$sql .=" FROM `".$table."` as t ";
	for($i = 0 ; $i < sizeof($joinData["join"]) ; $i++ ){
		$counter = $i+1;
		$sql .= " JOIN `".$joinData["join"][$i]."` as t{$counter} ";
		if( isset($joinData["on"][$i]) && !empty($joinData["on"][$i]) ){
			$sql .= " ON ".$joinData["on"][$i]." ";
		}
	}
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

function deleteDB($table, $where){
	GLOBAL $dbconnect;
	GLOBAL $date;
	$check = [';','"'];
	$where = str_replace($check,"",$where);
	$sql = "DELETE FROM `".$table."`";
	if ( !empty($where) ){
		$sql .= " WHERE " . $where;
	}
	if($result = $dbconnect->query($sql)){
		return 1;
	}else{
		$error = array("msg"=>"delete table error");
		return outputError($error);
	}
}

function insertDB($table, $data){
	GLOBAL $dbconnect;
	GLOBAL $date;
	$check = [';','"'];
	$data = str_replace($check,"",$data);
	$keys = array_keys($data);
	$sql = "INSERT INTO `".$table."`(";
	for($i = 0 ; $i < sizeof($keys) ; $i++ ){
		$sql .= "`".$keys[$i]."`";
		if ( isset($keys[$i+1]) ){
			$sql .= ", ";
		}
	}
	$sql .= ")VALUES(";
	for($i = 0 ; $i < sizeof($data) ; $i++ ){
		$sql .= "'".$data[$keys[$i]]."'";
		if ( isset($keys[$i+1]) ){
			$sql .= ", ";
		}
	}		
	$sql .= ")";
	if($dbconnect->query($sql)){
		return 1;
	}else{
		$error = array("msg"=>"insert table error");
		return outputError($error);
	}
}

function updateDB($table ,$data, $where){
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

function updateItemQuantity($data){
	GLOBAL $dbconnect;
	GLOBAL $date;
	$check = [';','"',"'"];
	$data = str_replace($check,"",$data);
	$sql = "UPDATE `items`
			SET 
			`quantity` = `quantity`-".$data["quantity"]."
			WHERE
			`id` LIKE '".$data["id"]."'
			";
	if($dbconnect->query($sql)){
		return 1;
	}else{
		$error = array("msg"=>"update quantity error");
		return outputError($error);
	}
}

function outputData($data){
	$response["ok"] = true;
	$response["error"] = "0";
	$response["status"] = "successful";
	$response["data"] = $data;
	return json_encode($response);
}

function outputError($data){
	$response["ok"] = false;
	$response["error"] = "1";
	$response["status"] = "Error";
	$response["data"] = $data;
	return json_encode($response);
}

function payment($data){
	$curl = curl_init();
	curl_setopt_array($curl, array(
	  CURLOPT_URL => 'https://createkwservers.com/payapi/api/v2/index.php',
	  CURLOPT_RETURNTRANSFER => true,
	  CURLOPT_ENCODING => '',
	  CURLOPT_MAXREDIRS => 10,
	  CURLOPT_TIMEOUT => 0,
	  CURLOPT_FOLLOWLOCATION => true,
	  CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
	  CURLOPT_CUSTOMREQUEST => 'POST',
	  CURLOPT_POSTFIELDS => json_encode($data),
	));
	$response = curl_exec($curl);
	curl_close($curl);
	$response = json_decode($response,true);
	$array = [
		"url" => $response["data"]["PaymentURL"],
		"id" => $response["data"]["InvoiceId"]
	];
	return $array;
}

function checkPayment($data){
	$curl = curl_init();
	curl_setopt_array($curl, array(
	  CURLOPT_URL => 'https://createkwservers.com/payapi/api/v2/index.php',
	  CURLOPT_RETURNTRANSFER => true,
	  CURLOPT_ENCODING => '',
	  CURLOPT_MAXREDIRS => 10,
	  CURLOPT_TIMEOUT => 0,
	  CURLOPT_FOLLOWLOCATION => true,
	  CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
	  CURLOPT_CUSTOMREQUEST => 'POST',
	  CURLOPT_POSTFIELDS => json_encode($data),
	));
	$response = curl_exec($curl);
	curl_close($curl);
	$response = json_decode($response,true);
	if ( !isset($response["data"]["Data"]["InvoiceStatus"]) ){
		$status = "Failed";
	}else{
		$status = $response["data"]["Data"]["InvoiceStatus"];
	}
	if ( !isset($response["data"]["Data"]["InvoiceId"]) ){
		$id = $data["Key"];
	}else{
		$id = $response["data"]["Data"]["InvoiceId"];
	}
	$array = [
		"status" => $status,
		"id" => $id
	];
	return $array;
}

function array_sort($array, $on, $order){
    $new_array = array();
    $sortable_array = array();
    if(count($array) > 0){
        foreach ($array as $k => $v) {
            if (is_array($v)) {
                foreach ($v as $k2 => $v2) {
                    if ($k2 == $on) {
                        $sortable_array[$k] = $v2;
                    }
                }
            }else{
                $sortable_array[$k] = $v;
            }
        }
        switch($order){
            case SORT_ASC: asort($sortable_array);
            break;
            case SORT_DESC: arsort($sortable_array);
            break;
        }
        foreach ($sortable_array as $k => $v) {
            $new_array[$k] = $array[$k];
        }
    }
    return $new_array;
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
	$sql = "SELECT 
			u.id, 
			u.username,
			SUM(CASE 
					WHEN p.matchOutcome = 1 THEN 5 
					ELSE 0 
				END) AS matchPoints,
			SUM(CASE 
					WHEN p.exactMatch = 1 THEN 5 
					ELSE 0 
				END) AS correctPredictionPoints,
			SUM(CASE WHEN p.x2 = 1 THEN 1 ELSE 0 END) AS total_x2,
			SUM(CASE WHEN p.x3 = 1 THEN 1 ELSE 0 END) AS total_x3,
			SUM(
				(
					CASE 
						WHEN p.matchOutcome = 1 THEN 5 
						ELSE 0 
					END 
					+ 
					CASE 
						WHEN p.exactMatch = 1 THEN 5 
						ELSE 0 
					END
				) * 
				(CASE
					WHEN p.x2 = 1 THEN 2
					WHEN p.x3 = 1 THEN 6
					ELSE 1
				END)
			) AS total_points
		FROM 
			(
				SELECT 
					predictions.userId,
					predictions.x2,
					predictions.x3,
					CASE
						WHEN (predictions.goals1 = predictions.goals2 AND matches.goals1 = matches.goals2) OR
							(predictions.goals1 > predictions.goals2 AND matches.goals1 > matches.goals2) OR
							(predictions.goals1 < predictions.goals2 AND matches.goals1 < matches.goals2) 
						THEN 1 ELSE 0 
					END AS matchOutcome,
					CASE
						WHEN predictions.goals1 = matches.goals1 AND predictions.goals2 = matches.goals2 
						THEN 1 ELSE 0 
					END AS exactMatch
				FROM 
					predictions 
				JOIN 
					matches ON predictions.matchId = matches.id
				WHERE 
					predictions.date BETWEEN '{$startDate}' AND '{$endDate}'
				AND
					predictions.status = '1'
			) p
		JOIN 
			user u ON p.userId = u.id
		GROUP BY 
			u.id
		ORDER BY 
			total_points DESC
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
?>