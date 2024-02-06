<?php
if( !isset($_POST["userId"]) || empty($_POST["userId"]) ){
    $response["msg"] = "Please set user id";
    echo outputError($response);die();
}elseif( !isset($_POST["firebase"]) || empty($_POST["firebase"]) ){
    $response["msg"] = "Please firebase token";
    echo outputError($response);die();
}else{
    updateDB("users",array("firebase"=>$_POST["firebase"]),"`id` = '{$_POST["userId"]}'");
}

?>