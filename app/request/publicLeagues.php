<?php
if( $_GET["type"] == "list" ){
    // Pagination parameters
    $page = isset($_GET["page"]) && !empty($_GET["page"]) ? (int)$_GET["page"] : 1;
    $limit = isset($_GET["limit"]) && !empty($_GET["limit"]) ? (int)$_GET["limit"] : 20;
    $offset = ($page - 1) * $limit;
    
    // Get total count of leagues
    $countSql = "SELECT COUNT(*) as total 
                 FROM publicLeagues 
                 WHERE status = '0' AND hidden = '0'";
    $totalResult = queryDB($countSql);
    $totalLeagues = $totalResult ? $totalResult[0]["total"] : 0;
    
    // Check if user is provided to determine join status
    if( isset($_GET["userId"]) && !empty($_GET["userId"]) ){
        // Use custom query with LEFT JOIN to get all leagues with join status
        $sql = "SELECT 
                    pl.id, pl.code, pl.enTitle, pl.arTitle, pl.enDetails, pl.arDetails, 
                    pl.country, pl.logo, pl.coverImage,
                    CASE WHEN jpl.id IS NOT NULL THEN 1 ELSE 0 END as joined
                FROM publicLeagues pl
                LEFT JOIN joinedPublicLeagues jpl ON pl.id = jpl.publicLeagueId AND jpl.userId = '{$_GET["userId"]}'
                WHERE pl.status = '0' AND pl.hidden = '0'
                ORDER BY pl.id DESC
                LIMIT {$limit} OFFSET {$offset}";
        $leagues = queryDB($sql);
    }else{
        // If no userId provided, get leagues with joined field set to false in query
        $sql = "SELECT 
                    id, code, enTitle, arTitle, enDetails, arDetails, 
                    country, logo, coverImage,
                    false as joined
                FROM publicLeagues 
                WHERE status = '0' AND hidden = '0'
                ORDER BY id DESC
                LIMIT {$limit} OFFSET {$offset}";
        
        $leagues = queryDB($sql);
    }
    
    if($leagues){
        $response["leagues"] = array(
            "data" => $leagues,
            "pagination" => array(
                "currentPage" => $page,
                "totalPages" => ceil($totalLeagues / $limit),
                "totalItems" => (int)$totalLeagues,
                "itemsPerPage" => $limit,
                "hasNextPage" => $page < ceil($totalLeagues / $limit),
                "hasPrevPage" => $page > 1
            )
        );
    }else{
        $response["leagues"] = array(
            "data" => array(),
            "pagination" => array(
                "currentPage" => $page,
                "totalPages" => 0,
                "totalItems" => 0,
                "itemsPerPage" => $limit,
                "hasNextPage" => false,
                "hasPrevPage" => false
            )
        );
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
                "publicLeagueId" => $_GET["leagueId"],
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
    if( selectDB("joinedPublicLeagues", "`publicLeagueId` = '{$_GET["leagueId"]}' AND `userId` = '{$_GET["userId"]}'") ){
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
        $league = $league[0];
        // Check if user is joined
        if( isset($_GET["userId"]) && !empty($_GET["userId"]) && selectDB("joinedPublicLeagues", "`userId` = '{$_GET["userId"]}' AND `publicLeagueId` = '{$_GET["leagueId"]}'") ){
            $league["joined"] = 1;
        }else{
            $league["joined"] = 0;
        }        // get all joined users with pagination
        $page = isset($_GET["page"]) && !empty($_GET["page"]) ? (int)$_GET["page"] : 1;
        $limit = isset($_GET["limit"]) && !empty($_GET["limit"]) ? (int)$_GET["limit"] : 20;
        $offset = ($page - 1) * $limit;
        
        // Parse date range if provided
        $startDate = null;
        $endDate = null;
        
        if(isset($_GET["dateRange"]) && !empty($_GET["dateRange"])) {
            // Parse format: "2025-01-10 - 2025-02-10"
            $dateRange = trim($_GET["dateRange"]);
            $dates = explode(" - ", $dateRange);
            
            if(count($dates) == 2) {
                $startDate = trim($dates[0]);
                $endDate = trim($dates[1]);
                
                // Validate date format (basic validation)
                if(!preg_match('/^\d{4}-\d{2}-\d{2}$/', $startDate) || !preg_match('/^\d{4}-\d{2}-\d{2}$/', $endDate)) {
                    $startDate = null;
                    $endDate = null;
                }
            }
        }
        
        // Fallback to individual date parameters if dateRange not provided
        if(!$startDate && isset($_GET["startDate"])) {
            $startDate = $_GET["startDate"];
        }
        if(!$endDate && isset($_GET["endDate"])) {
            $endDate = $_GET["endDate"];
        }
          // Get total count of followers using the new function
        $totalFollowers = getPublicLeagueUsersCount($_GET["leagueId"]);
        
        // Add total followers count to league data
        $league["totalFollowers"] = (int)$totalFollowers;
        
        // Get paginated followers using the new optimized function
        $joinedUsers = getPublicLeagueTopUsers($_GET["leagueId"], $startDate, $endDate, $limit, $offset);
        
        if($joinedUsers){
            $league["followers"] = array(
                "data" => $joinedUsers,
                "pagination" => array(
                    "currentPage" => $page,
                    "totalPages" => ceil($totalFollowers / $limit),
                    "totalItems" => (int)$totalFollowers,
                    "itemsPerPage" => $limit,
                    "hasNextPage" => $page < ceil($totalFollowers / $limit),
                    "hasPrevPage" => $page > 1
                )
            );
        }else{
            $league["followers"] = array(
                "data" => array(),
                "pagination" => array(
                    "currentPage" => $page,
                    "totalPages" => 0,
                    "totalItems" => 0,
                    "itemsPerPage" => $limit,
                    "hasNextPage" => false,
                    "hasPrevPage" => false
                )
            );
        }
        echo outputData($league);
    }else{
        $response["msg"] = "League not found or not available.";
        echo outputError($response);die();
    }
}else{
    $response["msg"] = "Invalid type specified.";
    echo outputError($response);die();
}