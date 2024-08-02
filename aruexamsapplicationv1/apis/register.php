<?php
header("Access-Control-Allow-Origin: http://localhost:64520");
header("Content-Type: application/json; charset=UTF-8");

include 'config.php';

// Get POST data
$fullName = $_POST['fullName'];
$email = $_POST['email'];
$password = md5($_POST['password']);

// Check if username or email already exists
$sql_check = "SELECT * FROM users WHERE fullName = '$fullName' OR email = '$email'";
$result_check = $conn->query($sql_check);

if ($result_check->num_rows > 0) {
    $response['status'] = 'error';
    $response['message'] = 'Username or email already exists';
} else {
    // Prepare SQL statement
    $sql = "INSERT INTO users (fullName, email, password) VALUES ('$fullName', '$email', '$password')";

    if ($conn->query($sql) === TRUE) {
        $response['status'] = 'success';
    } else {
        $response['status'] = 'error';
        $response['message'] = 'Error: ' . $conn->error;
    }
}

// Close database connection
$conn->close();

// Return JSON response
echo json_encode($response);
?>
