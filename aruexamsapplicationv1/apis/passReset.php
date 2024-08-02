<?php

// Allow requests from the specified origin
header("Access-Control-Allow-Origin: http://localhost:64520");

// Allow specific methods (POST in this case)
header("Access-Control-Allow-Methods: POST");

// Allow specific headers
header("Access-Control-Allow-Headers: Content-Type");

// Set the content type of the response
header("Content-Type: application/json");

include './connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'];
    $password = md5($_POST['password']);

    // Check if the email exists in the database
    $sql = "SELECT * FROM users WHERE email = '".$email."'";
    $result = mysqli_query($connect, $sql);
    $count = mysqli_num_rows($result);

    if ($count == 1) {
        $row = mysqli_fetch_assoc($result);
        $existingPassword = $row['password'];

        // Check if the provided password is different from the existing one
        if ($existingPassword == $password) {
            echo json_encode("Password is already set to the provided value");
        } else {
            // Update the user's password
            $updateSql = "UPDATE users SET password = '".$password."' WHERE email = '".$email."'";
            if (mysqli_query($connect, $updateSql)) {
                echo json_encode("Password reset successful");
            } else {
                echo json_encode("Error resetting password");
            }
        }
    } else {
        echo json_encode("Email not found");
    }
} else {
    echo json_encode("Method not allowed");
}
?>
