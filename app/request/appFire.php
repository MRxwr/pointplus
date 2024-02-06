<?php
if( !isset($_POST["userId"]) || empty($_POST["userId"]) ){
    $response["msg"] = "Please set user id";
    echo outputError($response);die();
}elseif( !isset($_POST["firebase"]) || empty($_POST["firebase"]) ){
    $response["msg"] = "Please firebase token";
    echo outputError($response);die();
}else{
    updateDB("users",array("firebase"=>$_POST["firebase"]),"`id` = '{$_POST["userId"]}'");
    if( $rooms = selectDB("rooms","`status` = '0' AND `hidden` = '0' AND JSON_EXTRACT(id, '$.id') = '{$_POST["userId"]}'") ){
        $room = json_decode($rooms,true);
        if( isset($room["error"]) && $room["error"] == 1 ){
            $response["room"] = array();
            echo outputError($response);
        }else{
            $response["room"] = $room;
            echo outputData($response);
        }
    }else{
        $response["room"] = array();
        echo outputError($response);
    }
}

?>