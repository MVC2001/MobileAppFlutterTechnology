<?php
include './connection.php';

// Allow requests from the specified origin
header("Access-Control-Allow-Origin: http://localhost:54245");

// Allow specific methods (POST in this case)
header("Access-Control-Allow-Methods: POST");

// Allow specific headers
header("Access-Control-Allow-Headers: Content-Type");

// Set the content type of the response
header("Content-Type: application/json");

// Check if it's a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Escape and retrieve POST data
    $fullName = mysqli_real_escape_string($connect, $_POST['fullName']);
    $phone = mysqli_real_escape_string($connect, $_POST['phone']);
    $currentlyPlace = mysqli_real_escape_string($connect, $_POST['currently_place']);
    $email = mysqli_real_escape_string($connect, $_POST['email']);
    $password = mysqli_real_escape_string($connect, md5($_POST['password']));
    $city = mysqli_real_escape_string($connect, $_POST['city']);
    $vehicleName = mysqli_real_escape_string($connect, $_POST['vehicle_name']);
    $licensePlate = mysqli_real_escape_string($connect, $_POST['license_plate']);

    // Check if email already exists
    $query_check_email = "SELECT * FROM drivers WHERE email='$email'";
    $result_check_email = mysqli_query($connect, $query_check_email);

    if (mysqli_num_rows($result_check_email) > 0) {
        // Email already exists
        echo json_encode(array("message" => "Email already taken"));
    } else {
        // Insert new driver
        $query = "INSERT INTO drivers (fullName, phone, currently_place, email, password, city, vehicle_name, license_plate) 
                  VALUES ('$fullName', '$phone', '$currentlyPlace', '$email', '$password', '$city', '$vehicleName', '$licensePlate')";
        $result = mysqli_query($connect, $query);
        if ($result) {
            echo json_encode(array("message" => "Registration Successful"));
        } else {
            echo json_encode(array("message" => "Error registering user"));
        }
    }
} else {
    // If it's not a POST request, return an error
    echo json_encode(array("message" => "Method not allowed"));
}
?>
