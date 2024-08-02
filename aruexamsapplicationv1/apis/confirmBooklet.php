<?php
// Allow from any origin for testing purposes
header('Access-Control-Allow-Origin: http://localhost:64520');

// Set the content type to application/json
header('Content-Type: application/json');

// Include your database configuration
include 'config.php';

// Get the search parameters from the query string
$booklet_id = isset($_POST['booklet_id']) ? $_POST['booklet_id'] : '';

// Prepare the SQL query with placeholders
$sql = "UPDATE assignbooklets SET confirmation = 'confirmed' WHERE booklet_id = ?";
$stmt = $conn->prepare($sql);

// Bind the parameters to the SQL query
$stmt->bind_param("i", $booklet_id);

// Execute the query
$success = $stmt->execute();

// Prepare the response
$response = [];
if ($success) {
    $response['status'] = 'success';
    $response['message'] = 'Booklet confirmed successfully';
} else {
    $response['status'] = 'error';
    $response['message'] = 'Failed to confirm booklet';
}

// Encode the response to JSON and output it
echo json_encode($response);

// Close the statement and the connection
$stmt->close();
$conn->close();
?>
