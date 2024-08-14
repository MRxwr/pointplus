<?php
//add complain
if ( isset($_GET["userId"]) && !empty($_GET["userId"]) ){
	$data = $_GET;
	if( (!isset($_POST["redeem"]) || empty($_POST["redeem"])) && $user = selectDB("user","`id` = '{$_GET["userId"]}'") ){
		$response = array(
			"points" => $user[0]["points"],
			"pointsToBeRedeemed" => abs($user[0]["points"] - $user[0]["redeemedPoints"]),
			"coins" => $user[0]["coins"]
		);
		echo outputData($response);
	}elseif( isset($_POST["redeem"]) && !empty($_POST["redeem"]) ){
		if( $user = selectDB("user","`id` = '{$_GET["userId"]}'") ){
			$newCoins = (int) abs( ($user[0]["points"] - $user[0]["redeemedPoints"]) / 100);
			$reddemedPoints = ($newCoins * 100);
			$data = array(
				"userId" => $user[0]["id"],
				"oldPoints" => $user[0]["points"],
				"redeemedPoints" => $reddemedPoints,
				"oldCoins" => $user[0]["coins"],
				"newCoins" => $newCoins,
			);
			if( $newCoins > 0
				&& insertDB('coins_history',$data)
				&& updateDB("user",array("coins" => ($newCoins+$user[0]["coins"]), "redeemedPoints" => ($reddemedPoints) ),"`id` = '{$user[0]["id"]}'")
			){
				$response = array(
					"enMsg" => "Your poitns has been redeemed successfully",
					"arMsg" => "تم تحويل النقاط بنجاح."
				);
				echo outputData($response);
			}else{
				$response = array(
					"enMsg" => "Not enough points to be redeemed.",
					"arMsg" => "لا تملك نقاط كافيه"
				);
				echo outputError($response);die();
			}
		}else{
			$response = array(
				"enMsg" => "Please add a correct user id.",
				"arMsg" => "الرجاء إضافة رمز مستخدم صحيح"
			);
			echo outputError($response);die();
		}
	}else{
		$response = array(
			"enMsg" => "Error while trying to load data. Please try again",
			"arMsg" => "حدث خطأ اثناء البحث عن المعلومات، الرجاء المحاولة لاحقاً"
		);
		echo outputError($response);die();
	}
}else{
	$response["msg"] = "Please enter user Id";
	echo outputError($response);die();
}


?>