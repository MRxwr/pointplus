<?php
//get address
if ( isset($_GET["type"]) ){
	if ( $banners = selectDataDB("`id`, `enTitle`, `arTitle`, `image`, `url`, `type`",'banners',"`status` LIKE '1'") ){
		$response["banners"] = $banners;
	}else{
		$response["banners"] = array();
	}
	if ( $_GET["type"] == "list" ){
		if ( isset($_GET["userId"]) AND !empty($_GET["userId"]) ){
			$data= array(
				"select"=>["t2.id","t1.rank","t.points","t2.title","t1.rank as subLeagRank","t1.pRank as subLeagPRank"],
				"join" => ["joinedLeagues","subLeagues"],
				"on" => [" t.id = t1.userId"," t1.leagueId = t2.id"]
			);
			if( $leagues = selectJoinDB('user',$data,"t.id = '{$_GET["userId"]}'") ){
				$response["leagues"] = $leagues;
			}else{
				$response["leagues"]["msg"] = "You have not joined any league yet.";
			}
			$dataSubLeagues= array(
				"select"=>["t1.id","t1.code","t1.title","t1.userId"],
				"join" => ["subLeagues"],
				"on" => ["t.id = t1.userId"]
			);
			if( $leagues = selectJoinDB('user',$dataSubLeagues,"t.id = '{$_GET["userId"]}'") ){
				$response["create"] = $leagues;
			}else{
				$response["create"]["msg"] = "You have not created any league yet.";
			}
			if( $user = selectDataDB("`id`,`rank`,`points`",'user',"`id` = '{$_GET["userId"]}'") ){
				$response["user"] = $user;
			}
			echo outputData($response);
		}else{
			$response["msg"] = "Please enter user Id";
			echo outputError($response);die();
		}
	}elseif( $_GET["type"] == "create" ){
		if( !isset($_POST["userId"]) || empty($_POST["userId"]) ){
			$response["msg"] = "Please enter user Id";
			echo outputError($response);die();
		}
		if( !isset($_POST["title"]) || empty($_POST["title"]) ){
			$response["msg"] = "Please enter title";
			echo outputError($response);die();
		}elseif( selectDB("subLeagues","`title` LIKE '{$_POST["title"]}'") ){
			//$response["msg"] = "There is a league with this name.";
			//echo outputError($response);die();
		}
		$_POST["code"] = randomCode();
		if ( insertDB("subLeagues",$_POST) ){
			$league = selectDataDB("`id`, `title`, `code`","subLeagues","`code` LIKE '{$_POST["code"]}'");
			$response["league"] = $league;
			echo outputData($response);
		}else{
			$response["msg"] = "something wrong happened. please try again.";
			echo outputError($response);die();
		}
	}elseif( $_GET["type"] == "join" ){
		if( !isset($_POST["userId"]) || empty($_POST["userId"]) ){
			$response["msg"] = "Please enter user Id";
			echo outputError($response);die();
		}
		if( !isset($_POST["code"]) || empty($_POST["code"]) ){
			$response["msg"] = "Please enter title";
			echo outputError($response);die();
		}elseif( $leagueId = selectDataDB("`id`", "subLeagues","`code` LIKE '{$_POST["code"]}'") ){
			if ( selectDB("joinedLeagues","`leagueId` = '{$leagueId[0]["id"]}' AND `userId` = '{$_POST["userId"]}'") ){
				$response["msg"] = "You are already joined to this league.";
				echo outputError($response);die();
			}else{
				$_POST["leagueId"] = $leagueId[0]["id"];
				$code = $_POST["code"];
				unset($_POST["code"]);
			}
		}else{
			$response["msg"] = "There no league with this code.";
			echo outputError($response);die();
		}
		
		if ( insertDB("joinedLeagues",$_POST) ){
			$league = selectDataDB("`id`, `title`, `code`","subLeagues","`code` LIKE '{$code}'");
			$response["league"] = $league;
			$response["msg"] = "Joined successfully.";
			echo outputData($response);
		}else{
			$response["msg"] = "something wrong happened. please try again.";
			echo outputError($response);die();
		}
	}elseif( $_GET["type"] == "view" ){
		if( $league = selectDataDB("`code`,`title`,`total`","subLeagues","`id` = '{$_GET["leagueId"]}'") ){
			$response["league"][0]["code"] = $league[0]["code"];
			$response["league"][0]["title"] = " {$league[0]["title"]}";
			$response["league"][0]["total"] = $league[0]["total"];
		}else{
			$response["league"][0]["code"] = "";
			$response["league"][0]["title"] = "";
			$response["league"][0]["total"] = "";
		}
		
		if( !isset($_GET["leagueId"]) || empty($_GET["leagueId"]) ){
			if( $users = selectDataDB("`name`,`username`,`points`,`rank`, `pRank`","user","`status` = '0' AND `type` = '2' ORDER BY (rank = 0 ), `rank` ASC LIMIT 30") ){
				$response["users"] = $users;
				echo outputData($response);
			}else{
				$response["users"] = array();
				$response["msg"] = "No users found";
				echo outputError($response);die();
			}
		}else{
			if( isset($_GET["lastGw"]) && !empty($_GET["lastGw"]) ){
				$data = array(
					"select"=>["t.name","t.username","t.pPoints as points","t1.rank","t1.pRank"],
					"join"=>["joinedLeagues"],
					"on"=>["t.id = t1.userId"]
				);
				if( $joinedUsers = selectJoinDB("user",$data,"t1.leagueId = '{$_GET["leagueId"]}' ORDER BY (t1.pRank = 0), t1.pRank ASC") ){
					$response["users"] = $joinedUsers;
					echo outputData($response);
				}else{
					$response["users"] = array();
					$response["msg"] = "No users found";
					echo outputError($response);die();
				}
			}else{
				$data = array(
					"select"=>["t.name","t.username","t.points","t1.rank","t1.pRank"],
					"join"=>["joinedLeagues"],
					"on"=>["t.id = t1.userId"]
				);
				if( $joinedUsers = selectJoinDB("user",$data,"t1.leagueId = '{$_GET["leagueId"]}' ORDER BY (t1.rank = 0), t1.rank ASC") ){
					$response["users"] = $joinedUsers;
					echo outputData($response);
				}else{
					$response["users"] = array();
					$response["msg"] = "No users found";
					echo outputError($response);die();
				}
			}
		}
	}else{
		$response["msg"] = "Wrong type, 'list' or 'add' or 'edit'";
		echo outputError($response);die();
	}
}else{
	$response["msg"] = "Please enter type of operation.";
	echo outputError($response);die();
}
?>