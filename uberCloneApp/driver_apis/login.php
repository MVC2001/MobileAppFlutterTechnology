<?php
session_start();

header("Access-Control-Allow-Origin: http://localhost:54245");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include './connection.php'; // Adjust path as per your setup

$data = json_decode(file_get_contents("php://input"));

$email = $data->email;
$password = md5($data->password); // MD5 hash of the password

$stmt = $connect->prepare("SELECT user_id, email FROM drivers WHERE email = ? AND password = ?");
$stmt->bind_param("ss", $email, $password);
$stmt->execute();
$result = $stmt->get_result();

$response = array();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $_SESSION['user_id'] = $row['user_id']; // Store user_id in session
    $response['status'] = "Success";
    $response['user_id'] = $row['user_id'];
    $response['email'] = $row['email'];
} else {
    $response['status'] = "Error";
    $response['message'] = "Invalid credentials";
}

echo json_encode($response);
$connect->close();
?>
