<?php
require_once("../../vendor/autoload.php");

use Google\Client;
use GuzzleHttp\Client as GuzzleClient;

// Initialize Google Client
$client = new Client();
$client->setAuthConfig('../../../points-a1a14-firebase-adminsdk-wggts-d65c7381c1.json');
$client->addScope('https://www.googleapis.com/auth/firebase.messaging');

// Get access token
$accessToken = $client->fetchAccessTokenWithAssertion();

if (!isset($accessToken['access_token'])) {
    die('Failed to fetch access token');
}

$token = $accessToken['access_token'];

// FCM project ID and topic
$projectId = 'points-a1a14';
$topic = '/topics/all_users';

// Device tokens to be subscribed
$deviceTokens = [];

$users = selectDB("user","`id` != '0' GROUP BY `firebase` ORDER BY `id` ASC LIMIT 0,999");
for( $i = 0; $i < count($users); $i++ ){
    $deviceTokens[] = $users[$i]["firebase"];
}

// Create a new Guzzle HTTP client
$guzzleClient = new GuzzleClient();

try {
    // Send POST request to FCM to subscribe the tokens to the topic
    $response = $guzzleClient->post('https://iid.googleapis.com/iid/v1:batchAdd', [
        'headers' => [
            'Authorization' => 'Bearer ' . $token,
            'Content-Type' => 'application/json',
        ],
        'json' => [
            'to' => $topic,
            'registration_tokens' => $deviceTokens,
        ]
    ]);

    // Output the response from FCM
    echo 'Response: ' . $response->getBody();

} catch (Exception $e) {
    echo 'Error: ' . $e->getMessage();
}
?>