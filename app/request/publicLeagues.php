<?php
if( $_GET["type"] == "list" ){
    if( $leagues = selectDataDB("`id`, `code`, `enTitle`, `arTitle`, `enDetails`, `arDetails`, `country`, `logo`,`coverImage`", 'publicLeagues', "`status` = '0' AND `hidden` = '0'") ){
        $response["leagues"] = $leagues;
    }else{
        $response["leagues"] = array();
    }
    echo outputData($response);
}elseif( $_GET["type"] == "join" ){
    if( !isset($_GET["leagueId"]) || empty($_GET["leagueId"]) ){
        $response["msg"] = "Please provide a public league Id.";
        echo outputError($response);die();
    }
    if( !isset($_GET["userId"]) || empty($_GET["userId"]) ){
        $response["msg"] = "Please provide a user ID.";
        echo outputError($response);die();
    }
    if( selectDB("publicLeagues", "`id` = '{$_GET["leagueId"]}' AND `status` = '0' AND `hidden` = '0'") ){
        // Check if user already joined
        if( selectDB("joinedPublicLeagues", "`userId` = '".$_GET["userId"]."' AND `publicLeagueId` = '{$_GET["leagueId"]}'") ){
            $response["msg"] = "You have already joined this league.";
            echo outputError($response);die();
        }else{
            // Insert user into league
            insertDB("joinedPublicLeagues", [
                "userId" => $_GET["userId"],
                "leagueId" => $_GET["leagueId"],
            ]);
            $response["msg"] = "Successfully joined the league.";
            echo outputData($response);
        }
    }else{
        $response["msg"] = "League not found or not available.";
        echo outputError($response);die();
    }
}elseif( $_GET["type"] == "leave" ){
    if( !isset($_GET["leagueId"]) || empty($_GET["leagueId"]) ){
        $response["msg"] = "Please provide a public league code.";
        echo outputError($response);die();
    }
    if( !isset($_GET["userId"]) || empty($_GET["userId"]) ){
        $response["msg"] = "Please provide a user ID.";
        echo outputError($response);die();
    }
    if( selectDB("joinedPublicLeagues", "`id` = '{$_GET["leagueId"]}' AND `userId` = '{$_GET["userId"]}'") ){
        // Remove user from league
        deleteDB("joinedPublicLeagues", "`userId` = '{$_GET["userId"]}' AND `publicLeagueId` = '{$_GET["leagueId"]}'");
        $response["msg"] = "Successfully left the league.";
        echo outputData($response);
    }else{
        $response["msg"] = "League not found or not available.";
        echo outputError($response);die();
    }
}elseif( $_GET["type"] == "view" ){
    if( !isset($_GET["leagueId"]) || empty($_GET["leagueId"]) ){
        $response["msg"] = "Please provide a public league Id.";
        echo outputError($response);die();
    }
    if( $league = selectDataDB("`id`, `code`, `enTitle`, `arTitle`, `enDetails`, `arDetails`, `country`, `logo`,`coverImage`, `enTerms`, `arTerms`", 'publicLeagues', "`id` = '{$_GET["leagueId"]}' AND `status` = '0' AND `hidden` = '0'") ){
        // Check if user is joined
        if( isset($_GET["userId"]) && !empty($_GET["userId"]) && selectDB("joinedPublicLeagues", "`userId` = '{$_GET["userId"]}' AND `publicLeagueId` = '{$_GET["leagueId"]}'") ){
            $league["joined"] = true;
        }else{
            $league["joined"] = false;
        }
        // get all  joined users
        $joinData = array(
            "select" => ["t1.username", "t1.points", "t1.rank","t1.pRank"],
            "join" => ["user"],
            "on" => ["t.userId" => "t1.id"],
        );
        if( $joinedUsers = selectJoinDB('joinedPublicLeagues', $joinData, "t.id = '{$_GET["leagueId"]}'") ){
            $league["followers"] = $joinedUsers;
        }else{
            $league["followers"] = array();
        }
        echo outputData($response);
    }else{
        $response["msg"] = "League not found or not available.";
        echo outputError($response);die();
    }
}else{
    $response["msg"] = "Invalid type specified.";
    echo outputError($response);die();
}