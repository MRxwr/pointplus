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

$notificationData = array(
    "message" => array(
        "token" => "fUFXZMAjSwa2d-ev0L4LoU:APA91bGp1hy27dlgGruuvtN4SDpyMHiDuFw8aS-uUysbnmZG31AI8IAnPHtDjo36xRwX4PxAgqKvL1pDlbXJQX7HVxCrNTjDjLMUQtZgpIZHNm0GSu7IxfwiG3Xhb-iWcLlr-c7NM3uf",
        "notification" => array( 
            "title" => "test title",
            "body"  => "test body test",
            "image" => "https://i.imgur.com/DWEb3J0.jpeg"
        )
    )
);

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
    'Authorization: Bearer ' . getAccessToken()
  ),
));

$response = curl_exec($curl);

curl_close($curl);
?>