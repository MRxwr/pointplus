<?php
//get address
if ( $banners = selectDataDB("`id`, `enTitle`, `arTitle`, `image`, `url`, `type`",'banners',"`status` = '1' AND `type` = '4'") ){
    $response["banners"] = $banners;
}else{
    $response["banners"] = array();
}

if ( $list = selectDataDB("`id`,`enTitle`,`arTitle`",'tops',"`status` = '0' AND `hidden` = '0' ORDER BY `id` DESC") ){
    $response["list"] = $list;
}else{
    $response["list"] = array();
}

if( isset($_GET["topId"]) && !empty($_GET["topId"]) ){
    $topId = $_GET["topId"];
    if ( $top = selectDataDB("*",'tops',"`id` = '$topId'") ){
        $response["top"] = array(
            "id" => $top[0]["id"],
            "enTitle" => $top[0]["enTitle"],
            "arTitle" => $top[0]["arTitle"],
            "list" => json_decode($top[0]["topUsers"],true)
        );
    }else{
        $response["top"] = array(
            "id" => $top[0]["id"],
            "enTitle" => $top[0]["enTitle"],
            "arTitle" => $top[0]["arTitle"],
            "list" => json_decode("",true)
        );
    }
}else{
	if ( $top = selectDataDB("*",'tops',"`status` = '0' AND `hidden` = '0' ORDER BY `id` DESC LIMIT 1") ){
        $response["top"] = array(
            "id" => $top[0]["id"],
            "enTitle" => $top[0]["enTitle"],
            "arTitle" => $top[0]["arTitle"],
            "list" => json_decode($top[0]["topUsers"],true)
        );
    }else{
        $response["top"] = array();
    }
}

echo outputData($response);
?>