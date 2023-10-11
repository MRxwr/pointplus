<?php
//get banners
if ( $banners = selectDataDB("`id`, `enTitle`, `arTitle`, `image`, `url`, `type`",'banners',"`status` LIKE '0'") ){
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
	if( $pastResults = selectJoinDB('matches',$data,"t1.userId = '{$_GET["id"]}' AND t.status = '0' GROUP BY t.round ORDER BY t.round DESC LIMIT 2") ){
		$response["user"]["stats"] = $pastResults;
		if( isset($pastResults[1]["round"]) && !empty($pastResults[1]["round"]) ){
			$response["user"]["stats"][1]["round"] = $pastResults[1]["round"];
			$response["user"]["stats"][1]["totalPoints"] = "0";
		}else{
			$response["user"]["stats"][1]["round"] = "0";
			$response["user"]["stats"][1]["totalPoints"] = "0";
		}
	}elseif($pastResults = selectJoinDB('matches',$data,"t.status = '0' GROUP BY t.round ORDER BY t.round DESC LIMIT 2")){
		$response["user"]["stats"][0]["round"] = $pastResults[0]["round"];
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
if ( $leaderboard = selectDataDB(" `username`, `name`, `points`","user","`status` = '0' AND `type` = '2' AND `rank` != '0' ORDER BY `rank` ASC LIMIT 3") ){
	$response["leaderboard"] = $leaderboard;
}else{
	$response["leaderboard"] = array();
}

// getting winners
if ( $winners = selectDataDB("`username`, `name`, `team`, `winner`","user","`status` = '0' AND `type` = '2' AND `winner` != '0'") ){
	$response["winners"] = $winners;
}else{
	$response["winners"] = array();
}

// getting all game week rounds
if ( $rounds = selectDataDB("`round`","matches","`status` != '2' GROUP BY `round` ORDER BY `round` DESC") ){
	$response["rounds"] = $rounds;
}else{
	$response["rounds"] = array();
}

//get requested round
if( isset($_GET["round"]) && !empty($_GET["round"]) ){
	$rounds[0]["round"] = $_GET["round"];
}

// get rounds matches 
if ( isset($rounds[0]["round"]) && !empty($rounds[0]["round"]) && $matches = selectDB("matches","`status` != '2' AND `round` = {$rounds[0]["round"]} ORDER BY `id` DESC") ){
	for( $i = 0; $i < sizeof($matches); $i++ ){
		if( $team = selectDataDB("`arTitle`,`enTitle`,`logo`","teams","`id` = '{$matches[$i]["team1"]}'") ){
			$team1 = $team;
		}
		if( $team = selectDataDB("`arTitle`,`enTitle`,`logo`","teams","`id` = '{$matches[$i]["team2"]}'") ){
			$team2 = $team;
		}
		if( $prediction = selectDataDB("`goals1`,`goals2`,`points`","predictions","`matchId` = '{$matches[$i]["id"]}' AND `userId` = '{$_GET["id"]}'") ){
			$prediction = $prediction[0];
			$points = $prediction[0]["points"];
			if( $matches[$i]["isActive"] == 0 ){
				// match result points
				if( $matches[$i]["goals1"] == $prediction[0]["golas1"] && $matches[$i]["goals2"] == $prediction[0]["golas2"] ){
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
				//check for x3
				if( $matches[$i]["type"] == 1 ){
					if( $prediction[0]["x3"] == 1 ){
						$points = $points * 3;
					}else{
						$points = $points * 2;
					}
				}
				//check for x2
				if( $prediction[0]["x2"] == 1 ){
					$points = $points * 2;
				}
				$prediction = array(
					"goals1" => $prediction[0]["goals1"],
					"goals2" => $prediction[0]["goals2"],
					"points" => (string)$points,
				);
			}
		}else{
			$prediction = array("goals1"=>"0","goals2"=>"0","points"=>"0");
		}
		$response["matches"][] = array(
			"id" => $matches[$i]["id"],
			"status" => $matches[$i]["status"],
			"staduim" => $matches[$i]["staduim"],
			"matchDate" => $matches[$i]["matchDate"],
			"matchTime" => $matches[$i]["matchTime"],
			"isActive" => $matches[$i]["isActive"],
			"team1"=>$team1,
			"team2"=>$team2,
			"result"=>array(
				"goals1"=>$matches[$i]["goals1"],
				"goals2"=>$matches[$i]["goals2"]
				),
			"predictions"=>$prediction
		);
	}
}else{
	$response["matches"] = array();
}

echo outputData($response);
?>