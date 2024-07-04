<?php
require 'vendor/autoload.php';
 
use Aws\Sns\SnsClient;
use Aws\Exception\AwsException;
 
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $name = $_POST["name"];
    $email = $_POST["email"];
    $message = $_POST["message"];
 
    // Replace 'your-sns-topic-arn' with the ARN of your SNS topic
    $snsTopicArn = 'arn:aws:sns:us-east-1:XXXXXXX:test';
 
    // Initialize SNS client
    $snsClient = new SnsClient([
        'version' => 'latest',
        'region' => 'us-east-1' // Replace with your desired AWS region
    ]);
 
    // Create message to send to SNS topic
    $messageToSend = json_encode([
        'email' => $email,
        'name' => $name,
        'message' => $message
    ]);
 
    try {
        // Publish message to SNS topic
        $snsClient->publish([
            'TopicArn' => $snsTopicArn,
            'Message' => $messageToSend
        ]);
 
        echo "Message sent successfully.";
    } catch (AwsException $e) {
        echo "Error sending message: " . $e->getMessage();
    }
} else {
    http_response_code(405);
    echo "Method Not Allowed";
}
?>
