<?php
//get banners
if ( $banners = selectDataDB("`id`, `enTitle`, `arTitle`, `image`, `url`, `type`",'banners',"`status` = '0' AND `type` = '0'") ){
	$response["banners"] = $banners;
}else{
	$response["banners"] = array();
}

//get user details
if ( isset($_GET["userId"]) && !empty($_GET["userId"]) ){
    // get main user details
	if( $user = selectDB('user', "`id` = '{$_GET["userId"]}'") ){
		$response["user"]["points"] = $user[0]["points"];
		$response["user"]["rank"] = $user[0]["rank"];
		$response["user"]["pRank"] = $user[0]["pRank"];
	}else{
		$response["user"]["points"] = "0";
		$response["user"]["rank"] = "0";
		$response["user"]["pRank"] = "0";
	}
    // get comapre user details
    if( $user = selectDB('user', "`id` = '{$_GET["compareId"]}'") ){
		$response["compare"]["points"] = $user[0]["points"];
		$response["compare"]["rank"] = $user[0]["rank"];
		$response["compare"]["pRank"] = $user[0]["pRank"];
	}else{
		$response["compare"]["points"] = "0";
		$response["compare"]["rank"] = "0";
		$response["compare"]["pRank"] = "0";
	}
	$data= array(
				"select"=>["t.round","SUM(t1.points) AS totalPoints"],
				"join" => ["predictions"],
				"on" => [" t.id = t1.matchId"]
			);
    // main user predictions and results
	if( $pastResults = selectJoinDB('matches',$data,"t1.userId = '{$_GET["userId"]}' AND t.status = '0' GROUP BY t.round ORDER BY t.round DESC") ){
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
    // comapre user predictions and results
    if( $pastResults = selectJoinDB('matches',$data,"t1.userId = '{$_GET["userId"]}' AND t.status = '0' GROUP BY t.round ORDER BY t.round DESC") ){
		$response["compare"]["stats"] = $pastResults;
		if( isset($pastResults[1]["round"]) && !empty($pastResults[1]["round"]) ){
			$response["compare"]["stats"][1]["round"] = $pastResults[1]["round"];
			$response["compare"]["stats"][1]["totalPoints"] = $pastResults[1]["totalPoints"];
		}else{
			$response["compare"]["stats"][1]["round"] = "0";
			$response["compare"]["stats"][1]["totalPoints"] = "0";
		}
	}elseif($pastResults = selectJoinDB('matches',$data,"t.status = '0' GROUP BY t.round ORDER BY t.round DESC LIMIT 2")){
		$response["compare"]["stats"] = $pastResults;
		$response["compare"]["stats"][0]["totalPoints"] = "0";
		if( isset($pastResults[1]["round"]) && !empty($pastResults[1]["round"]) ){
			$response["compare"]["stats"][1]["round"] = $pastResults[1]["round"];
			$response["compare"]["stats"][1]["totalPoints"] = "0";
		}else{
			$response["compare"]["stats"][1]["round"] = "0";
			$response["compare"]["stats"][1]["totalPoints"] = "0";
		}
	}else{
		$response["compare"]["stats"][0]["round"] = "0";
		$response["compare"]["stats"][0]["totalPoints"] = "0";
		$response["compare"]["stats"][1]["round"] = "0";
		$response["compare"]["stats"][1]["totalPoints"] = "0";
	}
}else{
	$response["compare"]["notifications"] = "0";
	$response["compare"]["points"] = "0";
	$response["compare"]["rank"] = "0";
	$response["compare"]["pRank"] = "0";
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
        // main user per match
		if( $prediction = selectDB("predictions","`matchId` = '{$matches[$i]["id"]}' AND `userId` = '{$_GET["userId"]}'") ){
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
				//check for x3
				if( $matches[$i]["type"] == 1 ){
					if( $prediction[0]["x3"] == 1 ){
						$points = $points * 2 * 3;
					}else{
						$points = $points * 2;
					}
				}
				//check for x2
				if( $prediction[0]["x2"] == 1 ){
					$points = $points * 2;
				}
				$userPredictionResponse = array(
					"goals1" => $prediction[0]["goals1"],
					"goals2" => $prediction[0]["goals2"],
					"points" => (string)$points,
				);
			}
		}else{
			$userPredictionResponse = array("goals1"=>"0","goals2"=>"0","points"=>"0");
		}
        // compare user per match
        if( $prediction = selectDB("predictions","`matchId` = '{$matches[$i]["id"]}' AND `userId` = '{$_GET["compareId"]}'") ){
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
				//check for x3
				if( $matches[$i]["type"] == 1 ){
					if( $prediction[0]["x3"] == 1 ){
						$points = $points * 2 * 3;
					}else{
						$points = $points * 2;
					}
				}
				//check for x2
				if( $prediction[0]["x2"] == 1 ){
					$points = $points * 2;
				}
				$comparePredictionResponse = array(
					"goals1" => $prediction[0]["goals1"],
					"goals2" => $prediction[0]["goals2"],
					"points" => (string)$points,
				);
			}
		}else{
			$comparePredictionResponse = array("goals1"=>"0","goals2"=>"0","points"=>"0");
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
			"predictions"=>array(
                "user" => $userPredictionResponse,
                "comapre" => $comparePredictionResponse
            )
		);
	}
}else{
	$response["matches"] = array();
}

echo outputData($response);
?>