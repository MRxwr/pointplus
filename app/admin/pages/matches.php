<?php
if ( isset($_POST["team1"]) && !isset($_POST["edit"]) ){
	$table = "matches";
	insertDB($table,$_POST);
}
/*
if ( isset($_POST["countdown"]) ){
	$table = "countdown";
	$data = array('status'=>'1
	');
	$where = "`status` = '0'";
	updateUserDB($table,$data,$where);
	insertDB($table,$_POST);
}
	*/
if( isset($_GET["delete"]) || isset($_GET["return"]) || isset($_GET["live"]) || isset($_GET["removeWithoutCalculation"]) ){
	if ( isset($_GET["live"]) ){
		$table = "matches";
		$data = array('status'=>'1');
		$where = "`id` LIKE '".$_GET["live"]."'";
		updateUserDB($table,$data,$where);
	}
	if ( isset($_GET["delete"]) ){
		$table = "matches";
		$data = array('status'=>'2');
		$where = "`id` LIKE '".$_GET["delete"]."'";
		submitCalculatePredictions($_GET["delete"]);
		updateUserDB($table,$data,$where);
	}
	if ( isset($_GET["removeWithoutCalculation"]) ){
		$table = "matches";
		$data = array('status'=>'2');
		$where = "`id` LIKE '".$_GET["removeWithoutCalculation"]."'";
		updateUserDB($table,$data,$where);
	}
	if ( isset($_GET["return"]) ){
		$table = "matches";
		$data = array('status'=>'0');
		$where = "`id` LIKE '".$_GET["return"]."'";
		updateUserDB($table,$data,$where);
	}
	?>
	<script>
		window.location.href = "?page=matches";
	</script>
	<?php
}

if ( isset($_GET["edit"]) ){
	$table = "matches";
	$where = "`id` LIKE '".$_GET["id"]."'";
	$data = selectDB($table,$where);
}

if ( isset($_POST["edit"]) ){
	$table = "matches";
	$where = "`id` LIKE '".$_POST["edit"]."'";
	unset($_POST["edit"]);
	$data = $_POST;
	updateUserDB($table,$data,$where);
}
/*
if ( $countdown = selectDB("countdown","`status` = '0'") ){
	$countdownString = $countdown[0]["countdown"];
	$startTimeString = $countdown[0]["startTime"];
}else{
	$countdownString = "";
	$startTimeString = "";
}
*/
?>

<div class="right-sidebar-backdrop"></div>

<!-- Main Content -->
<div class="page-wrapper">
	<div class="container-fluid pt-25">
		<!-- Row -->
		
		<div class="row">
		
			
<!-- /Title -->
<?php
/*
<div class="row">

<div class="col-md-12">
<div class="panel panel-default card-view">
<div class="panel-heading">
<div class="pull-left">
<h6 class="panel-title txt-dark">Set Countdown</h6>
</div>
<div class="clearfix"></div>
</div>
<div class="panel-wrapper collapse in">
<div class="panel-body">
<div class="row">
<div class="col-sm-12 col-xs-12">
<div class="form-wrap">

<form action="?page=matches" method="post" enctype="multipart/form-data">

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">FROM [<?php echo $startTimeString ?>]</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input name="startTime" class="form-control" type="datetime-local">
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">TO [<?php echo $countdownString ?>]</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input name="countdown" class="form-control" type="datetime-local">
</div>
</div>
</div>

<div class="col-md-12">
<button type="submit" class="btn btn-success mr-10">Submit</button>
</div>

</form>

</div>
</div>
</div>
</div>
</div>
</div>
</div>

</div>
*/
?>

<div class="row">

<div class="col-md-12">
<div class="panel panel-default card-view">
<div class="panel-heading">
<div class="pull-left">
<h6 class="panel-title txt-dark">Match Details</h6>
</div>
<div class="clearfix"></div>
</div>
<div class="panel-wrapper collapse in">
<div class="panel-body">
<div class="row">
<div class="col-sm-12 col-xs-12">
<div class="form-wrap">

<form action="?page=matches" method="post" enctype="multipart/form-data">

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Round</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input name="round" class="form-control" placeholder="round number 5" <?php if(isset($_GET["edit"])){ echo "value='{$data[0]["round"]}'";}else{echo "value=''";} ?> type="number">
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Type</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<select class="form-control" name="type" required>
	<?php
	if ( isset($_GET["edit"]) && $data[0]["type"] == 1 ){
		echo '<option value="1">'.direction("Super","سوبر").'</option>';
		echo '<option value="0">'.direction("Normal","عادية").'</option>';
	}else{
		echo '<option value="0">'.direction("Normal","عادية").'</option>';
		echo '<option value="1">'.direction("Super","سوبر").'</option>';
	}
	?>
