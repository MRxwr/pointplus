<?php
//require('../admin/includes/config.php');
if ( isset($_POST["title"]) ){
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

	if( $users = selectDB("users","`firebase` != '' GROUP BY `firebase`") ){
		for ($i=0; $i < 1; $i++) {
			$curl = curl_init();
			curl_setopt_array($curl, array(
			CURLOPT_URL => 'https://fcm.googleapis.com/v1/projects/points-a1a14/messages:send',
			CURLOPT_RETURNTRANSFER => true,
			CURLOPT_ENCODING => '',
			CURLOPT_MAXREDIRS => 10,
			CURLOPT_TIMEOUT => 0,
			CURLOPT_FOLLOWLOCATION => true,
			CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
			CURLOPT_CUSTOMREQUEST => 'POST',
			CURLOPT_POSTFIELDS =>"{
				'message': 
					{
						'token': 'fUFXZMAjSwa2d-ev0L4LoU:APA91bGp1hy27dlgGruuvtN4SDpyMHiDuFw8aS-uUysbnmZG31AI8IAnPHtDjo36xRwX4PxAgqKvL1pDlbXJQX7HVxCrNTjDjLMUQtZgpIZHNm0GSu7IxfwiG3Xhb-iWcLlr-c7NM3uf',
						'notification': 
							{
								'body': '{$_POST["title"]}',
								'title': '{$_POST["msg"]}',
								'image': '{$image}'
							}
					}
				}
			",
			CURLOPT_HTTPHEADER => array(
				'Content-Type: application/json',
				'Authorization: Bearer ya29.a0AcM612zoe3otNgcGL7ZUzIJaCvr5dB69hfx1rVDiJeCOLnCcq7D4fooOOii0JY920mmiJnVm4H4TwjSTLiStgejO-wtRXT8VNkw5mrLJSj95rszsjE-XAnjYsDezIrdQLczD5krvD4JimioZycXXi3n-TTcEaY-pJID1-QUeaCgYKAbMSARESFQHGX2Mis4bt5AWmLm1v0S0MwFP0Pg0175'
			),
			));
			$response = curl_exec($curl);
			curl_close($curl);
		}
	}
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