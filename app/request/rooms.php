<?php
if( isset($_POST["roomCode"]) && !empty($_POST["roomCode"]) && $room = selectDB("rooms","`code` = '{$_POST["roomCode"]}'") ){
    $room = json_decode($room,true);
    if( isset($room["error"]) && $room["error"] == 1 ){
        $response["room"] = array();
        $response["msg"] = "Room not found";
        echo outputError($response);die();
    }else{
        $response["room"] = $room;
        echo outputData($response);die();
    }
}else{
    $response["room"] = array();
    $response["msg"] = "Room not found";
    echo outputError($response);die();
}
?>