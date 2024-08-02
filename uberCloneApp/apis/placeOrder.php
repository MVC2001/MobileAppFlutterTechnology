<?php
include './connection.php';

// Allow requests from any origin (for testing purposes, adjust in production)
header("Access-Control-Allow-Origin: http://localhost:62871");

// Allow specific methods (POST in this case)
header("Access-Control-Allow-Methods: POST");

// Allow specific headers
header("Access-Control-Allow-Headers: Content-Type");

// Set the content type of the response
header("Content-Type: application/json");

try {
    // Check if it's a POST request
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // Escape and retrieve POST data
        $category = mysqli_real_escape_string($connect, $_POST['category']);
        $fullName = mysqli_real_escape_string($connect, $_POST['fullName']);
         $phone = mysqli_real_escape_string($connect, $_POST['phone']);
        $currently_place = mysqli_real_escape_string($connect, $_POST['currently_place']);
        $destination = mysqli_real_escape_string($connect, $_POST['destination']);

        // Insert new order
        $query = "INSERT INTO orders (category,fullName,phone,currently_place, destination) VALUES ('$category', '$fullName','$phone', '$currently_place', '$destination')";
        $result = mysqli_query($connect, $query);
        
        if ($result) {
            echo json_encode(array("status" => "success", "message" => "Order Placed Successfully"));
        } else {
            echo json_encode(array("status" => "error", "message" => "Error placing order"));
        }
    } else {
        // If it's not a POST request, return an error
        echo json_encode(array("status" => "error", "message" => "Method not allowed"));
    }
} catch (Exception $e) {
    echo json_encode(array("status" => "error", "message" => "An error occurred: " . $e->getMessage()));
}
?>
