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
<h6 class="panel-title txt-dark">Filter Top Users By Date</h6>
</div>
<div class="clearfix"></div>
</div>
<div class="panel-wrapper collapse in">
<div class="panel-body">
<div class="row">
<div class="col-sm-12 col-xs-12">
<div class="form-wrap">

<form action="?page=home" method="post" enctype="multipart/form-data">

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Start Date</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="date" class="form-control" name="sDate" required>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">End Date</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="date" class="form-control" name="eDate" required>
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

<!-- Row -->
<?php
if ( !isset($_GET["edit"]) ){
$status 		= array('0','1');
$arrayOfTitles 	= array('Top Per Selected Dates','Inactive leagues');
$myTable 		= array('myTable1','myTable2');
$panel 			= array('panel-default','panel-danger');
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
<th>#</th>
<th>username</th>
<th>name</th>
<th>mobile</th>
<th>email</th>
<th>Total Points</th>
</tr>
</thead>
<tbody>
<?php
if( $topUsers = selectDataDB("userId, SUM(points) AS total_points","predictions","`date` >= '{$_POST["sDate"]}' AND `date` <= '{$_POST["eDate"]}' GROUP BY `userId` order by total_points DESC") ){
	for( $y = 0; $y < sizeof($topUsers); $y++ ){
		$userDetails = selectDB("user","`id` = {$topUsers[$y]["userId"]}")
		?>
		<tr>
		<td><?php echo $z = $y+1 ?></td>
		<td><?php echo $userDetails[0]["username"] ?></td>
		<td><?php echo $userDetails[0]["name"] ?></td>
		<td><?php echo $userDetails[0]["mobile"] ?></td>
		<td><?php echo $userDetails[0]["email"] ?></td>
		<td><?php echo $topUsers[$y]["total_points"] ?></td>
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