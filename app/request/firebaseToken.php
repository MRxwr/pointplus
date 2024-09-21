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

// Example usage
$accessToken = getAccessToken();
echo outputData($accessToken);

?>