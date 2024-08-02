<?php
// Allow requests from the specified origin
header("Access-Control-Allow-Origin: http://localhost:62871");

// Allow specific methods (GET in this case)
header("Access-Control-Allow-Methods: GET");

// Allow specific headers
header("Access-Control-Allow-Headers: Content-Type");

// Set the content type of the response
header("Content-Type: application/json");

include './connection.php';

$response = [];

// Prepare SQL Statement
$sql = "SELECT * FROM orders  ORDER BY order_id DESC";

$result = mysqli_query($connect, $sql);

if ($result) {
    $orders = mysqli_fetch_all($result, MYSQLI_ASSOC);
    $response['status'] = 'success';
    $response['data'] = $orders;
} else {
    $response['status'] = 'error';
    $response['message'] = 'Failed to fetch confirmed orders';
}

echo json_encode($response);
?>
