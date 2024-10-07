<?php
//get banners
if ( $banners = selectDataDB("`id`, `enTitle`, `arTitle`, `image`, `url`, `type`",'banners',"`status` = '0' AND `type` = '0'") ){
	$response["banners"] = $banners;
}else{
	$response["banners"] = array();
}

//get user details
if ( isset($_GET["id"]) && !empty($_GET["id"]) ){
	if( $total = selectDB('notification', "`userId` LIKE '{$_GET["id"]}' AND `seen` LIKE '0'") ){
		$response["user"]["notifications"] = (string)sizeof($total);
	}else{
		$response["user"]["notifications"] = "0";
	}
	if( $user = selectDB('user', "`id` = '{$_GET["id"]}'") ){
		if( $user[0]["status"] == 1 ){
			$error = array("msg"=>"Your account has been blocked. Please aconatct administration.");
			echo outputError($error);die();
		}elseif( $user[0]["status"] == 2 ){
			$error = array("msg"=>"No user with this email.");
			echo outputError($error);die();
		}
		$response["user"]["points"] = $user[0]["points"];
		$response["user"]["rank"] = $user[0]["rank"];
		$response["user"]["pRank"] = $user[0]["pRank"];
	}else{
		$response["user"]["points"] = "0";
		$response["user"]["rank"] = "0";
		$response["user"]["pRank"] = "0";
	}
	$data= array(
				"select"=>["t.round","SUM(t1.points) AS totalPoints"],
				"join" => ["predictions"],
				"on" => [" t.id = t1.matchId"]
			);
	if( $pastResults = selectJoinDB('matches',$data,"t1.userId = '{$_GET["id"]}' AND t.status = '0' GROUP BY t.round ORDER BY t.round DESC") ){
		$response["user"]["stats"] = $pastResults;
		if( isset($pastResults[1]["round"]) && !empty($pastResults[1]["round"]) ){
			$response["user"]["stats"][1]["round"] = $pastResults[1]["round"];
			$response["user"]["stats"][1]["totalPoints"] = $pastResults[1]["totalPoints"];
		}else{
			$response["user"]["stats"][1]["round"] = "0";
			$response["user"]["stats"][1]["totalPoints"] = "0";
		}
	}elseif($pastResults = selectJoinDB('matches',$data,"t.status = '0' GROUP BY t.round ORDER BY t.round DESC LIMIT 2")){
		$response["user"]["stats"] = $pastResults;
		$response["user"]["stats"][0]["totalPoints"] = "0";
		if( isset($pastResults[1]["round"]) && !empty($pastResults[1]["round"]) ){
			$response["user"]["stats"][1]["round"] = $pastResults[1]["round"];
			$response["user"]["stats"][1]["totalPoints"] = "0";
		}else{
			$response["user"]["stats"][1]["round"] = "0";
			$response["user"]["stats"][1]["totalPoints"] = "0";
		}
	}else{
		$response["user"]["stats"][0]["round"] = "0";
		$response["user"]["stats"][0]["totalPoints"] = "0";
		$response["user"]["stats"][1]["round"] = "0";
		$response["user"]["stats"][1]["totalPoints"] = "0";
	}
}else{
	$response["user"]["notifications"] = "0";
	$response["user"]["points"] = "0";
	$response["user"]["rank"] = "0";
	$response["user"]["pRank"] = "0";
}

// get top 3 users
if ( $leaderboard = selectDataDB("`id`,`username`, `name`, `points`","user","`status` = '0' AND `type` = '2' AND `rank` != '0' ORDER BY `rank` ASC LIMIT 3") ){
	$response["leaderboard"] = $leaderboard;
}elseif( $leaderboard = selectDataDB("`id`,`username`, `name`, `points`","user","`status` = '0' AND `type` = '2' AND `rank` = '0' ORDER BY RAND() LIMIT 3") ){
	$response["leaderboard"] = $leaderboard;
}else{
	$response["leaderboard"] = array();
}

