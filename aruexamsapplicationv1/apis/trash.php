<?php
header('Access-Control-Allow-Origin: http://localhost:53459');
header('Content-Type: application/json');

include 'config.php';

$fullName = isset($_GET['fullName']) ? $_GET['fullName'] : '';
$created_at = isset($_GET['created_at']) ? $_GET['created_at'] : '';

$sql = "SELECT script_id, fullName, school_id, department_id, courseCode, program, quantity, description, confirmation, created_at
        FROM assscript 
        WHERE userId = ? AND fullName LIKE ?";
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
