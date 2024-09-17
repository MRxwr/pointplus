<?php
require 'vendor/autoload.php'; // Ensure you have the Google API Client installed

use Google\Client;

// Function to generate an OAuth 2.0 access token
function getAccessToken() {
    $serviceAccountKeyFile = 'path/to/your/serviceAccountKey.json';  // Replace with the correct path

    // Initialize the Google API Client
    $client = new Client();
    $client->setAuthConfig($serviceAccountKeyFile);

    // Define the scope for Firebase Cloud Messaging (FCM)
    $client->addScope('https://www.googleapis.com/auth/firebase.messaging');

    // Fetch the access token
    $token = $client->fetchAccessTokenWithAssertion();

    return $token['access_token'];
}

// Function to send a notification to a topic with an image
function sendNotificationToTopic($topic, $notificationData) {
    $accessToken = getAccessToken();  // Generate the OAuth 2.0 token

    $url = "https://fcm.googleapis.com/v1/projects/YOUR_PROJECT_ID/messages:send";  // Replace with your project ID

    // Notification message with an image
    $data = [
        "message" => [
            "topic" => $topic,  // The topic name
            "notification" => [
                "title" => $notificationData['title'],
                "body" => $notificationData['body'],
                "image" => $notificationData['image'],  // URL to the image
            ],
            "data" => $notificationData['data']  // Optional custom data
        ]
    ];

    // Initialize cURL
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Authorization: Bearer ' . $accessToken,  // Use the OAuth 2.0 token for authentication
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
$notificationData = [
    'title' => 'Hello, World!',
    'body' => 'This is a notification with an image.',
    'image' => 'https://example.com/path/to/your/image.jpg',  // Replace with a valid image URL
    'data' => ['key1' => 'value1', 'key2' => 'value2']  // Optional custom data
];
$topic = "your_topic_name";  // The same topic you subscribed the devices to
sendNotificationToTopic($topic, $notificationData);


?>