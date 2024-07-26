<?php
if ( isset($_POST["username"]) && !empty($_POST["username"] )){
	$check = [';','"',"'"];
	$_POST = str_replace($check,"",$_POST);
	require_once('includes/config.php');
	$sql = "SELECT *
			FROM `vendors`
			WHERE
			`username` LIKE '".$_POST['username']."'
			AND
			`password` LIKE '".sha1($_POST['password'])."'
			AND
			`status` LIKE '0'
			";
	$result = $dbconnect->query($sql);
	if ($result->num_rows > 0 ){
		setcookie('ezyoVCreate', md5(time().$_POST['username']), time() + (3600*24*30) , '/');
		$sql = "UPDATE `vendors`
				SET
				`cookie` = '".md5(time().$_POST['username'])."'
				WHERE
				`username` LIKE '".$_POST['username']."'
				AND
				`password` LIKE '".sha1($_POST['password'])."'
				";
		$result = $dbconnect->query($sql);
		$error = 0;
		header('LOCATION: index.php');die();
	}else{
		$error = 1;
	}
}
?>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
		<title>Boothat CP Login</title>
		<meta name="description" content="Create-KW" />
		<meta name="keywords" content="Create-KW" />
		<meta name="author" content="Create-KW"/>
		
		<!-- Favicon -->
		<link rel="shortcut icon" href="favicon.ico">
		<link rel="icon" href="favicon.ico" type="image/x-icon">
		
		<!-- vector map CSS -->
		<link href="../vendors/bower_components/jasny-bootstrap/dist/css/jasny-bootstrap.min.css" rel="stylesheet" type="text/css"/>
		
		
		
		<!-- Custom CSS -->
		<link href="dist/css/style.css" rel="stylesheet" type="text/css">
	</head>
	<body>
		<!--Preloader-->
		<div class="preloader-it">
			<div class="la-anim-1"></div>
		</div>
		<!--/Preloader-->
		
		<div class="wrapper  pa-0">
			<header class="sp-header">
				<div class="sp-logo-wrap pull-left">
					<a href="index.html">
						<img class="brand-img mr-10" src="../img/logo.png" alt="brand"/>
						<span class="brand-text">Boothat</span>
					</a>
				</div>
				<div class="form-group mb-0 pull-right">
					
				</div>
				<div class="clearfix"></div>
			</header>
			
			<!-- Main Content -->
			<div class="page-wrapper pa-0 ma-0 auth-page">
				<div class="container-fluid">
					<!-- Row -->
					<div class="table-struct full-width full-height">
						<div class="table-cell vertical-align-middle auth-form-wrap">
							<div class="auth-form  ml-auto mr-auto no-float">
								<div class="row">
									<div class="col-sm-12 col-xs-12">
										<div class="mb-30">
											<h3 class="text-center txt-dark mb-10">Vendor Sign in to Boothat CP</h3>
											<h6 class="text-center nonecase-font txt-grey">Enter your details below</h6>
											<?php
											if (isset($error) and $error = 1){
												?>
												<h6 class="text-center nonecase-font txt-danger">Please check your info.</h6>
												<?php
											}
											?>
											

										</div>	
										<div class="form-wrap">
		<form action="" method="post">
			<div class="form-group">
				<label class="control-label mb-10" >Username</label>
				<input type="text" class="form-control" name="username" required="">
			</div>
			<div class="form-group">
				<label class="pull-left control-label mb-10" >Password</label>
				<a class="capitalize-font txt-primary block mb-10 pull-right font-12" href="forgot-password.html">forgot password ?</a>
				<div class="clearfix"></div>
				<input type="password" name="password" class="form-control" required="">
			</div>
			
			<div class="form-group">
				<div class="checkbox checkbox-primary pr-10 pull-left">
					<input id="checkbox_2" type="checkbox">
					<label for="checkbox_2"> Keep me logged in</label>
				</div>
				<div class="clearfix"></div>
			</div>
			<div class="form-group text-center">
				<button type="submit" class="btn btn-success  btn-rounded">sign in</button>
			</div>
		</form>
										</div>
									</div>	
								</div>
							</div>
						</div>
					</div>
					<!-- /Row -->	
				</div>
				
			</div>
			<!-- /Main Content -->
		
		</div>
		<!-- /#wrapper -->
		
		<!-- JavaScript -->
		
		<!-- jQuery -->
		<script src="../vendors/bower_components/jquery/dist/jquery.min.js"></script>
		
		<!-- Bootstrap Core JavaScript -->
		<script src="../vendors/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
		<script src="../vendors/bower_components/jasny-bootstrap/dist/js/jasny-bootstrap.min.js"></script>
		
		<!-- Slimscroll JavaScript -->
		<script src="dist/js/jquery.slimscroll.js"></script>
		
		<!-- Init JavaScript -->
		<script src="dist/js/init.js"></script>
	</body>
</html>
