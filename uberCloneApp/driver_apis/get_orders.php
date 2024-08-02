<?php
header("Access-Control-Allow-Origin: http://localhost:54245");
header("Content-Type: application/json");

include './connection.php'; // Adjust path as per your setup

$response = [];

// Fetch orders from your database table
$sql = "SELECT * FROM orders where   confirmation !='confirmed' ";
$result = mysqli_query($connect, $sql);

if ($result) {
    $orders = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $orders[] = $row;
    }
    $response['status'] = 'success';
    $response['data'] = $orders;
} else {
    $response['status'] = 'error';
    $response['message'] = 'Failed to fetch orders';
}

// Adding a header to the JSON response
echo json_encode($response);
?>
