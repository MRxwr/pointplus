<?php
if ( isset($_POST["edit"]) ){
	//print_r($_POST);die();
	$table = "settings";
	$where = "`id` = '1'";
	unset($_POST["edit"]);
	unset($_POST["date"]);
	$data = $_POST;
	updateUserDB($table,$data,$where);
	$data = selectDB($table,$where);
}

if( isset($_POST["resetData"]) ){
	
	$table = "user";
	$data = array(
		"points" => 0,
		"pPoints" => 0,
		"redeemedPoints" => 0,
		"rank" => 0,
		"pRank" => 0,
		"winner" => 0,
		"x2" => 0,
		"x3" => 0
	);
	$where = "`id` != '1'";
	updateUserDB($table,$data,$where);
	
	$table = "predictions";
	$where = "0";
	deleteDB($table,$where);
	
	$table = "matches";
	$where = "0";
	deleteDB($table,$where);
	
	$table = "countdown";
	$where = "0";
	deleteDB($table,$where);
}

if ( isset($_GET["edit"]) ){
	$table = "settings";
	$where = "`id` = '1'";
	$data = selectDB($table,$where);
}else{
	die();
}
/*
if( $getRoundMatches = selectDB("matches","`status` = '0' ORDER BY `round` DESC") ){
	if( $getMatchesId = selectDB("matches","`round` = '{$getRoundMatches[0]["round"]}'") ){
		for( $i = 0 ; $i < sizeof($getMatchesId); $i++ ){
			if( $users = selectDB("user","`id` != '0'")){
				for( $y = 0; $y < sizeof($users); $y++ ){
					if( $predictions = selectDB("predictions","`userId` = '{$users[$y]["id"]}' AND `matchId` = {$getMatchesId[$i]["id"]}") ){
						updatePredictionDB("user",array("pPoints" => "`pPoints` + {$predictions[0]["points"]}"),"`id` = '{$users[$y]["id"]}'");
					}
				}
			}
		}
	}
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

<div class="row">

<div class="col-md-12">
<div class="panel panel-default card-view">
<div class="panel-heading">
<div class="pull-left">
<h6 class="panel-title txt-dark">Settings</h6>
</div>
<div class="clearfix"></div>
</div>
<div class="panel-wrapper collapse in">
<div class="panel-body">
<div class="row">
<div class="col-sm-12 col-xs-12">
<div class="form-wrap">

<form action="?page=settings&edit=1" method="post" enctype="multipart/form-data">

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">App Version</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="text" class="form-control" id="exampleInputuname_1" placeholder="Enter app version" name="version" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["version"] ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputEmail_1">Maintenance</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-upload"></i></div>
<select class="form-control" name="is_live">
	<?php
	if ( $data[0]["is_live"] == "0"){
		echo '<option value="0">No</option>';
	}else{
		echo '<option value="1">Yes</option>';
	}
	?>
	<option value="0">No</option>
	<option value="1">Yes</option>
</select>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">X2</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="number" step="1" min="1" class="form-control" id="exampleInputuname_1" placeholder="1" name="x2" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["x2"] ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">X3 [ super match ]</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="number" step="1" min="1" class="form-control" id="exampleInputuname_1" placeholder="1" name="x3" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["x3"] ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Whatsapp</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="text" class="form-control" id="exampleInputuname_1" placeholder="Enter whatsapp number" name="whatsapp" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["whatsapp"] ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Instagram</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="text" class="form-control" id="exampleInputuname_1" placeholder="Enter instagram link" name="instagram" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["instagram"] ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Twitter</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="text" class="form-control" id="exampleInputuname_1" placeholder="Enter twitter link" name="twitter" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["twitter"] ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Privacy Policy English</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<textarea class="form-control" name="enPolicy" ><?php if(isset($_GET["edit"])){ echo $data[0]["enPolicy"]; }?></textarea>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Privacy Policy Arabic</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<textarea class="form-control" name="arPolicy" ><?php if(isset($_GET["edit"])){ echo $data[0]["arPolicy"]; }?></textarea>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Terms & conditions English</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<textarea class="form-control" name="enTerms" ><?php if(isset($_GET["edit"])){ echo $data[0]["enTerms"]; }?></textarea>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Terms & conditions Arabic</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<textarea class="form-control" name="arTerms" ><?php if(isset($_GET["edit"])){ echo $data[0]["arTerms"]; }?></textarea>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">About us English</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<textarea class="form-control" name="enAbout" ><?php if(isset($_GET["edit"])){ echo $data[0]["enAbout"]; }?></textarea>
</div>
</div>
</div>	

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">About us Arabic</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<textarea class="form-control" name="arAbout" ><?php if(isset($_GET["edit"])){ echo $data[0]["arAbout"]; }?></textarea>
</div>
</div>
</div>			


<div class="col-md-6">
<button type="submit" class="btn btn-success mr-10">Submit</button>
<input type="hidden" name="date" value="<?php echo $date ?>">
<?php if(isset($_GET["edit"])){?>
<input type="hidden" name="edit" value="<?php echo $_GET["id"] ?>">
<?php }?>
</div>

</form>

<form method="post" action="" onsubmit="return confirm('Are you sure you want to submit?');">
<div class="col-md-6">
<input type="submit" class="btn btn-danger" name="resetData" value="<?php echo "Reset All Data" ?>">
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