</select>
</div>
</div>
</div>	

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">League</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<select class="form-control" name="league" required>
	<?php
	if ( $leagues = selectDB("leagues","`status` = '0'") ){
		if ( isset($_GET["edit"]) && $league = selectDB("leagues","`id` = '{$data[0]["league"]}'") ){
			$leagueName = direction($league[0]["enTitle"],$league[0]["arTitle"]);
			echo "<option value='{$league[0]["id"]}'>{$leagueName}</option>";
		}
		for ( $i = 0; $i < sizeof($leagues); $i++ ){
			$leagueName = direction($leagues[$i]["enTitle"],$leagues[$i]["arTitle"]);
			echo "<option value='{$leagues[$i]["id"]}'>{$leagueName}</option>";
		}
	}else{
		echo '<option value="0">No Leagues Available</option>';
	}
	?>
</select>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">FROM</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input name="startTime" class="form-control" <?php if(isset($_GET["edit"])){ echo "value='{$data[0]["startTime"]}'";}else{echo "value=''";} ?> type="datetime-local">
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">TO</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input name="countdown" class="form-control" <?php if(isset($_GET["edit"])){ echo "value='{$data[0]["countdown"]}'";}else{echo "value=''";} ?> type="datetime-local">

</div>
</div>
</div>

<div class="col-md-3">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Active?</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
	<select class="form-control" name="isActive" required>
		<?php
		$isActiveValue = [0,1];
		$isActiveText = [direction("Ended","إنتهى"),direction("Active","فعال")];
		for( $i = 0; $i < sizeof($isActiveText); $i++){
			$isActiveSelected = ( $data[0]["isActive"] == $i ) ? "selected" : "";
			echo "<option value='{$isActiveValue[$i]}' {$isActiveSelected}>{$isActiveText[$i]}</option>";
		}
		?>
	</select>
</div>
</div>
</div>	

<div class="col-md-3">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Staduim</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
	<input name="staduim" class="form-control" placeholder="Staduim Name" <?php if(isset($_GET["edit"])){ echo "value='{$data[0]["staduim"]}'";}else{echo "value=''";} ?> type="text">
</div>
</div>
</div>	

<div class="col-md-3">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Date</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
	<input name="matchDate" class="form-control" <?php if(isset($_GET["edit"])){ echo "value='{$data[0]["matchDate"]}'";}else{echo "value=''";} ?> type="date">
</div>
</div>
</div>	

<div class="col-md-3">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Time</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
	<input name="matchTime" class="form-control" placeholder="04:00pm GMT+3" <?php if(isset($_GET["edit"])){ echo "value='{$data[0]["matchTime"]}'";}else{echo "value=''";} ?> type="text">
</div>
</div>
</div>	

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Team 1</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<select class="form-control" name="team1" required>
	<?php
	if ( $teams = selectDB("teams","`status` = '0' ORDER BY `leagueId` ASC") ){
		if ( isset($_GET["edit"]) && $team = selectDB("teams","`id` = '{$data[0]["team1"]}'") ){
			$teamName = direction($team[0]["enTitle"],$team[0]["arTitle"]);
			echo "<option value='{$team[0]["id"]}'>{$teamName}</option>";
		}
		for ( $i = 0; $i < sizeof($teams); $i++ ){
			$teamName = direction($teams[$i]["enTitle"],$teams[$i]["arTitle"]);
			echo "<option value='{$teams[$i]["id"]}'>{$teamName}</option>";
		}
	}else{
		echo '<option value="0">No Teams Available</option>';
	}
	?>
</select>
</div>
</div>
</div>	

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Team 2</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<select class="form-control" name="team2" required>
	<?php
	if ( $teams = selectDB("teams","`status` = '0' ORDER BY `leagueId` ASC") ){
		if ( isset($_GET["edit"]) && $team = selectDB("teams","`id` = '{$data[0]["team2"]}'") ){
			$teamName = direction($team[0]["enTitle"],$team[0]["arTitle"]);
			echo "<option value='{$team[0]["id"]}'>{$teamName}</option>";
		}
		for ( $i = 0; $i < sizeof($teams); $i++ ){
			$teamName = direction($teams[$i]["enTitle"],$teams[$i]["arTitle"]);
			echo "<option value='{$teams[$i]["id"]}'>{$teamName}</option>";
		}
	}else{
		echo '<option value="0">No Teams Available</option>';
	}
	?>
</select>
</div>
</div>
</div>

