<?php
//get address
if ( $banners = selectDataDB("`id`, `enTitle`, `arTitle`, `image`, `url`, `type`",'banners',"`status` = '0' AND `type` = '4'") ){
    $response["banners"] = $banners;
}else{
    $response["banners"] = array();
}

// get top 3 users
if ( $leaderboard = selectDataDB("`id`,`username`, `name`, `points`","user","`status` = '0' AND `type` = '2' AND `rank` != '0' ORDER BY `rank` ASC LIMIT 3") ){
	$response["leaderboard"] = $leaderboard;
}elseif( $leaderboard = selectDataDB("`id`,`username`, `name`, `points`","user","`status` = '0' AND `type` = '2' AND `rank` = '0' ORDER BY RAND() LIMIT 3") ){
	$response["leaderboard"] = $leaderboard;
}else{
	$response["leaderboard"] = array();
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
        $response["top"] = null;
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
        $response["top"] = null;
    }
}

echo outputData($response);
?>