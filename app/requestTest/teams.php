<?php

if( isset($_GET["type"]) && !empty($_GET["type"]) ){
	if( $_GET["type"] == "list" ){
		$data = array(
			"select" => ["t.id as leagueId, t.enTitle as leagueEnTitle, t.arTitle as leagueArTitle, t.logo as leagueLogo, t1.id as teamId, t1.enTitle as teamEnTitle, t1.arTitle as teamArTitle, t1.logo as teamLogo "],
			"join" => ["teams"],
			"on" => ["t.id = t1.leagueId"]
		);
		if( $teams = selectJoinDB("leagues",$data,"t.status = '0' AND t1.status = '0' ORDER BY t.enTitle ASC") ){
			$response["teams"] = $teams;
			echo outputData($response);die();
		}
	}elseif( $_GET["type"] == "update" ){
		if( !isset($_POST["userId"]) || empty($_POST["userId"]) ){
			$response["msg"] = "Please set user id";
			echo outputError($response);die();
		}elseif( !isset($_POST["favoTeam"]) || empty($_POST["favoTeam"]) ){
			$response["msg"] = "Please set favoruite team id";
			echo outputError($response);die();
		}else{
			$userId = $_POST["userId"];
			unset($_POST["userId"]);
			if( selectDB("teams","`status` = '0' AND `id` = '{$_POST["favoTeam"]}'")){
				if( updateDB("user",$_POST,"`id` = '{$userId}'") ){
					$response["msg"] = "Profile updated successfully.";
					echo outputData($response);die();
				}else{
					$response["msg"] = "Please try again, something wrong happened";
					echo outputError($response);die();
				}
			}else{
				$response["msg"] = "No team with this id.";
				echo outputError($response);die();
			}
		}
	}else{
		$response["msg"] = "wrong type, please use list or update";
		echo outputError($response);die();
	}
}else{
	$response["msg"] = "Please set type, list or update";
	echo outputError($response);die();
}

?>