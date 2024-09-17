<?php
if( isset($_GET["type"]) && !empty($_GET["type"]) ){
	if ( $banners = selectDataDB("`id`, `enTitle`, `arTitle`, `image`, `url`, `type`",'banners',"`status` = '0' AND `type` = '2'") ){
		$response["banners"] = $banners;
	}else{
		$response["banners"] = array();
	}
	if ( !isset($_POST["userId"]) || empty($_POST["userId"]) ){
		$response["msg"] = "Please set user id";
		echo outputError($response);die();
	}
	if( $_GET["type"] == "list" ){
		$data = array(
			"select" => ["t.id as matchId, t.type, t.staduim, t.matchDate, t.matchTime, t.isActive, t.countdown, t1.enTitle as enTitleTeam1, t1.arTitle as arTitleTeam1, t1.logo as logoTeam1, t2.enTitle as enTitleTeam2, t2.arTitle as arTitleTeam2, t2.logo as logoTeam2, t3.arTitle as leagueAr, t3.enTitle as leagueEn"],
			"join" => ["teams","teams","leagues"],
			"on" => ["t.team1 = t1.id","t.team2 = t2.id", "t.league = t3.id"]
		);
		$response["isOn"] = array(
			"x3" => $settingsAdmin[0]["x3"],
			"x2" => $settingsAdmin[0]["x2"]
		);
		if( $teams = selectJoinDB("matches",$data,"t.status = '1' ORDER BY t.id DESC, t.round DESC") ){
			for ( $i = 0; $i < sizeof($teams); $i++){
				if ( $userPrediction = selectDataDB("`goals1`, `goals2`","predictions","`matchId` = '{$teams[$i]["matchId"]}' AND `userId` = '{$_POST["userId"]}'") ){
					$teams[$i]["goals1"] = $userPrediction[0]["goals1"];
					$teams[$i]["goals2"] = $userPrediction[0]["goals2"];
				}else{
					$teams[$i]["goals1"] = "0";
					$teams[$i]["goals2"] = "0";
				}
				list($countdownDate, $countdownTime) = explode('T', $teams[$i]["countdown"]);
				$countdownString = "{$countdownDate} {$countdownTime}:00" ;
				$teams[$i]["startTime"] = date("Y-m-d H:i:s");
				$teams[$i]["countdown"] = $countdownString;
			}
			$response["countdown"] = date("Y-m-d H:i:s");
			$response["startTime"] = date("Y-m-d H:i:s");
			$response["teams"] = $teams;
			
			$user = selectDB("user","`id` = '{$_POST["userId"]}'");
			$response["user"] = array(
				"x2" => $user[0]["x2"],
				"x3" => $user[0]["x3"]
			);
		}else{
			//$response["countdown"] = date("Y-m-d H:i:s" , strtotime($date . " + 7 days"));
			$response["countdown"] = date("Y-m-d H:i:s");
			$response["startTime"] = date("Y-m-d H:i:s");
			$response["teams"] = array();
			$user = selectDB("user","`id` = '{$_POST["userId"]}'");
			$response["user"] = array(
				"x2" => $user[0]["x2"],
				"x3" => $user[0]["x3"]
			);
		}
		echo outputData($response);die();
	}elseif( $_GET["type"] == "update" ){
		if( !isset($_POST["userId"]) || empty($_POST["userId"]) ){
			$response["msg"] = "Please set user id";
			echo outputError($response);die();
		}elseif( !isset($_POST["matchId"]) || empty($_POST["matchId"]) ){
			$response["msg"] = "Please set match id";
			echo outputError($response);die();
		}elseif( !isset($_POST["goals1"][0]) ){
			$response["msg"] = "Please set goals 1";
			echo outputError($response);die();
		}elseif( !isset($_POST["goals2"][0]) ){
			$response["msg"] = "Please set goals 2";
			echo outputError($response);die();
		}elseif( $userData = selectDB("user","`id` = '{$_POST["userId"]}'") ){
			if ( selectDB("matches","`id` = '{$_POST["matchId"][0]}'") ){
				for( $i = 0; $i < sizeof($_POST["matchId"]); $i++){
					$theMatch = selectDB("matches","`id` = '{$_POST["matchId"][0]}'");
					$theCountDown = str_replace("T", " ", $theMatch[0]["countdown"]);
					$theDate = date("Y-m-d H:i");
					if( strtotime($theCountDown) > strtotime($theDate) ){
						echo "Still time left";
					}else{
						echo "No Time Left";
					}
					die();
					$_POST["x2"][$i] = ($userData[0]["x2"] == 1 ? 0 : $_POST["x2"][$i]);
					$_POST["x3"][$i] = ($userData[0]["x3"] == 1 ? 0 : $_POST["x3"][$i]);
					$dataUpdate = array(
						"goals1"=> $_POST["goals1"][$i],
						"goals2"=> $_POST["goals2"][$i],
						"x2"=> $_POST["x2"][$i],
						"x3"=> $_POST["x3"][$i]
					);
					$dataInsert = array(
						"userId"=> $_POST["userId"],
						"matchId"=> $_POST["matchId"][$i],
						"goals1"=> $_POST["goals1"][$i],
						"goals2"=> $_POST["goals2"][$i],
						"x2"=> $_POST["x2"][$i],
						"x3"=> $_POST["x3"][$i]
					);
					if( $_POST["x2"][$i] == 1 ){
						updateDB("user",array("x2"=>1),"`id` = '{$_POST["userId"]}'");
					}
					if( $_POST["x3"][$i] == 1 ){
						updateDB("user",array("x3"=>1),"`id` = '{$_POST["userId"]}'");
					}
					if ( selectDB("predictions","`userId` = '{$_POST["userId"]}' AND `matchId` = '{$_POST["matchId"][$i]}'") ){
						updateDB("predictions",$dataUpdate,"`userId` = '{$_POST["userId"]}' AND `matchId` = '{$_POST["matchId"][$i]}'");
						$response["match"][]["msg"] = "Updated successfully.";
					}elseif( insertDB("predictions",$dataInsert) ){
						$response["match"][]["msg"] = "Added successfully.";
					}else{
						$response["match"][]["msg"] = "Something wrong happened, please try again.";
					}
				}
				$user = selectDB("user","`id` = '{$_POST["userId"]}'");
				$response["user"] = array(
					"x2" => $user[0]["x2"],
					"x3" => $user[0]["x3"]
				);
				echo outputData($response);die();
			}else{
				$response["msg"] = "no match with this id";
				echo outputError($response);die();
			}
		}else{
			$response["msg"] = "no user with this id";
			echo outputError($response);die();
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