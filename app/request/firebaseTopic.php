<?php
require_once("../../vendor/autoload.php");
use Google\Client;

function getAccessToken() {
    // Path to your service account key
    $serviceAccountKeyFile = '../../../points-a1a14-firebase-adminsdk-wggts-9dc0474399.json';

    // Initialize the Google API Client
    $client = new Client();
    $client->setAuthConfig($serviceAccountKeyFile);

    // Define the scopes you need (for FCM, you need cloud messaging scope)
    $client->addScope('https://www.googleapis.com/auth/firebase.messaging');

    // Fetch the access token
    $token = $client->fetchAccessTokenWithAssertion();

    return $token['access_token'];
}

function subscribeTokensToTopic($tokens, $topic) {
    $accessToken = getAccessToken();  // OAuth token generated earlier (use the method from previous steps)

    $url = "https://iid.googleapis.com/iid/v1:batchAdd";

    // Prepare the data for the POST request
    $data = [
        "to" => "/topics/" . $topic,  // Topic name
        "registration_tokens" => $tokens  // Array of device tokens
    ];

    // Initialize cURL
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Authorization: Bearer ' . $accessToken,
        'Content-Type: application/json',
    ]);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

    // Execute the cURL request
    $response = curl_exec($ch);

    // Check for errors
    if ($response === false) {
        echo 'Error: ' . curl_error($ch);
    } else {
        echo 'Response: ' . $response;
    }

    // Close cURL
    curl_close($ch);
}

// Example usage
$topic = "all_users";  // Replace with the topic name you want to subscribe the devices to
$users = selectDB("user","`id` != '0' GROUP BY `firebase` LIMIT 0, 1000");
for( $i = 0; $i < count($users); $i++ ){
    $tokens[] = $users[$i]["firebase"];
}
subscribeTokensToTopic($tokens, $topic);
?>