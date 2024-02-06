<?php
if( isset($_POST["roomCode"]) && !empty($_POST["roomCode"]) && $room = selectDB("rooms","`code` = '{$_POST["roomCode"]}'") ){
    $response["room"] = json_decode($room,true);
    echo outputData($response);die();
}else{
    $response["room"] = array();
    echo outputError($response);
}
?>