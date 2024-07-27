<?php

if( isset($_POST["submit"]) ){
	$updateData = array(
		"pRank" => "`rank`"
	);
	$settings = selectDB("settings","`id` = '1'");
	if( updatePredictionDB("user",$updateData,"`id` > '0' ") && updatePredictionDB("joinedLeagues",$updateData,"`id` > '0' ") ){
		if( $matches = selectDB("matches","`status` = '1'") ){
			//update user points
			updatePredictionDB("user",array("pPoints"=>"0"),"`id` != '0'");
			for ( $i =0; $i < sizeof($matches); $i++ ){
				$realResult = [$matches[$i]["goals1"],$matches[$i]["goals2"]];
				if( $prediction = selectDB("predictions","`matchId` = '{$matches[$i]["id"]}' AND `status` = '0'") ){
					for( $y =0; $y < sizeof($prediction); $y++ ){
						$points = 0;
						$predictionResult = [$prediction[$y]["goals1"],$prediction[$y]["goals2"]];
						
						//check match result
						if( $predictionResult[0] == $realResult[0] && $predictionResult[1] == $realResult[1] ){
							$points = $points + 5;
						}
						
						//check match winner
						if( $predictionResult[0] > $predictionResult[1] &&  $realResult[0] > $realResult[1] ){
							$points = $points + 5;
						}elseif( $predictionResult[0] < $predictionResult[1] &&  $realResult[0] < $realResult[1] ){
							$points = $points + 5;
						}elseif( $predictionResult[0] == $predictionResult[1] &&  $realResult[0] == $realResult[1] ){
							$points = $points + 5;
						}
						
						//for super match multiply * 2 if no x3 availble and multiply by * 3 if x3 is set 
						if( $matches[$i]["type"] == 1 ){
							if( $prediction[$y]["x3"] == 1 ){
								$points = $points * $settings[0]["x3"];
								updatePredictionDB("user",array("x3"=>1),"`id` = '{$prediction[$y]["userId"]}'");
							}else{
								$points = $points * $settings[0]["x2"];
							}
						}
						
						//x2 
						if( $prediction[$y]["x2"] == 1 ){
							$points = $points * $settings[0]["x2"];
							updatePredictionDB("user",array("x2"=>1),"`id` = '{$prediction[$y]["userId"]}'");
						}
						
						//update predictions table
						updatePredictionDB("predictions",array("counted"=>1,"points"=>$points,"status"=>1),"`id` = '{$prediction[$y]["id"]}'");
						
						//update user points
						updatePredictionDB("user",array("pPoints"=>"`pPoints` + {$points}"),"`id` = '{$prediction[$y]["userId"]}'");

						//update user points
						updatePredictionDB("user",array("points"=>"`points` + {$points}"),"`id` = '{$prediction[$y]["userId"]}'");
					}
					updatePredictionDB("matches",array("status"=>2),"`id` = '{$matches[$i]["id"]}'");
				}
			}
		}
		
	}
	$sql = "UPDATE `user` u
			JOIN
			(
				 SELECT id, (@rownumber := @rownumber + 1) AS rownum
				 FROM `user`         
				 CROSS JOIN (select @rownumber := 0) r
				 WHERE status = '0'
				 ORDER BY `points` DESC
			) AS newRow ON u.id = newRow.id    
			SET `rank` = rownum
			";
	$dbconnect->query($sql);
	$sql = "UPDATE `joinedLeagues` as jl
			JOIN `user` as u ON u.id = jl.userId
			SET jl.rank = u.rank
			WHERE u.id = jl.userId
			";
	$dbconnect->query($sql);
	if( $leagues = selectDB("subLeagues","`status` = '0'") ){
		for($i = 0; $i < sizeof($leagues); $i++ ){
			$sql = "UPDATE `joinedLeagues` u
					JOIN
					(
						 SELECT userId, (@rownumber := @rownumber + 1) AS rownum
						 FROM `joinedLeagues`         
						 CROSS JOIN (select @rownumber := 0) r
						 WHERE `leagueId` = '{$leagues[$i]["id"]}'
						 ORDER BY `rank` ASC
					) AS newRow ON u.userId = newRow.userId    
					SET `rank` = rownum
					WHERE `leagueId` = '{$leagues[$i]["id"]}'
					";
			$dbconnect->query($sql);
		}
	}
}

?>

