<?php
if ( isset($_POST["question"]) && !isset($_POST["edit"]) ){
	
	if( is_uploaded_file($_FILES['image']['tmp_name']) ){
		@$ext = end((explode(".", $_FILES['image']['name'])));
		$directory = "quizes/";
		$originalfile = $directory . md5(date("d-m-y").time().rand(111111,999999))."." . $ext;
		move_uploaded_file($_FILES["image"]["tmp_name"], $originalfile);
		$_POST["image"] = str_replace("quizes/",'',$originalfile);
	}else{
		$_POST["image"] = "";
	}
	$table = "quiz_question";
	insertDB($table,$_POST);
}
if ( isset($_GET["delete"]) ){
	$table = "quiz_question";
	$data = array('status'=>'1');
	$where = "`id` LIKE '".$_GET["delete"]."'";
	updateDB($table,$data,$where);
}
if ( isset($_GET["return"]) ){
	$table = "quiz_question";
	$data = array('status'=>'0');
	$where = "`id` LIKE '".$_GET["return"]."'";
	updateDB($table,$data,$where);
}
if ( isset($_GET["edit"]) ){
	$table = "quiz_question";
	$where = "`id` LIKE '".$_GET["id"]."'";
	$data = selectDB($table,$where);
}

if ( isset($_POST["edit"]) ){
	if( is_uploaded_file($_FILES['image']['tmp_name']) ){
		@$ext = end((explode(".", $_FILES['image']['name'])));
		$directory = "quizes/";
		$originalfile = $directory . md5(date("d-m-y").time().rand(111111,999999))."." . $ext;
		move_uploaded_file($_FILES["image"]["tmp_name"], $originalfile);
		$_POST["image"] = str_replace("quizes/",'',$originalfile);
	}else{
		unset($_POST["image"]);
	}
	$table = "quiz_question";
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
<h6 class="panel-title txt-dark">Quiz Question Details</h6>
</div>
<div class="clearfix"></div>
</div>
<div class="panel-wrapper collapse in">
<div class="panel-body">
<div class="row">
<div class="col-sm-12 col-xs-12">
<div class="form-wrap">

<form action="?page=quizQuestion" method="post" enctype="multipart/form-data">

<div class="col-md-12">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Category</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<select class="form-control" name="quizCategory" required>
	<?php
    $orderBy = direction("enTitle","arTitle");
	if ( $quizCategories = selectDB("quiz_categories","`status` = '0' AND `hidden` = '0' ORDER BY `{$orderBy}` ASC") ){
		if ( isset($_GET["edit"]) && $quizCategory = selectDB("quiz_categories","`id` = '{$data[0]["quizCategory"]}'") ){
			$categoryTitle = direction($quizCategory[0]["enTitle"],$quizCategory[0]["arTitle"]);
			echo "<option value='{$quizCategory[0]["id"]}'>{$categoryTitle}</option>";
		}
		for ( $i = 0; $i < sizeof($quizCategories); $i++ ){
			$categoryTitle = direction($quizCategories[$i]["enTitle"],$quizCategories[$i]["arTitle"]);
			echo "<option value='{$quizCategories[$i]["id"]}'>{$categoryTitle}</option>";
		}
	}else{
		echo '<option value="0">No Category Available</option>';
	}
	?>
</select>
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Question</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="text" class="form-control" name="question" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["question"] ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Points</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="number" class="form-control" placeholder="points" name="points" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["points"] ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-4">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputEmail_1">Upload Image</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-upload"></i></div>
<input type="file" class="form-control" name="image">
</div>
</div>
</div>	

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Answer 1</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="text" class="form-control" name="answer1" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["answer1"] ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Is Correct 1?</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<select class="form-control" name="isCorrect1" required>
	<?php
    if ( isset($_GET["edit"]) ){
        $title = ( $data[0]["isCorrect1"] == 1 ) ? direction("Yes","نعم") : direction("No","لا");
        echo "<option selected value='{$data[0]["isCorrect1"]}'>{$title}</option>";
    }
    echo "<option value='0'>".direction("No","لا")."</option>";
    echo "<option value='1'>".direction("Yes","نعم")."</option>";
	?>
</select>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Answer 2</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="text" class="form-control" name="answer2" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["answer2"] ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Is Correct 2?</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<select class="form-control" name="isCorrect2" required>
	<?php
    if ( isset($_GET["edit"]) ){
        $title = ( $data[0]["isCorrect2"] == 1 ) ? direction("Yes","نعم") : direction("No","لا");
        echo "<option selected value='{$data[0]["isCorrect2"]}'>{$title}</option>";
    }
    echo "<option value='0'>".direction("No","لا")."</option>";
    echo "<option value='1'>".direction("Yes","نعم")."</option>";
	?>
</select>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Answer 3</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<input type="text" class="form-control" name="answer3" <?php if(isset($_GET["edit"])){?>value="<?php echo $data[0]["answer3"] ?>"<?php }?> required>
</div>
</div>
</div>

<div class="col-md-6">
<div class="form-group">
<label class="control-label mb-10" for="exampleInputuname_1">Is Correct 3?</label>
<div class="input-group">
<div class="input-group-addon"><i class="fa fa-text-width"></i></div>
<select class="form-control" name="isCorrect3" required>
	<?php
    if ( isset($_GET["edit"]) ){
        $title = ( $data[0]["isCorrect3"] == 1 ) ? direction("Yes","نعم") : direction("No","لا");
        echo "<option selected value='{$data[0]["isCorrect3"]}'>{$title}</option>";
    }
    echo "<option value='0'>".direction("No","لا")."</option>";
    echo "<option value='1'>".direction("Yes","نعم")."</option>";
	?>
</select>
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
$arrayOfTitles 	= array('Active Quiz Question','Inactive Quiz Question');
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
<th>Category</th>
<th>Question</th>
<th>Answer 1</th>
<th>Answer 2</th>
<th>Answer 3</th>
<th>Correct</th>
<th>Points</th>
<th>Image</th>
<th>Actions</th>
</tr>
</thead>
<tbody>
<?php
$sql = "SELECT t.*
		FROM `quiz_question` as t
		WHERE
		t.status = '".$status[$i]."'
		";
$result = $dbconnect->query($sql);
while ( $row = $result->fetch_assoc() ){
    $category = selectDB("quiz_categories","`id` = '{$row["quizCategory"]}'");
    if( $row["isCorrect1"] == 1 ){
        $isCorrectAnswer = 1;
    }elseif( $row["isCorrect2"] == 1 ){
        $isCorrectAnswer = 2;
    }else{
        $isCorrectAnswer = 3;
    }
?>
<tr>
<td><?php echo substr($row["date"],0,11) ?></td>
<td><?php echo $category[0]["enTitle"] ?></td>
<td><?php echo $row["question"] ?></td>
<td><?php echo $row["answer1"] ?></td>
<td><?php echo $row["answer2"] ?></td>
<td><?php echo $row["answer3"] ?></td>
<td><?php echo $isCorrectAnswer ?></td>
<td><?php echo $row["points"] ?></td>
<td>
<?php
if ( !empty($row["image"]) ){
?>
<a href="quizes/<?php echo $row["image"] ?>" target="_blank">View</a>
<?php
}else{
	echo "None";
}
?>
</td>
<td>

<a href="?page=quizQuestion&edit=1&id=<?php echo $row["id"] ?>" style="margin:3px"><i class="fa fa-edit"></i></a>

<a href="?page=quizQuestion&<?php echo $action[$i] . $row["id"] ?>" style="margin:3px"><i class="<?php echo $icon[$i] ?>"></i></a>

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