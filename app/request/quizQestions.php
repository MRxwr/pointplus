<?php
if( $questions = selectDataDB("`id`,`question`,`answer1`,`isCorrect1`,`answer2`,`isCorrect2`,`answer3`,`isCorrect3`,`points`,`image`","quiz_question","`status` = '0' AND `hidden` = '0' AND `quizCategory` = '{$_GET["quizCategory"]}' ORDER BY RAND() LIMIT {$_GET["noOfQuestions"]}") ){
	$response["questions"] = $questions;
	echo outputData($response);
}else{
    $response["questions"] = array();
	$response["msg"] = "No questions found";
	echo outputError($response);die();
}
?>