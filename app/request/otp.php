<?php 
if( isset($_GET["type"]) && !empty($_GET["type"]) ){
    if( !isset($_POST["userId"]) || empty($_POST["userId"]) ){
        $response["msg"] = "Please provide a user ID.";
        echo outputError($response);die();
    }
    if( $_GET["type"] == "requestOTP" ){
        if( $user = selectDataDB("`mobile`, `isVerified`", "user", "`id` = '{$_POST["userId"]}'") ){
            if( $user[0]["isVerified"] == 1 ){
                $response["msg"] = "User is already verified.";
                echo outputData($response);die();
            }else{
                $otp = rand(1000, 9999);
                if( updateDB("user", ["otp" => $otp], "`id` = '{$_POST["userId"]}'" ) ){
                    whatsappUltraMsgVerify($user[0]["mobile"], $otp);
                    $response["msg"] = "OTP sent to your mobile.";
                }else{
                    $response["msg"] = "Failed to send OTP.";
                }
            }
        }else{
            $response["msg"] = "User not found.";
            echo outputError($response);die();
        }
        echo outputData($response);die();
    }elseif( $_GET["type"] == "checkOTP" ){
        if( !isset($_POST["otp"]) || empty($_POST["otp"]) ){
            $response["msg"] = "Please provide an OTP.";
            echo outputError($response);die();
        }
        if( $user = selectDataDB("`mobile`, `isVerified`", "user", "`id` = '{$_POST["userId"]}'") ){
            if( $user[0]["isVerified"] == 1 ){
                $response["msg"] = "User is already verified.";
                echo outputData($response);die();
            }else{
                if( $user[0]["otp"] == $_POST["otp"] ){
                    if( updateDB("user", ["isVerified" => 1, "otp" => ""], "`id` = '{$_POST["userId"]}'" ) ){
                        $response["msg"] = "User verified successfully.";
                        echo outputData($response);die();
                    }else{
                        $response["msg"] = "Failed to verify user.";
                        echo outputError($response);die();
                    }
                }else{
                    $response["msg"] = "Invalid OTP.";
                    echo outputError($response);die();
                }
            }
        }
    }else{
        $response["msg"] = "Invalid request type.";
        echo outputError($response);die();
    }
}else{
    $response["msg"] = "request type is required.";
    echo outputError($response);die();
}
?>