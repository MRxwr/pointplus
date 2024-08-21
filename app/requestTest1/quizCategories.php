<?php
if( $categories = selectDataDB("`id`,`arTitle`,`enTitle`","quiz_categories","`status` = '0' AND `hidden` = '0'") ){
	$response["categories"] = $categories;
	echo outputData($response);
}else{
    $response["categories"] = array();
	$response["msg"] = "No categories found";
	echo outputError($response);die();
}
?>