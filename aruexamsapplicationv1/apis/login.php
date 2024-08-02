<?php
// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Allow requests from the specified origin
header("Access-Control-Allow-Origin: http://localhost:64520");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include 'config.php';

$response = [];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'];
    $password = md5($_POST['password']);

    $sql = "SELECT * FROM users WHERE email = ? AND password = ?";
    $stmt = mysqli_prepare($conn, $sql);
    mysqli_stmt_bind_param($stmt, "ss", $email, $password);
    mysqli_stmt_execute($stmt);

    $result = mysqli_stmt_get_result($stmt);
    $count = mysqli_num_rows($result);

    if ($count == 1) {
        $user = mysqli_fetch_assoc($result);
        $response = ['status' => 'success', 'user' => $user];
    } else {
        $response = ['status' => 'error', 'message' => 'Invalid email or password'];
    }

    mysqli_stmt_close($stmt);
} else {
    $response = ['status' => 'error', 'message' => 'Method not allowed'];
}

echo json_encode($response);

// Check if JSON encoding failed
if (json_last_error() !== JSON_ERROR_NONE) {
    echo json_encode(['status' => 'error', 'message' => 'JSON encoding error: ' . json_last_error_msg()]);
}
?>
