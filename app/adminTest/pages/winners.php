<?php
if ( isset($_POST["winner1"]) ){
	$table = "user";
	
	$where = "`id` != '0'";
	$data = array("winner" => 0);
	updateUserDB($table,$data,$where);
	
	$where = "`id` = '{$_POST["winner1"]}'";
	$data = array("winner" => 1);
	updateUserDB($table,$data,$where);
	
	$where = "`id` = '{$_POST["winner2"]}'";
	$data = array("winner" => 2);
	updateUserDB($table,$data,$where);

	header("LOCATION: ?page=winners");
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
<h6 class="panel-title txt-dark">Set Winners</h6>
</div>
<div class="clearfix"></div>
</div>
<div class="panel-wrapper collapse in">
<div class="panel-body">
<div class="row">
<div class="col-sm-12 col-xs-12">
<div class="form-wrap">

<form action="?page=winners" method="post" enctype="multipart/form-data">

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputEmail_1">Winner [1]</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-trophy"></i></div>
<select class="form-control" name="winner1">
	<?php
	if( $users = selectDataDB("`id`, `username`, `winner`","user","`status` = '0' AND `type` = '2' ORDER BY `username` ASC") ){
		for( $i = 0; $i < sizeof($users); $i++ ){
			if( $users[$i]["winner"] == 1 ){
				echo "<option value='{$users[$i]["id"]}' selected>{$users[$i]["username"]}</option>";
			}else{
				echo "<option value='{$users[$i]["id"]}'>{$users[$i]["username"]}</option>";
			}
		}
	}
	?>
</select>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputEmail_1">Winner [2]</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-trophy"></i></div>
<select class="form-control" name="winner2">
	<?php
	if( $users = selectDataDB("`id`, `username`, `winner`","user","`status` = '0' AND `type` = '2' ORDER BY `username` ASC") ){
		for( $i = 0; $i < sizeof($users); $i++ ){
			if( $users[$i]["winner"] == 2 ){
				echo "<option value='{$users[$i]["id"]}' selected>{$users[$i]["username"]}</option>";
			}else{
				echo "<option value='{$users[$i]["id"]}'>{$users[$i]["username"]}</option>";
			}
		}
	}
	?>
</select>
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