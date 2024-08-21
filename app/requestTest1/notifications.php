<?php
if( $user = selectDB('notification', "`userId` LIKE '{$_GET["userId"]}' ORDER BY `date` DESC")){
	$data = array(
		"seen" => '1'
	);
	updateDB('notification',$data,"`userId` LIKE '{$_GET["userId"]}'");
	if ( $total = selectDB('notification', "`userId` LIKE '{$_GET["userId"]}' AND `seen` LIKE '0'") ){
		$totalSeen = sizeof($total);
	}else{
		$totalSeen = "0";
	}
	$output = array(
		"total" => $totalSeen,
		"notification" => $user
	);
	echo outputData($output);
}else{
	$msg = array(
		"msg" => "user Id does not exist",
		"total" => "0"
	);
	echo outputError($msg);
}
?>