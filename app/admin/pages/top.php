<?php
if ( isset($_POST["startDate"]) && !isset($_POST["edit"]) ){
	$table = "tops";
	$_POST["topUsers"] = getTop30($_POST["startDate"],$_POST["endDate"]);
	insertDB($table,$_POST);
	?>
	<script> window.location.href = '?page=top'; </script>
	<?php
	die();
}
if ( isset($_GET["delete"]) ){
	$table = "tops";
	$data = array('status'=>'1');
	$where = "`id` LIKE '".$_GET["delete"]."'";
	updateDB($table,$data,$where);
}
if ( isset($_GET["return"]) ){
	$table = "tops";
	$data = array('status'=>'0');
	$where = "`id` LIKE '".$_GET["return"]."'";
	updateDB($table,$data,$where);
}

if ( isset($_POST["edit"]) ){
	$table = "tops";
	$where = "`id` LIKE '".$_POST["edit"]."'";
	unset($_POST["edit"]);
	var_dump(getTop30($_POST["startDate"],$_POST["endDate"]));
	$_POST["topUsers"] = json_encode(getTop30($_POST["startDate"],$_POST["endDate"]));
	$data = $_POST;
	updateDB($table,$data,$where);
}

if( isset($_GET["edit"]) && !empty($_GET["edit"]) ){
	$table = "tops";
	$where = "`id` LIKE '".$_GET["id"]."'";
	$data = selectDB($table,$where);
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
<h6 class="panel-title txt-dark">Tops Details</h6>
</div>
<div class="clearfix"></div>
</div>
<div class="panel-wrapper collapse in">
<div class="panel-body">
<div class="row">
<div class="col-sm-12 col-xs-12">
<div class="form-wrap">

<form action="?page=top" method="post" enctype="multipart/form-data">

<div class="col-md-3">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1"><?php echo direction("Start Date","تاريخ البدء") ?></label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="date" class="form-control" id="exampleInputuname_1" placeholder="" name="startDate" <?php if(isset($_GET["edit"])){?>value="<?php echo substr($data[0]["startDate"],0,10) ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-3">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1"><?php echo direction("End Date","تاريخ الانتهاء") ?></label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="date" class="form-control" id="exampleInputuname_1" placeholder="" name="endDate" <?php if(isset($_GET["edit"])){?>value="<?php echo substr($data[0]["endDate"],0,10) ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-3">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1"><?php echo direction("English Title","العنوان باللغة الانجليزية") ?></label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="text" class="form-control" id="exampleInputuname_1" placeholder="" name="enTitle" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["enTitle"] ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-3">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1"><?php echo direction("Arabic Title", "العنوان باللغة العربية") ?></label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="text" class="form-control" id="exampleInputuname_1" placeholder="" name="arTitle" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["arTitle"] ?>"<?php }?> required>
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
<th><?php echo direction("Start Date","تاريخ البدء") ?></th>
<th><?php echo direction("End Date","تاريخ الانتهاء") ?></th>
<th><?php echo direction("English Title","العنوان باللغة الانجليزية") ?></th>
<th><?php echo direction("Arabic Title", "العنوان باللغة العربية") ?></th>
<th><?php echo direction("Actions","الخيارات") ?></th>
</tr>
</thead>
<tbody>
<?php
$sql = "SELECT t.*
		FROM `tops` as t
		WHERE
		t.status = '".$status[$i]."'
		";
$result = $dbconnect->query($sql);
while ( $row = $result->fetch_assoc() ){
?>
<tr>
<td><?php echo substr($row["date"],0,11) ?></td>
<td><?php echo substr($row["startDate"],0,11) ?></td>
<td><?php echo substr($row["endDate"],0,11) ?></td>
<td><?php echo $row["enTitle"] ?></td>
<td><?php echo $row["arTitle"] ?></td>
<td>
<a href="?page=top&edit=1&id=<?php echo $row["id"] ?>" style="margin:3px"><i class="fa fa-edit"></i></a>

<a href="?page=top&<?php echo $action[$i] . $row["id"] ?>" style="margin:3px"><i class="<?php echo $icon[$i] ?>"></i></a>
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