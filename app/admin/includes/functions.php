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

function selectDB2($select, $table, $where){ 
    GLOBAL $dbconnect;
    $check = [';', '"'];
    $where = str_replace($check, "", $where);
    $sql = "SELECT {$select} FROM `{$table}`";
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

function submitCalculatePredictions($matchId){
	GLOBAL $dbconnect;
	$updateData = array(
		"pRank" => "`rank`"
	);
	$settings = selectDB("settings","`id` = '1'");
	if( updatePredictionDB("user",$updateData,"`id` > '0' ") && updatePredictionDB("joinedLeagues",$updateData,"`id` > '0' ") ){
		if( $matches = selectDB("matches","`id` = '{$matchId}' ") ){
			//update user points
			updatePredictionDB("user",array("pPoints"=>"0"),"`id` != '0'");
			$realResult = [$matches[0]["goals1"],$matches[0]["goals2"]];
			if( $prediction = selectDB("predictions","`matchId` = '{$matches[0]["id"]}' AND `status` = '0'") ){
				for( $y =0; $y < sizeof($prediction); $y++ ){
					$points = 0;
					$predictionResult = [$prediction[$y]["goals1"],$prediction[$y]["goals2"]];
					//check match result
					if( $predictionResult[0] == $realResult[0] && $predictionResult[1] == $realResult[1] ){
						$points = $points + 5;
					}
					//check match winner
					if( $predictionResult[0] > $predictionResult[1] &&  $realResult[0] > $realResult[1] ){
						$points = $points + 5;
					}elseif( $predictionResult[0] < $predictionResult[1] &&  $realResult[0] < $realResult[1] ){
						$points = $points + 5;
					}elseif( $predictionResult[0] == $predictionResult[1] &&  $realResult[0] == $realResult[1] ){
						$points = $points + 5;
					}
					//for super match multiply * 2
					if( $matches[0]["type"] == 1 ){
						$points = $points * 2;
					}
					//x2 
					if( $prediction[$y]["x2"] == 1 ){
						$points = $points * $settings[0]["x2"];
						updatePredictionDB("user",array("x2"=>1),"`id` = '{$prediction[$y]["userId"]}'");
					}
					if( $prediction[$y]["x3"] == 1 ){
						$points = $points * $settings[0]["x3"];
						updatePredictionDB("user",array("x3"=>1),"`id` = '{$prediction[$y]["userId"]}'");
					}
					//update predictions table
					updatePredictionDB("predictions",array("counted"=>1,"points"=>$points,"status"=>1),"`id` = '{$prediction[$y]["id"]}'");
					//update user points
					updatePredictionDB("user",array("pPoints"=>"`pPoints` + {$points}"),"`id` = '{$prediction[$y]["userId"]}'");
					//update user points
					updatePredictionDB("user",array("points"=>"`points` + {$points}"),"`id` = '{$prediction[$y]["userId"]}'");
				}
				updatePredictionDB("matches",array("status"=>2),"`id` = '{$matches[0]["id"]}'");
			}
		}
	}
	$sql = "UPDATE `user` u
			JOIN
			(
				SELECT id, (@rownumber := @rownumber + 1) AS rownum
				FROM `user`         
				CROSS JOIN (select @rownumber := 0) r
				WHERE status = '0'
				ORDER BY `points` DESC
			) AS newRow ON u.id = newRow.id    
			SET `rank` = rownum
			";
	$dbconnect->query($sql);
	$sql = "UPDATE `joinedLeagues` as jl
			JOIN `user` as u ON u.id = jl.userId
			SET jl.rank = u.rank
			WHERE u.id = jl.userId
			";
	$dbconnect->query($sql);
	if( $leagues = selectDB("subLeagues","`status` = '0'") ){
		for($i = 0; $i < sizeof($leagues); $i++ ){
			$sql = "UPDATE `joinedLeagues` u
					JOIN
					(
						SELECT userId, (@rownumber := @rownumber + 1) AS rownum
						FROM `joinedLeagues`         
						CROSS JOIN (select @rownumber := 0) r
						WHERE `leagueId` = '{$leagues[$i]["id"]}'
						ORDER BY `rank` ASC
					) AS newRow ON u.userId = newRow.userId    
					SET `rank` = rownum
					WHERE `leagueId` = '{$leagues[$i]["id"]}'
					";
			$dbconnect->query($sql);
		}
	}
}

function selectDBNew($table, $placeHolders, $where, $order){
    GLOBAL $dbconnect;
    $check = [';', '"'];
    $where = str_replace($check, "", $where);
    $sql = "SELECT * FROM `{$table}`";
    if(!empty($where)) {
        $sql .= " WHERE {$where}";
    }
    if(!empty($order)) {
        $sql .= " ORDER BY {$order}";
    }
    if($stmt = $dbconnect->prepare($sql)) {
        $types = str_repeat('s', count($placeHolders));
        $stmt->bind_param($types, ...$placeHolders);
        $stmt->execute();
        $result = $stmt->get_result();
        $array = array();
        while ($row = $result->fetch_assoc()) {
            $array[] = $row;
        }
        if(isset($array) && is_array($array)) {
            return $array;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}
?>