<?php
if( $user = selectDB2('sum(total) as totalPoints','quiz_room', "`winner` LIKE '{$_GET["userId"]}'")){
	$response = array(
        "totalPoints" => $user[0]["totalPoints"] ? $user[0]["totalPoints"] : "0"
    );
	echo outputData($response); 
}else{
	$response = array(
        "msg"=>"No user found with this ID.",
        "totalPoints" => "0"
    );
	echo outputError($response);
}
?>