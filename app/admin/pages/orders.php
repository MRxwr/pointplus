<?php
if ( isset($_GET["status"]) ){
	$array = selectDB('orders', " `id` LIKE '".$_GET["id"]."'");
	$table = "orders";
	$data = array('status'=> $_GET["status"] );
	$where = "`id` LIKE '".$_GET["id"]."'";
	updateDB($table,$data,$where);
	
	$array = selectDB('orders', " `id` LIKE '".$_GET["id"]."'");
	if ( isset($_GET["status"]) ){
		$server_key = 'AAAABgr1QF4:APA91bHYhGKGfLUCXFPmapE1pnYhDXnqWFifKe0ooeSEU6cv1lTc_l7DSJKprWX5YSNC-Gmq_e201Tc0eB6-lz_rwt-X3Hep_XGJ4X-haHnOLf73tGyfexTpRF9Vn2moVCdgQHjSp85o';
		$url = 'https://fcm.googleapis.com/fcm/send';
		$headers = array(
			'Content-Type:application/json',
			'Authorization:key='.$server_key
		);
		$sql = "SELECT `firebase` FROM `user` WHERE `id` LIKE '{$array[0]["userId"]}' GROUP BY `firebase`";
		$result = $dbconnect->query($sql);
		if ( $array[0]["status"] == 0 ){
			$orderStatus = "New Order";
		}elseif( $array[0]["status"] == 1 ){
			$orderStatus = "Preparing";
		}elseif( $array[0]["status"] == 2 ){
			$orderStatus = "Out for delivery";
		}elseif( $array[0]["status"] == 3 ){
			$orderStatus = "Delivered";
		}elseif( $array[0]["status"] == 4 ){
			$orderStatus = "Canceled";
		}elseif( $array[0]["status"] == 5 ){
			$orderStatus = "Refunded";
		}elseif( $array[0]["status"] == 6 ){
			$orderStatus = "Failed";
		}
		
		while( $row = $result->fetch_assoc() ){
			$to = $row["firebase"];
			$title = $orderStatus;
			$body = "Your order {$array[0]["orderId"]} status has changed to " . $orderStatus;
			$json_data = array(
				"to" => "{$to}",
				"notification" => array(
					"body" => "{$body}",
					"text" => "{$body}",
					"title" => "{$title}",
					"sound" => "default",
					"content_available" => "true",
					"priority" => "high",
					"badge" => "1"
				),
				"data" => array(
					"body" => "{$body}",
					"title" => "{$title}",
					"text" => "{$body}",
					"sound" => "default",
					"content_available" => "true",
					"priority" => "high",
					"badge" => "1"
				)
			);
			$data = json_encode($json_data);
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_URL, $url);
			curl_setopt($ch, CURLOPT_POST, true);
			curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
			curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
			curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
			$response = curl_exec($ch);
			curl_close($ch);
			
			$insertData = array(
				"userId" => $array[0]["customerId"],
				"notification" => "{$body}"
			);
			insertDB('notification',$insertData);
		}
	}
	/*
	if ( $_GET["status"] == 6 ){
		$array = selectDB('orders',"`id` LIKE '".$_GET["id"]."'");
		$array1 = selectDB('customers',"`id` LIKE '".$array[0]["customerId"]."'");
		updateDB('customers',array('wallet'=>($array1[0]["wallet"]+$array[0]["price"])),"`id` LIKE '".$array[0]["customerId"]."'");
	}
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

<!-- Row -->
<?php
$status 		= array('0','1');
$arrayOfTitles 	= array('List Of Orders','Inactive Addresses');
$myTable 		= array('myTable1','myTable2');
$panel 			= array('panel-default','panel-danger');
$textColor 		= array('txt-dark','txt-light');
$icon 			= array('fa fa-trash-o','fa fa-refresh');
$action			= array('delete=','return=');

$btnArray = ['primary','default','warning','success','danger','info'];
$iconArray = ['money','clock-o','car','check','times','refresh'];
$actions = array('btn'=>$btnArray, 'icon'=>$iconArray);
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
<th>Date</th>
<th>Order</th>
<th>Item</th>
<th>Coins</th>
<th>Remaning</th>
<th>Name</th>
<th>Mobile</th>
<th>Email</th>
<th>Country</th>
<th>Address 1</th>
<th>Address 2</th>
<th>Status</th>
<th>Action</th>
</tr>
</thead> 
<tbody>
<?php
if( $ordersList = selectDB("orders","`id` != '0'") ){
	for( $i = 0; $i < sizeof($ordersList); $i++ ){
		$address = selectDB("addresses","`id` = '{$ordersList[$i]["addressId"]}'");
		$item = selectDB("products","`id` = '{$ordersList[$i]["itemId"]}'");
	if ( $ordersList[$i]["status"] == 0 ){
		$orderStatus = "New Order";
	}elseif( $ordersList[$i]["status"] == 1 ){
		$orderStatus = "Preparing";
	}elseif( $ordersList[$i]["status"] == 2 ){
		$orderStatus = "Out for delivery";
	}elseif( $ordersList[$i]["status"] == 3 ){
		$orderStatus = "Delivered";
	}elseif( $ordersList[$i]["status"] == 4 ){
		$orderStatus = "Canceled";
	}elseif( $ordersList[$i]["status"] == 5 ){
		$orderStatus = "Refunded";
	}elseif( $ordersList[$i]["status"] == 6 ){
		$orderStatus = "Failed";
	}
?>
<tr>
<td><?php echo substr($ordersList[$i]["date"],0,11) ?></td>
<td><?php echo $ordersList[$i]["id"] ?></td>
<td><?php echo $ordersList[$i]["coins"] ?></td>
<td><?php echo $ordersList[$i]["remainingCoins"] ?></td>
<td><?php echo $item[0]["enTitle"] ?></td>
<td><?php echo $address[0]["name"] ?></td>
<td><?php echo $address[0]["mobile"] ?></td>
<td><?php echo $address[0]["email"] ?></td>
<td><?php echo $address[0]["country"] ?></td>
<td><?php echo $address[0]["address1"] ?></td>
<td><?php echo $address[0]["address2"] ?></td>
<td>
<button class="btn btn-<?php echo $btnArray[$ordersList[$i]["status"]] ?> btn-rounded btn-lable-wrap right-label btn-sm" style="width: 100%;"><span class="btn-text btn-sm"><?php echo $orderStatus ?></span> <span class="btn-label btn-sm"><i class="fa fa-<?php echo $iconArray[$ordersList[$i]["status"]] ?>"></i> </span></button>
</td>
<td>

<?php
if ( $ordersList[$i]["status"] == 5 || $ordersList[$i]["status"] == 6 ){
	for( $y = 0 ; $y <= 7 ; $y++ ){
		$z = $y+1;
		if ( $ordersList[$i]["status"] != $z ){
		?>
		<a href="?page=orders&id=<?php echo $ordersList[$i]["id"] ?>&status=<?php echo $z ?>" style="margin:3px" class="btn btn-<?php echo $actions["btn"][$y] ?> btn-icon-anim btn-square btn-sm"><i class="fa fa-<?php echo $actions["icon"][$y] ?>"></i></a>
		<?php
		}
	}
}else{
	for( $y = 0 ; $y <= 7 ; $y++ ){
		$z = $y+1;
		if ( $ordersList[$i]["status"] <= $y ){
		?>
		<a href="?page=orders&id=<?php echo $ordersList[$i]["id"] ?>&status=<?php echo $z ?>" style="margin:3px" class="btn btn-<?php echo $actions["btn"][$y] ?> btn-icon-anim btn-square btn-sm"><i class="fa fa-<?php echo $actions["icon"][$y] ?>"></i></a>
		<?php
		}
	}
}
?>
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