<?php if(isset($_GET["edit"])){?>


<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Goals Team 1</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input name="goals1" class="form-control" placeholder="Number of goals" <?php if(isset($_GET["edit"])){ echo "value='{$data[0]["goals1"]}'";}else{echo "value=''";} ?> type="number">
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Goals Team 2 </label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input name="goals2" class="form-control" placeholder="Number of goals" <?php if(isset($_GET["edit"])){ echo "value='{$data[0]["goals2"]}'";}else{echo "value=''";} ?> type="number">
</div>
</div>
</div>


<?php }?>

<div class="col-md-12">
<button type="submit" class="btn btn-success mr-10">Submit</button>
<input type="hidden" name="status" <?php if(isset($_GET["edit"])){ echo "value='{$data[0]["status"]}'";}else{echo "value='0'";} ?>>
<input type="hidden" name="date" value="<?php echo $date ?>">
<?php if(isset($_GET["edit"])){?>
<input type="hidden" name="edit" value="<?php echo $_GET["id"] ?>">
<?php }?>
</div>

</form>

</div>
</div>
</div>
</div>
</div>
</div>
</div>

</div>

<!-- Row -->
<?php
if ( !isset($_GET["edit"]) ){
$status 		= array('0','1','2');
$arrayOfTitles 	= array('Pending matches','Active matches','Inactive matches');
$myTable 		= array('myTable3','myTable1','myTable2');
$panel 			= array('panel-warning','panel-default','panel-danger');
$textColor 		= array('txt-dark','txt-dark','txt-light');
$icon 			= array('fa fa-thumbs-up','fa fa-trash-o','fa fa-refresh');
$action			= array('live=','delete=','return=');
$actionMsg      = array(
	direction('Are you sure you want to activate this match?', 'هل تريد بالتاكيد تفعيل هذخ المباراة؟'),
	direction('Are you sure you want to submit this match?', 'هل تريد بالتاكيد حساب هذه المباراة؟'),
	direction('Are you sure you want to re-submit this match?', 'هل تريد بالتاكيد اعادة هذه المباراة؟')
	);

for($i = 0; $i < sizeof($status) ; $i++ ){
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
<th>Staduim</th>
<th>Date</th>
<th>Time</th>
<th>Active?</th>
<th>Type</th>
<th>Actions</th>
</tr>
</thead>
<tbody>
<?php
$sql = "SELECT 
		t1.enTitle as t1enTitle, t1.arTitle as t1arTitle,
		t2.enTitle as t2enTitle, t2.arTitle as t2arTitle,
		l.enTitle as lenTitle, l.arTitle as larTitle, m.*
		FROM `matches` as m
		JOIN `teams` as t1
		ON t1.id = m.team1
		JOIN `teams` as t2
		ON t2.id = m.team2
		JOIN `leagues` as l
		ON l.id = m.league
		WHERE
		m.status = '".$status[$i]."'
		ORDER BY m.id ASC
		";
$result = $dbconnect->query($sql);
while ( $row = $result->fetch_assoc() ){
	$leagueTitle  = direction($row["lenTitle"],$row["larTitle"]);
	$team1Name  = direction($row["t1enTitle"],$row["t1arTitle"]);
	$team2Name  = direction($row["t2enTitle"],$row["t2arTitle"]);
	$isActive = ( $row["isActive"] == 0 ) ? "Ended" : "Active";
	if ( $row["type"] == 0 ){
		$type = direction("Normal","عادية");
	}else{
		$type = direction("Super","سوبر");
	}
?>
<tr>
<td><?php echo $row["round"] ?></td>
<td><?php echo $leagueTitle ?></td>
<td><?php echo $team1Name ?></td>
<td><?php echo $team2Name ?></td>
<td><?php echo $row["goals1"] . " - " . $row["goals2"]?></td>
<td><?php echo $row["staduim"] ?></td>
<td><?php echo $row["matchDate"] ?></td>
<td><?php echo $row["matchTime"] ?></td>
<td><?php echo $isActive ?></td>
<td><?php echo $type ?></td>
<td>

<a href="?page=matches&edit=1&id=<?php echo $row["id"] ?>" style="margin:3px"><i class="fa fa-edit"></i></a>

<?php 
if( $row["status"] != "2"){
	$removeMatchMsg = direction("Are you sure you want to remove this match without calculation?", "هل تريد بالتاكيد حذف هذه المباراة بدون حساب؟");
	$removeJS = "return confirm('".$removeMatchMsg."')";
	echo "<a href='?page=matches&removeWithoutCalculation={$row["id"]}' style='margin:3px; color:red' onclick='{$removeJS}'><i class='fa fa-ban'></i></a>";
}
?>
<a href="?page=matches&<?php echo $action[$i] . $row["id"] ?>" style="margin:3px" onclick="return confirm('<?php echo $actionMsg[$i] ?>')"><i class="<?php echo $icon[$i] ?>"></i></a>

</td>
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