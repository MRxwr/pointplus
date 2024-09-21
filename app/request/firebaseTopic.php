<?php
/*
require_once("../../vendor/autoload.php");
use Google\Client;
use Guzzle\Http\Client as HttpClient;
use Guzzle\Http\Message\Request;


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

    $client = new Client();
    $headers = [
        'Authorization: Bearer ' . $accessToken,
        'Content-Type: application/json',
    ];
    $request = new Request('GET', 'https://pointplus.app/app/request/?action=firebaseTopic', $headers);
    $res = $client->sendAsync($request)->wait();
    echo $res->getBody();


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
    */
require_once("../../vendor/autoload.php");
use Google\Client;
use GuzzleHttp\Client as GuzzleClient;
use GuzzleHttp\Exception\RequestException;

// Initialize Google Client
$client = new Client();
$client->setAuthConfig('../../../points-a1a14-firebase-adminsdk-wggts-9dc0474399.json');
$client->addScope('https://www.googleapis.com/auth/firebase.messaging');

// Get the access token
echo $token = $client->fetchAccessTokenWithAssertion()['access_token'];

// Firebase project ID (replace with your Firebase project ID)
$projectId = 'points-a1a14';

// Topic to which devices will be subscribed
$topic = 'all_users';
$users = selectDB("user","`id` != '0' GROUP BY `firebase`");
for( $i = 0; $i < count($users); $i++ ){
    $tokens[] = $users[$i]["firebase"];
}
// Device tokens to be subscribed to the topic
$deviceTokens = $tokens;

// Prepare the request data
$postData = [
    'registration_tokens' => $deviceTokens
];

// FCM URL for subscribing to a topic
$url = "https://iid.googleapis.com/iid/v1:batchAdd";

// Create a new Guzzle HTTP client
$guzzleClient = new GuzzleClient();

try {
    // Send the POST request to FCM
    $response = $guzzleClient->post($url, [
        'headers' => [
            'Authorization' => 'Bearer ' . $token,
            'Content-Type' => 'application/json',
        ],
        'json' => [
            'to' => '/topics/' . $topic,
            'registration_tokens' => $deviceTokens
        ]
    ]);

    // Get the response body
    $body = $response->getBody();
    echo "Response: " . $body;

} catch (RequestException $e) {
    echo "Error: " . $e->getMessage();
}
?>