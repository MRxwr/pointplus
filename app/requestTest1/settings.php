<?php
if ( $settigns = selectDB('settings'," `id` LIKE '1'") ){
	if ( $banners = selectDataDB("`id`, `enTitle`, `arTitle`, `image`, `url`, `type`",'banners',"`status` = '0' AND `type` = '3'") ){
		$response["banners"] = $banners;
	}else{
		$response["banners"] = array();
	}
	$response["version"] = $settigns[0]["version"];
	$response["enTerms"] = $settigns[0]["enTerms"];
	$response["arTerms"] = $settigns[0]["arTerms"];
	$response["enPolicy"] = $settigns[0]["enPolicy"];
	$response["arPolicy"] = $settigns[0]["arPolicy"];
	$response["enAbout"] = $settigns[0]["enAbout"];
	$response["arAbout"] = $settigns[0]["arAbout"];
	$response["insta"] = $settigns[0]["instagram"];
	$response["whatsapp"] = $settigns[0]["whatsapp"];
	$response["twitter"] = $settigns[0]["twitter"];
	echo outputData($response);
}else{
	echo outputError(array("msg"=>"Please try again."));
}
?>