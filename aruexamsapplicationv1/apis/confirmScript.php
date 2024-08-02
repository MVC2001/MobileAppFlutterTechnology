<?php
// Allow from any origin for testing purposes
header('Access-Control-Allow-Origin: http://localhost:64520');

// Set the content type to application/json
header('Content-Type: application/json');

// Include your database configuration
include 'config.php';

// Get the script_id from the POST request
$script_id = isset($_POST['script_id']) ? $_POST['script_id'] : '';

// Prepare the SQL query with placeholders
$sql = "UPDATE assscript SET confirmation = 'confirmed' WHERE script_id = ?";
$stmt = $conn->prepare($sql);

// Bind the parameters to the SQL query
$stmt->bind_param("i", $script_id);

// Execute the query
$success = $stmt->execute();

// Prepare the response
$response = [];
if ($success) {
    $response['status'] = 'success';
    $response['message'] = 'Script confirmed successfully';
} else {
    $response['status'] = 'error';
    $response['message'] = 'Failed to confirm script';
}

// Encode the response to JSON and output it
echo json_encode($response);

// Close the statement and the connection
$stmt->close();
$conn->close();
?>
