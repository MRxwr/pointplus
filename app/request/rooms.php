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
        if( isset($_POST["roomId"]) && !empty($_POST["roomId"]) ){
            if( $room = selectDB("quiz_room","`type` = '1' AND `status` = '0' AND `hidden` = '0' AND `id` = '{$_POST["roomId"]}'") ){
                $response["room"] = array(
                    "id" => $room[0]["id"],
                    "code" => $room[0]["code"],
                    "listOfUsers" => json_decode($room[0]["listOfUsers"],true),
                    "listOfCategories" => json_decode($room[0]["listOfCategories"],true),
                    "listOfQuestions" => json_decode($room[0]["listOfQuestions"],true),
                    "type" => $room[0]["type"],
                    "winner" => $room[0]["winner"],
                    "total" => $room[0]["total"],
                    "status" => $room[0]["status"],
                    "hidden" => $room[0]["hidden"],
                );
                echo outputData($response);die();
            }else{
                $response["room"] = array();
                $response["msg"] = "Room not found";
                echo outputError($response);die();
            }
        }

        if( $room = selectDB("quiz_room","`type` = '1' AND `status` = '0' AND `hidden` = '0'") ){
            $listOfUsers = json_decode($room[0]["listOfUsers"],true);
            array_push($listOfUsers,array("id"=>$_POST["userId"]));
            updateDB("quiz_room",array("listOfUsers"=>json_encode($listOfUsers)),"`id` = '{$room[0]["id"]}'");
            $room = selectDB("quiz_room","`type` = '1' AND `status` = '0' AND `hidden` = '0' AND `id` = '{$room[0]["id"]}'");
            $response["room"] = array(
                    "id" => $room[0]["id"],
                    "code" => $room[0]["code"],
                    "listOfUsers" => json_decode($room[0]["listOfUsers"],true),
                    "listOfCategories" => json_decode($room[0]["listOfCategories"],true),
                    "listOfQuestions" => json_decode($room[0]["listOfQuestions"],true),
                    "type" => $room[0]["type"],
                    "winner" => $room[0]["winner"],
                    "total" => $room[0]["total"],
                    "status" => $room[0]["status"],
                    "hidden" => $room[0]["hidden"],
                );
            echo outputData($response);die();
        }else{
            $listOfUsers[] = array(
                "id" => $_POST["userId"],
            );
            $dataInsert = array(
                "listOfUsers" => json_encode($listOfUsers),
                "listOfCategories" => json_encode(array()),
                "listOfQuestions" => json_encode(array()),
                "code" => randomCodeQuiz(),
                "type" => "1",
                "winner" => "0",
                "total" => "0",
                "status" => "0",
                "hidden" => "0",
            );
            insertDB("quiz_room",$dataInsert);
            $room = selectDB("quiz_room","`type` = '1' AND `status` = '0' AND `hidden` = '0' AND JSON_EXTRACT(listOfUsers, '$.id') = '{$_POST["userId"]}'");
            $response["room"] = array(
                "id" => $room[0]["id"],
                "code" => $room[0]["code"],
                "listOfUsers" => json_decode($room[0]["listOfUsers"],true),
                "listOfCategories" => json_decode($room[0]["listOfCategories"],true),
                "listOfQuestions" => json_decode($room[0]["listOfQuestions"],true),
                "type" => $room[0]["type"],
                "winner" => $room[0]["winner"],
                "total" => $room[0]["total"],
                "status" => $room[0]["status"],
                "hidden" => $room[0]["hidden"],
            );
            echo outputData($response);die();
        }
    }
    
}

?>