<?php
header("Access-Control-Allow-Origin: http://localhost:54245");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Assuming you have a database connection already established
include './connection.php';

// Retrieve JSON data from POST body
$data = json_decode(file_get_contents("php://input"));

// Check if required fields are present
if(isset($data->order_id) && isset($data->confirmation) && isset($data->user_email)) {
    $orderId = $data->order_id;
    $confirmation = $data->confirmation;
    $userEmail = $data->user_email;

    // Perform update query
    $query = "UPDATE orders SET confirmation = '$confirmation', user_email = '$userEmail' WHERE order_id = $orderId";
    $result = mysqli_query($connect, $query);

    if($result) {
        echo json_encode(array("status" => "success", "message" => "Order updated successfully"));
    } else {
        echo json_encode(array("status" => "error", "message" => "Failed to update order"));
    }
} else {
    echo json_encode(array("status" => "error", "message" => "Missing required fields"));
}
?>
