<?php
session_start();

header("Access-Control-Allow-Origin: http://localhost:54245");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include './connection.php'; // Adjust path as per your setup

// Assuming $_POST['user_id'] contains the user ID sent from Flutter
$userId = isset($_POST['user_id']) ? $_POST['user_id'] : null;

if (!$userId) {
    // Handle case where user_id is missing
    $response = [
        'status' => 'error',
        'message' => 'Missing user_id parameter'
    ];
    echo json_encode($response);
    exit;
}

// Prepare and execute SQL query
$sql = "SELECT o.*, o.currently_place, o.fullName, o.phone, o.confirmation 
        FROM orders o 
        INNER JOIN drivers d ON o.user_email = d.email 
        WHERE d.user_id = ? AND o.confirmation = 'confirmed' 
        ORDER BY o.order_id DESC";
$stmt = mysqli_prepare($connect, $sql);
mysqli_stmt_bind_param($stmt, "i", $userId);
mysqli_stmt_execute($stmt);

$result = mysqli_stmt_get_result($stmt);

$response = [];

if ($result) {
    // Fetch all rows as associative array
    $orders = mysqli_fetch_all($result, MYSQLI_ASSOC);
    $response['status'] = 'success';
    $response['data'] = $orders;
} else {
    // Handle case where query fails
    $response['status'] = 'error';
    $response['message'] = 'Failed to fetch confirmed orders';
}

// Return JSON response
echo json_encode($response);
?>
