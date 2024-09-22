<?php
require_once("../../vendor/autoload.php");
use Google\Client;

function getAccessToken() {
    // Path to your service account key
    $serviceAccountKeyFile = '../../../points-a1a14-firebase-adminsdk-wggts-d65c7381c1.json';
    // Initialize the Google API Client
    $client = new Client();
    $client->setAuthConfig($serviceAccountKeyFile);
    // Define the scopes you need (for FCM, you need cloud messaging scope)
    $client->addScope('https://www.googleapis.com/auth/firebase.messaging');
    // Fetch the access token
    $token = $client->fetchAccessTokenWithAssertion();
    return $token['access_token'];
}

$bearer = getAccessToken();
$notificationData = array(
    "message" => array(
        "notification" => array( 
            "title" => "{$_POST["title"]}",
            "body"  => "{$_POST["body"]}",
            "image" => "{$_POST["image"]}",
        )
    )
);

if( $users = selectDB("users", "`id` != '0' GROUP BY `firebase` ORDER BY `id` ASC") ){
    for( $i = 0; $i < sizeof($users); $i++){
        $notificationData["message"]["token"] = $users[$i]["firebase"];
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
          CURLOPT_POSTFIELDS => json_encode($notificationData),
          CURLOPT_HTTPHEADER => array(
            'Content-Type: application/json',
            'Authorization: Bearer ' . $bearer
          ),
        ));
        $response = curl_exec($curl);
        curl_close($curl);
    }
}
?>