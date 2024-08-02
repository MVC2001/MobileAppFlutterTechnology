<?php
header('Access-Control-Allow-Origin: http://localhost:64520');
header('Content-Type: application/json');

include 'config.php';

$fullName = isset($_GET['fullName']) ? $_GET['fullName'] : '';
$created_at = isset($_GET['created_at']) ? $_GET['created_at'] : '';

$sql = "SELECT booklet_id, fullName, school_id, department_id, quantity, description, created_at, confirmation
        FROM assignbooklets 
        WHERE fullName LIKE ? AND DATE(created_at) = ?";
$stmt = $conn->prepare($sql);

$searchFullName = "%$fullName%";

$stmt->bind_param("ss", $searchFullName, $created_at);

$stmt->execute();
$result = $stmt->get_result();

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);

$stmt->close();
$conn->close();
?>