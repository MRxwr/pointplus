<?php
if ( isset($_POST["code"]) && !isset($_POST["edit"]) ){
	$table = "subLeagues";
	insertDB($table,$_POST);
}
if ( isset($_GET["delete"]) ){
	$table = "subLeagues";
	$data = array('status'=>'1');
	$where = "`id` LIKE '".$_GET["delete"]."'";
	updateDB($table,$data,$where);
}
if ( isset($_GET["return"]) ){
	$table = "subLeagues";
	$data = array('status'=>'0');
	$where = "`id` LIKE '".$_GET["return"]."'";
	updateDB($table,$data,$where);
}
if ( isset($_GET["edit"]) ){
	$table = "subLeagues";
	$where = "`id` LIKE '".$_GET["id"]."'";
	$data = selectDB($table,$where);
}

if ( isset($_POST["edit"]) ){
	$table = "subLeagues";
	$where = "`id` LIKE '".$_POST["edit"]."'";
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
<h6 class="panel-title txt-dark">User League Details</h6>
</div>
<div class="clearfix"></div>
</div>
<div class="panel-wrapper collapse in">
<div class="panel-body">
<div class="row">
<div class="col-sm-12 col-xs-12">
<div class="form-wrap">

<form action="?page=userLeagues" method="post" enctype="multipart/form-data">

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Code</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="text" class="form-control" id="exampleInputuname_1" placeholder="Code" name="enTitle" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["code"] ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Title</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="text" class="form-control" id="exampleInputuname_1" placeholder="Title" name="arTitle" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["title"] ?>"<?php }?> required>
</div>
</div>
</div>


<div class="col-md-12">
<button type="submit" class="btn btn-success mr-10">Submit</button>
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
$status 		= array('0','1');
$arrayOfTitles 	= array('Active leagues','Inactive leagues');
$myTable 		= array('myTable1','myTable2');
$panel 			= array('panel-default','panel-danger');
$textColor 		= array('txt-dark','txt-light');
$icon 			= array('fa fa-trash-o','fa fa-refresh');
$action			= array('delete=','return=');

for($i = 0; $i < 2 ; $i++ ){
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
<th>Code</th>
<th>Title</th>
<th>Total</th>
<th>Username</th>
<th>Actions</th>
</tr>
</thead>
<tbody>
<?php
$data= array(
				"select"=>["t1.code","t1.title","t1.total","t1.date","t1.id","t.username","t1.userId"],
				"join" => ["subLeagues"],
				"on" => ["t.id = t1.userId"]
			);
if( $userLeagues = selectJoinDB("user",$data,"t1.status = '{$status[$i]}'") ){
	for( $y = 0; $y < sizeof($userLeagues); $y++ ){
		?>
		<tr>
		<td><?php echo substr($userLeagues[$y]["date"],0,11) ?></td>
		<td><?php echo $userLeagues[$y]["code"] ?></td>
		<td><?php echo $userLeagues[$y]["title"] ?></td>
		<td><?php echo $userLeagues[$y]["total"] ?></td>
		<td><?php echo $userLeagues[$y]["username"] ?></td>
		<td>

		<a href="?page=userLeagues&edit=1&id=<?php echo $userLeagues[$y]["id"] ?>" style="margin:3px"><i class="fa fa-edit"></i></a>

		<a href="?page=userLeagues&<?php echo $action[$i] . $userLeagues[$y]["id"] ?>" style="margin:3px"><i class="<?php echo $icon[$i] ?>"></i></a>

		</td>
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