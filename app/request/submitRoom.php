<?php
if( !isset($_POST["roomId"]) || empty($_POST["roomId"]) ){
    $response["msg"] = "Please set room id";
    echo outputError($response);die();
}
if( !isset($_POST["winner"]) || empty($_POST["winner"]) ){
    $response["msg"] = "Please set winner id";
    echo outputError($response);die();
}
if( !isset($_POST["points"]) ){
    $response["msg"] = "Please set points";
    echo outputError($response);die();
}

if( $room = selectDB("quiz_room","`id` = '{$_POST["roomId"]}'") ){
    $dataUpdate = array(
        "winner" => $_POST["winner"],
        "points" => $_POST["points"],
        "status" => "1",
        "hidden" => "1",
    );
    if ( updateDB("quiz_room",$dataUpdate,"`id` = '{$room[0]["id"]}'") ){
        $room = selectDB("quiz_room","`id` = '{$_POST["roomId"]}'");
        $response["room"] = $room;
        $response["msg"] = "Room Submitted";
        echo outputData($response);die();
    }else{
        $response["room"] = array();
        $response["msg"] = "Room not found";
        echo outputError($response);die();
    }
}
?>