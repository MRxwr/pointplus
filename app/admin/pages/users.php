<?php
if ( isset($_POST["name"]) && !isset($_POST["edit"]) ){
	$table = "user";
	$_POST["password"] = sha1($_POST["password"]);
	insertDB($table,$_POST);
}
if ( isset($_GET["delete"]) ){
	$table = "user";
	$data = array('status'=>'1');
	$where = "`id` LIKE '".$_GET["delete"]."'";
	updateDB($table,$data,$where);
}
if ( isset($_GET["return"]) ){
	$table = "user";
	$data = array('status'=>'0');
	$where = "`id` LIKE '".$_GET["return"]."'";
	updateDB($table,$data,$where);
}
if ( isset($_GET["edit"]) ){
	$table = "user";
	$where = "`id` LIKE '".$_GET["userId"]."'";
	$data = selectDB($table,$where);
}

if ( isset($_POST["edit"]) ){
	$table = "user";
	$where = "`id` LIKE '".$_POST["edit"]."'";
	if ( !empty($_POST["password"]) ){
		$_POST["password"] = sha1($_POST["password"]);
	}else{
		unset($_POST["password"]);
	}
	unset($_POST["edit"]);
	$data = $_POST;
	updateDB($table,$data,$where);
}
?>

<div class="right-sidebar-backdrop"></div>

<!-- Main Content -->
<div class="page-wrapper">
	<div class="container-fluid pt-25">
		<!-- Row -->
		
		<div class="row">
		
			
<!-- /Title -->

<div class="row">

<div class="col-md-12">
<div class="panel panel-default card-view">
<div class="panel-heading">
<div class="pull-left">
<h6 class="panel-title txt-dark">User Details</h6>
</div>
<div class="clearfix"></div>
</div>
<div class="panel-wrapper collapse in">
<div class="panel-body">
<div class="row">
<div class="col-sm-12 col-xs-12">
<div class="form-wrap">

<form action="?page=users" method="post" enctype="multipart/form-data">

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Name</label>
<div class="input-group">
<div class="input-group-addon"><i class="icon-user"></i></div>
<input type="text" class="form-control" id="exampleInputuname_1" placeholder="Full Name" name="name" <?php if(isset($_GET["edit"])){ echo 'value="'.$data[0]["name"].'"'; } ?> >
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">username</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-institution"></i></div>
<input type="text" class="form-control" id="exampleInputuname_1" placeholder="Enter username" name="username" <?php if(isset($_GET["edit"])){ echo 'value="'.$data[0]["username"].'"'; } ?> >
</div>
</div>
</div>	

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputpwd_1">password</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-lock"></i></div>
<input type="password" class="form-control" id="exampleInputpwd_1" placeholder="Enter password" name="password">
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputEmail_1">Email address</label>
<div class="input-group">
<div class="input-group-addon"><i class="icon-envelope-open"></i></div>
<input type="email" class="form-control" id="exampleInputEmail_1" placeholder="Enter email" name="email" <?php if(isset($_GET["edit"])){ echo 'value="'.$data[0]["email"].'"'; } ?> >
</div>
</div>
</div>	

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputEmail_1">Mobile</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-phone"></i></div>
<input type="text" class="form-control" id="exampleInputEmail_1" placeholder="Enter phone" name="mobile" <?php if(isset($_GET["edit"])){ echo 'value="'.$data[0]["mobile"].'"'; } ?> >
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputEmail_1">Country</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-phone"></i></div>
<input type="text" class="form-control" id="exampleInputEmail_1" placeholder="Enter phone" name="country" <?php if(isset($_GET["edit"])){ echo 'value="'.$data[0]["country"].'"'; } ?> >
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputEmail_1">Team Name</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-phone"></i></div>
<input type="text" class="form-control" id="exampleInputEmail_1" placeholder="Enter phone" name="team" <?php if(isset($_GET["edit"])){ echo 'value="'.$data[0]["team"].'"'; } ?> >
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputEmail_1">Chosen Team</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-phone"></i></div>
<input type="text" class="form-control" id="exampleInputEmail_1" placeholder="Enter phone" name="favoTeam" <?php if(isset($_GET["edit"])){ echo 'value="'.$data[0]["favoTeam"].'"'; } ?> >
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputEmail_1">Points</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-phone"></i></div>
<input type="number" class="form-control" id="exampleInputEmail_1" placeholder="Enter total points" name="points" <?php if(isset($_GET["edit"])){ echo 'value="'.$data[0]["points"].'"'; } ?> >
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputEmail_1">Coins</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-phone"></i></div>
<input type="number" class="form-control" id="exampleInputEmail_1" placeholder="Enter total coins" name="coins" <?php if(isset($_GET["edit"])){ echo 'value="'.$data[0]["coins"].'"'; } ?> >
</div>
</div>
</div>	

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputEmail_1">Birthday</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-phone"></i></div>
<input type="date" class="form-control" id="exampleInputEmail_1" placeholder="date" name="birthday" <?php if(isset($_GET["edit"])){ echo 'value="'.$data[0]["birthday"].'"'; } ?> >
</div>
</div>
</div>			

