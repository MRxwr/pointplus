<?php
if( !isset($_POST["userId"]) || empty($_POST["userId"]) ){
    $response["msg"] = "Please set user id";
    echo outputError($response);die();
}elseif( !isset($_POST["friebase"]) || empty($_POST["friebase"]) ){
    $response["msg"] = "Please friebase token";
    echo outputError($response);die();
}else{
    updateDB("users",array("friebase"=>$_POST["friebase"]),"`id` = '{$_POST["userId"]}'");
}

?>