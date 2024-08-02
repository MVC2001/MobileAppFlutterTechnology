<?php
// Allow requests from the specified origin
header("Access-Control-Allow-Origin: http://localhost:50659");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include './connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'];
    $oldPassword = md5($_POST['old_password']);
    $newPassword = md5($_POST['new_password']);

    // Check if the email exists in the database
    $sql = "SELECT * FROM client WHERE email = '".$email."'";
    $result = mysqli_query($connect, $sql);
    $count = mysqli_num_rows($result);

    if ($count == 1) {
        $row = mysqli_fetch_assoc($result);
        $existingPassword = $row['password'];

        // Check if the provided old password matches the existing one
        if ($existingPassword == $oldPassword) {
            // Update the user's password
            $updateSql = "UPDATE client SET password = '".$newPassword."' WHERE email = '".$email."'";
            if (mysqli_query($connect, $updateSql)) {
                echo json_encode("Password reset successful");
            } else {
                echo json_encode("Error resetting password");
            }
        } else {
            echo json_encode("Incorrect old password");
        }
    } else {
        echo json_encode("Email not found");
    }
} else {
    echo json_encode("Method not allowed");
}
?>