<div class="right-sidebar-backdrop"></div>

<!-- Main Content -->
<div class="page-wrapper">
	<div class="container-fluid pt-25">
		<!-- Row -->
		
		<div class="row">
		
			<div class='col-12 ' style="background: white;border: 1px solid lightgray;margin: 10px;text-align: center;padding: 10px;border-radius: 10px;">
			<form method="POST" action="">
				<button class="btn btn-primary" name="submit">Submit Predictions</button>
			</form>
			</div>
<!-- /Title -->

<!-- Row -->
<?php
if ( !isset($_GET["edit"]) ){
$status 		= array('0','1');
$arrayOfTitles 	= array('Pending Predictions','Counted Predictions');
$myTable 		= array('myTable1','myTable2');
$panel 			= array('panel-default','panel-primary');
$textColor 		= array('txt-dark','txt-light');
$icon 			= array('fa fa-trash-o','fa fa-refresh');
$action			= array('delete=','return=');

for($i = 0; $i < 1 ; $i++ ){
?>

<div class="row">
<div class="col-sm-12">
<div class="panel <?php echo $panel[$i] ?> card-view">
<div class="panel-heading">
<div class="pull-left">
<h6 class="panel-title <?php echo $textColor[$i] ?>"><?php echo $arrayOfTitles[$i] ?></h6>
</div>
<div class="clearfix"></div>
</div>
<div class="panel-wrapper collapse in">
<div class="panel-body">
<div class="table-wrap">
<div class="">

<table id="<?php echo $myTable[$i] ?>" class="table table-hover display  pb-30" >
<thead>
<tr>
<th>Round</th>
<th>League</th>
<th>Team 1</th>
<th>Team 2</th>
<th>Result</th>
<th>X2</th>
<th>X3</th>
<th>Prediction</th>
<th>User</th>
</tr>
</thead>
<tbody>
<?php
$sql = "SELECT 
		t1.enTitle as t1enTitle,
		t1.arTitle as t1arTitle,
		t2.enTitle as t2enTitle,
		t2.arTitle as t2arTitle,
		l.enTitle as lenTitle,
		l.arTitle as larTitle,
		m.*,
		p.goals1 as pGoals1,
		p.goals2 as pGoals2,
		p.x2 as predX2,
		p.x3 as predX3,
		u.username
		FROM `predictions` as p
		JOIN `matches` as m
		ON m.id = p.matchId
		JOIN `user` as u
		ON u.id = p.userId
		JOIN `teams` as t1
		ON t1.id = m.team1
		JOIN `teams` as t2
		ON t2.id = m.team2
		JOIN `leagues` as l
		ON l.id = m.league
		WHERE
		p.status = '".$status[$i]."'
		ORDER BY m.id ASC
		";
$result = $dbconnect->query($sql);
while ( $row = $result->fetch_assoc() ){
	$leagueTitle  = direction($row["lenTitle"],$row["larTitle"]);
	$team1Name  = direction($row["t1enTitle"],$row["t1arTitle"]);
	$team2Name  = direction($row["t2enTitle"],$row["t2arTitle"]);
	$x2 = ( $row["predX2"] == 1 ) ? direction("USED","مستخدم") : "-" ;
	$x3 = ( $row["predX3"] == 1 ) ? direction("USED","مستخدم") : "-" ;
?>
<tr>
<td><?php echo "Round" . $row["round"] ?></td>
<td><?php echo $leagueTitle ?></td>
<td><?php echo $team1Name ?></td>
<td><?php echo $team2Name ?></td>
<td><?php echo $row["goals1"] . " - " . $row["goals2"]?></td>
<td><?php echo $x2 ?></td>
<td><?php echo $x3 ?></td>
<td><?php echo $row["pGoals1"] . " - " . $row["pGoals2"]?></td>
<td><?php echo $row["username"] ?></td>
</tr>
<?php
}
?>
</tbody>
</table>

</div>
</div>
</div>
</div>
</div>	
</div>
</div>
<?php
}
}
?>		
		</div>
		
		<!-- /Row -->
	</div>

<!-- Footer -->
	<footer class="footer container-fluid pl-30 pr-30">
		<div class="row">
			<div class="col-sm-12">
				<p>2021 &copy; Create Co.</p>
			</div>
		</div>
	</footer>
	<!-- /Footer -->
	
</div>
<!-- /Main Content -->