// getting winners
if ( $winners = selectDataDB("`id`,`username`, `name`, `team`, `winner`","user","`status` = '0' AND `type` = '2' AND `winner` != '0'") ){
	$response["winners"] = $winners;
}else{
	$response["winners"] = array();
}

// getting all game week rounds
if ( $rounds = selectDataDB("`round`","matches","`status` != '0' GROUP BY `round` ORDER BY `round` DESC") ){
	$response["rounds"] = $rounds;
}else{
	$response["rounds"] = array();
}

//get requested round
if( isset($_GET["round"]) && !empty($_GET["round"]) ){
	$rounds[0]["round"] = $_GET["round"];
}

// get rounds matches 
if ( isset($rounds[0]["round"]) && !empty($rounds[0]["round"]) && $matches = selectDB("matches","`status` != '0' AND `round` = {$rounds[0]["round"]} ORDER BY `id` DESC") ){
	for( $i = 0; $i < sizeof($matches); $i++ ){
		if( $team = selectDataDB("`arTitle`,`enTitle`,`logo`","teams","`id` = '{$matches[$i]["team1"]}'") ){
			$team1 = $team;
		}
		if( $team = selectDataDB("`arTitle`,`enTitle`,`logo`","teams","`id` = '{$matches[$i]["team2"]}'") ){
			$team2 = $team;
		}
		if( $prediction = selectDB("predictions","`matchId` = '{$matches[$i]["id"]}' AND `userId` = '{$_GET["id"]}'") ){
			$predictionResponse = array(
				"goals1" => $prediction[0]["goals1"],
				"goals2" => $prediction[0]["goals2"],
				"points" => (string)$prediction[0]["points"]
			);
			if( $matches[$i]["isActive"] == 0 && $matches[$i]["status"] == 1 ){
				$points = 0;
				// match result points
				if( $matches[$i]["goals1"] == $prediction[0]["goals1"] && $matches[$i]["goals2"] == $prediction[0]["goals2"] ){
					$points = $points + 5;
				}
				//match prediction points
				if( $prediction[0]["goals1"] > $prediction[0]["goals2"]  &&  $matches[$i]["goals1"] > $matches[$i]["goals2"] ){
					$points = $points + 5;
				}elseif( $prediction[0]["goals1"] < $prediction[0]["goals2"]  &&  $matches[$i]["goals1"] < $matches[$i]["goals2"] ){
					$points = $points + 5;
				}elseif( $prediction[0]["goals1"] == $prediction[0]["goals2"]  &&  $matches[$i]["goals1"] == $matches[$i]["goals2"] ){
					$points = $points + 5;
				}
				//check for supermatch
				if( $matches[$i]["type"] == 1 ){
					$points = $points * 2;
				}
				//check for x2
				if( $prediction[0]["x2"] == 1 ){
					$points = $points * $settingsAdmin[0]["x2"];;
				}
				// check for x3
				if( $prediction[0]["x3"] == 1 ){
					$points = $points * $settingsAdmin[0]["x3"];
				}
				$predictionResponse = array(
					"goals1" => $prediction[0]["goals1"],
					"goals2" => $prediction[0]["goals2"],
					"points" => (string)$points,
				);
			}
		}else{
			$predictionResponse = array("goals1"=>"0","goals2"=>"0","points"=>"0");
		}
		$response["matches"][] = array(
			"id" => $matches[$i]["id"],
			"status" => $matches[$i]["status"],
			"staduim" => $matches[$i]["staduim"],
			"matchDate" => $matches[$i]["matchDate"],
			"matchTime" => $matches[$i]["matchTime"],
			"isActive" => $matches[$i]["isActive"],
			"type" => $matches[$i]["type"],
			"team1"=>$team1,
			"team2"=>$team2,
			"result"=>array(
				"goals1"=>$matches[$i]["goals1"],
				"goals2"=>$matches[$i]["goals2"]
				),
			"predictions"=>$predictionResponse
		);
	}
}else{
	$response["matches"] = array();
}

echo outputData($response);
?>
