<?php
if ( isset($_POST["enTitle"]) && !isset($_POST["edit"]) ){
	if( is_uploaded_file($_FILES['logo']['tmp_name']) ){
		@$ext = end((explode(".", $_FILES['logo']['name'])));
		$directory = "logos/";
		$originalfile = $directory . md5(date("d-m-y").time().rand(111111,999999))."." . $ext;
		move_uploaded_file($_FILES["logo"]["tmp_name"], $originalfile);
		$_POST["logo"] = str_replace("logos/",'',$originalfile);
	}else{
		$_POST["logo"] = "";
	}
    if( is_uploaded_file($_FILES['coverImage']['tmp_name']) ){
		@$ext = end((explode(".", $_FILES['coverImage']['name'])));
		$directory = "logos/";
		$originalfile = $directory . md5(date("d-m-y").time().rand(111111,999999))."." . $ext;
		move_uploaded_file($_FILES["coverImage"]["tmp_name"], $originalfile);
		$_POST["coverImage"] = str_replace("logos/",'',$originalfile);
	}else{
		$_POST["coverImage"] = "";
	}
	$table = "publicLeagues";
	insertDB($table,$_POST);
}
if ( isset($_GET["delete"]) ){
	$table = "publicLeagues";
	$data = array('status'=>'1');
	$where = "`id` LIKE '".$_GET["delete"]."'";
	updateDB($table,$data,$where);
}
if ( isset($_GET["return"]) ){
	$table = "publicLeagues";
	$data = array('status'=>'0');
	$where = "`id` LIKE '".$_GET["return"]."'";
	updateDB($table,$data,$where);
}
if ( isset($_GET["edit"]) ){
	$table = "publicLeagues";
	$where = "`id` LIKE '".$_GET["id"]."'";
	$data = selectDB($table,$where);
}

if ( isset($_POST["edit"]) ){
	if( is_uploaded_file($_FILES['logo']['tmp_name']) ){
		@$ext = end((explode(".", $_FILES['logo']['name'])));
		$directory = "logos/";
		$originalfile = $directory . md5(date("d-m-y").time().rand(111111,999999))."." . $ext;
		move_uploaded_file($_FILES["logo"]["tmp_name"], $originalfile);
		$_POST["logo"] = str_replace("logos/",'',$originalfile);
	}else{
		unset($_POST["logo"]);
	}
    if( is_uploaded_file($_FILES['coverImage']['tmp_name']) ){
		@$ext = end((explode(".", $_FILES['coverImage']['name'])));
		$directory = "logos/";
		$originalfile = $directory . md5(date("d-m-y").time().rand(111111,999999))."." . $ext;
		move_uploaded_file($_FILES["coverImage"]["tmp_name"], $originalfile);
		$_POST["coverImage"] = str_replace("logos/",'',$originalfile);
	}else{
		unset($_POST["coverImage"]);
	}
	$table = "publicLeagues";
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
<h6 class="panel-title txt-dark">Public League Details</h6>
</div>
<div class="clearfix"></div>
</div>
<div class="panel-wrapper collapse in">
<div class="panel-body">
<div class="row">
<div class="col-sm-12 col-xs-12">
<div class="form-wrap">

<form action="?page=publicLeagues" method="post" enctype="multipart/form-data">

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">English Title</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="text" class="form-control" id="exampleInputuname_1" placeholder="Full Name" name="enTitle" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["enTitle"] ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Arabic Title</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="text" class="form-control" id="exampleInputuname_1" placeholder="Enter username" name="arTitle" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["arTitle"] ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">English Details</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<textarea class="tinymce" id="exampleInputuname_1" name="enDetails" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["enDetails"] ?>"<?php }?>></textarea></div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Arabic Details</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<textarea class="tinymce" id="exampleInputuname_1" name="arDetails" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["arDetails"] ?>"<?php }?>></textarea></div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">English Terms</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<textarea class="tinymce" id="exampleInputuname_1" name="enTerms" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["enTerms"] ?>"<?php }?>></textarea>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Arabic Terms</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<textarea class="tinymce" id="exampleInputuname_1" name="arTerms" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["arTerms"] ?>"<?php }?>></textarea>
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Country</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<select class="form-control" id="exampleInputuname_1" name="country" required>
<option value="">Select Country</option>
<?php
if( $countries = selectDB("cities","`CountryName` != '' GROUP BY `CountryName` ORDER BY `CountryName` ASC") ){
    for( $i = 0; $i < sizeof($countries) ; $i++ ){
        $country = $countries[$i];
    ?>
    <option value="<?php echo $country["id"] ?>" <?php if(isset($_GET["edit"]) && $data[0]["country"] == $country["CountryName"]){?>selected<?php }?>><?php echo $country["CountryName"] ?></option>
    <?php
    }
}
?>
</select>
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputEmail_1">Upload Logo</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-upload"></i></div>
<input type="file" class="form-control" id="exampleInputEmail_1" name="logo">
</div>
</div>
</div>		

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputEmail_1">Upload Cover Image</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-upload"></i></div>
<input type="file" class="form-control" id="exampleInputEmail_1" name="coverImage">
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
<th>English Title</th>
<th>Arabic Title</th>
<th>Logo</th>
<th>Actions</th>
</tr>
</thead>
<tbody>
<?php

if( $leagues = selectDB("publicLeagues","`status` = '{$status[$i]}'") ){
	for( $j = 0; $j < sizeof($leagues) ; $j++ ){
		$league = $leagues[$j];
	?>
	<tr>
	<td><?php echo substr($league["date"],0,11) ?></td>
	<td><?php echo $league["enTitle"] ?></td>
	<td><?php echo $league["arTitle"] ?></td>
	<td>
	<?php
	if ( !empty($league["logo"]) ){
	?>
	<a href="logos/<?php echo $league["logo"] ?>" target="_blank">View</a>
	<?php
	}else{
		echo "None";
	}
	?>
	</td>
	<td>

	<a href="?page=publicLeagues&edit=1&id=<?php echo $league["id"] ?>" style="margin:3px"><i class="fa fa-edit"></i></a>

	<a href="?page=publicLeagues&<?php echo $action[$i] . $league["id"] ?>" style="margin:3px"><i class="<?php echo $icon[$i] ?>"></i></a>

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

<!-- Tinymce JavaScript -->
<script src="../vendors/bower_components/tinymce/tinymce.min.js"></script>
					
<!-- Tinymce Wysuhtml5 Init JavaScript -->
<script src="dist/js/tinymce-data.js"></script>