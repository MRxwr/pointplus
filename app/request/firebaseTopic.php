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
    
    // Device tokens to send notifications (example with multiple tokens)
    $deviceTokens = [
        'fUFXZMAjSwa2d-ev0L4LoU:APA91bGp1hy27dlgGruuvtN4SDpyMHiDuFw8aS-uUysbnmZG31AI8IAnPHtDjo36xRwX4PxAgqKvL1pDlbXJQX7HVxCrNTjDjLMUQtZgpIZHNm0GSu7IxfwiG3Xhb-iWcLlr-c7NM3uf',
        'dNhhMxYblkF8pf_YhB7KGD:APA91bEVlozfW7Ymna4Y-b_heoGyjsexI6RWJVDCdahx0TIg0ubqONNSb7sXHtpN8LjEPy7Z5LnhvgGzIkBMFRePSs1aMzwUStaffEFuiZNESMBOe_0bDhiVFJPmOT4SmobwaZDGgzXD',
        // Add more tokens as needed (up to 1000 tokens per request)
    ];
    
    // Create a new Guzzle HTTP client
    $guzzleClient = new GuzzleClient();
    
    try {
        // Send POST request to FCM to send a notification to multiple device tokens
        $response = $guzzleClient->post('https://fcm.googleapis.com/v1/projects/points-a1a14/messages:send', [
            'headers' => [
                'Authorization' => 'Bearer ' . $token,
                'Content-Type' => 'application/json',
            ],
            'json' => [
                'message' => [
                    'tokens' => $deviceTokens, // use the tokens field here
                    'notification' => [
                        'body' => 'test body e i',
                        'title' => 'test title',
                        'image' => 'https://i.imgur.com/DWEb3J0.jpeg'
                    ]
                ]
            ]
        ]);
    
        // Output the response from FCM
        echo 'Response: ' . $response->getBody() . "\n";
    
    } catch (Exception $e) {
        echo 'Error: ' . $e->getMessage() . "\n";
    }
    
?>