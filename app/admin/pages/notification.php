<?php
//require('../admin/includes/config.php');
if ( isset($_POST["title"]) ){
	/*
	if ( isset($_FILES["image"]["tmp_name"]) && is_uploaded_file($_FILES["image"]["tmp_name"]) ){
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
	}
	if( isset($response["data"]["link"]) ){
		$image = $response["data"]["link"];
	}else{
		$image = "";
	}

	$curl = curl_init();
	curl_setopt_array($curl, array(
	CURLOPT_URL => 'https://pointplus.app/app/request/?action=firebaseNotification',
	CURLOPT_RETURNTRANSFER => true,
	CURLOPT_ENCODING => '',
	CURLOPT_MAXREDIRS => 10,
	CURLOPT_TIMEOUT => 0,
	CURLOPT_FOLLOWLOCATION => true,
	CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
	CURLOPT_CUSTOMREQUEST => 'POST',
	CURLOPT_POSTFIELDS => array(
		'title' => "{$_POST["title"]}",
		'body' => "{$_POST["msg"]}",
		'image' => $image
	),
	CURLOPT_HTTPHEADER => array(
		'pointsheader: pointsCreateKW'
	),
	));
	$response = curl_exec($curl);
	curl_close($curl);

	header("Location: notification.php");die();
	*/
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

<form method="post" enctype="multipart/form-data">

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

<script>
	$("form").on("submit", function(e) {
		var form = new FormData();
		form.append("title", $("input[name='title']").val());
		form.append("body", $("input[name='msg']").val());
		form.append("image", "");
		var settings = {
		"url": "https://pointplus.app/app/request/?action=firebaseNotification",
		"method": "POST",
		"timeout": 0,
		"headers": {
			"pointsheader": "pointsCreateKW"
		},
		"processData": false,
		"mimeType": "multipart/form-data",
		"contentType": false,
		"data": form
		};
		$.ajax(settings).done(function (response) {
			console.log(response);
		});
		return false
	})
	
</script>