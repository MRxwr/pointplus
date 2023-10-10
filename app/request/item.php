<?php
if( $items = selectDataDB("`id`,`arTitle`,`enTitle`,`image`,`coins`","products","`status` = '0' AND `quantity` > '0'") ){
	$response["items"] = $items;
	echo outputData($response);
}else{
	$response["msg"] = "No items found";
	echo outputError($response);die();
}
?>