<div class="col-md-12">
<button type="submit" class="btn btn-success mr-10">Submit</button>
<input type="hidden" name="userId" value="<?php echo $userId ?>">
<input type="hidden" name="date" value="<?php echo $date ?>">
<input type="hidden" name="type" value="2">
<?php
if ( isset($_GET["edit"]) ){
?>
	<input type="hidden" name="edit" value="<?php echo $_GET["userId"] ?>">
<?php
}
?>

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
$status 		= array('0','1');
$arrayOfTitles 	= array('Current Users','Banned Users');
$myTable 		= array('myTable1','myTable2');
$panel 			= array('panel-default','panel-danger');
$textColor 		= array('txt-dark','txt-light');
$icon 			= array('fa fa-trash-o','fa fa-refresh');
$action			= array('delete=','return=');

for($i = 0; $i < 1 ; $i++ ){
	if ( !isset($_GET["edit"]) ){
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
<th>Date</th>
<th>Username</th>
<th>Name</th>
<th>Email</th>
<th>Mobile</th>
<th>Country</th>
<th>Team Name</th>
<th>Chosen Team</th>
<th>Birthday</th>
<th>Points</th>
<th>Rank</th>
<th>Coins</th>
<th>Actions</th>
</tr>
</thead>
<tbody>
<?php
$sql = "SELECT u.*, t.enTitle , t.arTitle
		FROM `user` as u
		JOIN `teams` as t
		ON u.favoTeam = t.id
		WHERE
		u.status = '".$status[$i]."'
		AND 
		u.type = '2'
		GROUP BY u.id
		";
$result = $dbconnect->query($sql);
while ( $row = $result->fetch_assoc() ){
	$favoTeam = direction($row["enTitle"],$row["arTitle"]);
?>
<tr>
<td><?php echo substr($row["date"],0,11) ?></td>
<td><?php echo $row["username"] ?></td>
<td><?php echo $row["name"] ?></td>
<td><a href="mailto:<?php echo $row["email"] ?>">Email</a></td>
<td><a href="tel:<?php echo $row["mobile"] ?>">call</a></td>
<td><?php echo $row["country"] ?></td>
<td><?php echo $row["team"] ?></td>
<td><?php echo $favoTeam ?></td>
<td><?php echo substr($row["birthday"],0,10) ?></td>
<td><?php echo $row["points"] ?></td>
<td><?php echo $row["rank"] ?></td>
<td><?php echo $row["coins"] ?></td>
<td>

<a href="?page=users&edit=1&userId=<?php echo $row["id"] ?>" style="margin:3px"><i class="fa fa-edit"></i></a>

<a href="?page=users&<?php echo $action[$i] . $row["id"] ?>" style="margin:3px"><i class="<?php echo $icon[$i] ?>"></i></a>

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
	}else{
		
		?>
		<div class="row">
		<div class="col-sm-12">
		<div class="panel <?php echo $panel[$i] ?> card-view">
		<div class="panel-heading">
		<div class="pull-left">
		<h6 class="panel-title <?php echo $textColor[$i] ?>"><?php echo "Points Redeeming History" ?></h6>
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
		<th>Date</th>
		<th>Points</th>
		<th>Coins</th>
		<th>Redeemded Points</th>
		<th>Collected Coins</th>
		</tr>
		</thead>
		<tbody>
		<?php
		if ( $history = selectDB("coins_history", "`userId` = '{$_GET['userId']}'") ){
			for ( $u = 0; $u < sizeof($history); $u++ ){
		?>
		<tr>
		<td><?php echo substr($history[$u]["date"],0,11) ?></td>
		<td><?php echo $history[$u]["oldPoints"] ?></td>
		<td><?php echo $history[$u]["oldCoins"] ?></td>
		<td><?php echo $history[$u]["redeemedPoints"] ?></td>
		<td><?php echo $history[$u]["newCoins"] ?></td>
		</tr>
		<?php
			}
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