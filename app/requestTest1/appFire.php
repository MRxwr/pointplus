<?php
if( !isset($_POST["userId"]) || empty($_POST["userId"]) ){
    $response["msg"] = "Please set user id";
    echo outputError($response);die();
}elseif( !isset($_POST["firebase"]) || empty($_POST["firebase"]) ){
    $response["msg"] = "Please firebase token";
    echo outputError($response);die();
}else{
    updateDB("users",array("firebase"=>$_POST["firebase"]),"`id` = '{$_POST["userId"]}'");
    if( $room = selectDB("quiz_room","`status` = '0' AND `hidden` = '0' AND JSON_UNQUOTE(JSON_EXTRACT(listOfUsers,'$[*].id')) LIKE '%{$_POST["userId"]}%'") ){
        $response["room"] = $room;
        echo outputData($response);
    }else{
        $response["room"] = array();
        $response["msg"] = "Room not found";
        echo outputError($response);
    }
}

?>