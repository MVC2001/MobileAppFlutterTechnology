<?php
// Allow requests from the specified origin
header("Access-Control-Allow-Origin: http://localhost:50659");

// Allow specific methods (POST in this case)
header("Access-Control-Allow-Methods: POST");

// Allow specific headers
header("Access-Control-Allow-Headers: Content-Type");

// Set the content type of the response
header("Content-Type: application/json");

include './connection.php';

// Retrieve POST Data
$email = $_POST['email'];
$password = md5($_POST['password']); // Consider using more secure password hashing methods like bcrypt

// Prepare SQL Statement
$sql = "SELECT * FROM client WHERE email = ? AND password = ?";
$stmt = mysqli_prepare($connect, $sql);

// Bind Parameters and Execute
mysqli_stmt_bind_param($stmt, "ss", $email, $password);
mysqli_stmt_execute($stmt);

// Get Result
$result = mysqli_stmt_get_result($stmt);
$count = mysqli_num_rows($result);

// Check Result
if($count == 1){
    echo json_encode("Success");
} else {
    echo json_encode("Error: Invalid email or password");
}

// Close Statement
mysqli_stmt_close($stmt);
?>
