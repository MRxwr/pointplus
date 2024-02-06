<?php
if( !isset($_POST["userId"]) || empty($_POST["userId"]) ){
    $response["msg"] = "Please set user id";
    echo outputError($response);die();
}

if( isset($_POST["join"]) AND !empty($_POST["join"]) ){
    if( $_POST["join"] == 2 ){
        if( isset($_POST["roomCode"]) && !empty($_POST["roomCode"]) && $room = selectDB("quiz_room","`code` = '{$_POST["roomCode"]}'") ){
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
    }else{
        if( $room = selectDB("quiz_room","`type` = '1' AND `status` = '0' AND `hidden` = '0'") ){
            $response["room"] = $room;
            echo outputData($response);die();
        }else{
            $listOfUsers = array(
                "id" => $_POST["userId"],
            );
            $dataInsert = array(
                "listOfUsers" => json_encode($listOfUsers),
                "listOfCategories" => json_encode(array()),
                "listOfQuestions" => json_encode(array()),
                "code" => randomCode(),
                "type" => "1",
                "winner" => "0",
                "total" => "0",
                "status" => "0",
                "hidden" => "0",
            );
            insertDB("quiz_room",$dataInsert);
            $room = selectDB("quiz_room","`type` = '1' AND `status` = '0' AND `hidden` = '0' AND JSON_EXTRACT(id, '$.id') = '{$_POST["userId"]}'");
            $response["room"] = $room;
            echo outputData($response);die();
        }
    }
    
}

?>