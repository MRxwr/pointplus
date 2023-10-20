<?php
//require('../admin/includes/config.php');
if ( isset($_POST["title"]) ){
	$server_key = 'AAAABgr1QF4:APA91bHYhGKGfLUCXFPmapE1pnYhDXnqWFifKe0ooeSEU6cv1lTc_l7DSJKprWX5YSNC-Gmq_e201Tc0eB6-lz_rwt-X3Hep_XGJ4X-haHnOLf73tGyfexTpRF9Vn2moVCdgQHjSp85o';
	$url = 'https://fcm.googleapis.com/fcm/send';
	$headers = array(
		'Content-Type:application/json',
		'Authorization:key='.$server_key
	);
	$curl = curl_init();
	curl_setopt_array($curl, array(
	  CURLOPT_URL => 'https://api.imgur.com/3/upload',
	  CURLOPT_RETURNTRANSFER => true,
	  CURLOPT_ENCODING => '',
	  CURLOPT_MAXREDIRS => 10,
	  CURLOPT_TIMEOUT => 0,
	  CURLOPT_FOLLOWLOCATION => true,
	  CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
	  CURLOPT_CUSTOMREQUEST => 'POST',
	  CURLOPT_POSTFIELDS => array('image'=> new CURLFILE($_FILES["image"]["tmp_name"])),
	  CURLOPT_HTTPHEADER => array(
		'Authorization: Client-ID 386563124e58e6c'
	  ),
	));
	$response = curl_exec($curl);
	curl_close($curl);
	$response = json_decode($response,true);
	$sql = "SELECT * FROM `user` WHERE `firebase` != '' GROUP BY `firebase`";
	$result = $dbconnect->query($sql);
	if( isset($response["data"]["link"]) ){
		$image = $response["data"]["link"];
	}else{
		$image = "";
	}
	$title = $_POST["title"];
	$body = $_POST["msg"];
	while( $row = $result->fetch_assoc() ){
		$to[] = $row["firebase"];
		$data = array(
			"userId" => $row["id"],
			"notification" => $title . " - " . $body,
			"image" => $image
		);
		insertDB("notification",$data);
	}
	$json_data = array(
		"registration_ids" => $to,
		"notification" => array(
			"body" => "{$body}",
			"text" => "{$body}",
			"title" => "{$title}",
			"sound" => "default",
			"content_available" => "true",
			"priority" => "high",
			"badge" => "1",
			"image" => "{$image}"
		),
		"data" => array(
			"body" => "{$body}",
			"title" => "{$title}",
			"text" => "{$body}",
			"sound" => "default",
			"content_available" => "true",
			"priority" => "high",
			"badge" => "1",
			"image" => "{$image}"
		)
	);
		echo $data = json_encode($json_data);
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_POST, true);
		curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
		var_dump($response = curl_exec($ch));
		curl_close($ch);
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
<h6 class="panel-title txt-dark">Send Notification</h6>
</div>
<div class="clearfix"></div>
</div>
<div class="panel-wrapper collapse in">
<div class="panel-body">
<div class="row">
<div class="col-sm-12 col-xs-12">
<div class="form-wrap">

<form action="" method="post" enctype="multipart/form-data">

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Title</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-file"></i></div>
<input type="text" class="form-control" name="title" required>
</div>
</div>
</div>	

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Message</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-file"></i></div>
<input type="text" class="form-control" name="msg" required>
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Upload Image</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-image"></i></div>
<input type="file" class="form-control" name="image">
</div>
</div>
</div>	

<div class="col-md-12">
<button type="submit" class="btn btn-success mr-10">Submit</button>
<input type="hidden" name="date" value="<?php echo $date ?>">
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