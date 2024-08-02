<?php
header('Access-Control-Allow-Origin: http://localhost:64520');
header('Access-Control-Allow-Methods: POST');
header('Content-Type: application/json');

// Include your database configuration
include 'config.php';

// Get POST data
$fullName = $_POST['fullName'] ?? '';
$schoolId = $_POST['school_id'] ?? '';
$departmentId = $_POST['department_id'] ?? '';
$courseCode = $_POST['courseCode'] ?? '';
$program = $_POST['program'] ?? '';
$totalStudents = $_POST['totalStudents'] ?? '';
$bookletsUsed = $_POST['bookletsUsed'] ?? '';
$unUsedBooklets = $_POST['unUsedBooklets'] ?? '';
$usedScripts = $_POST['usedScripts'] ?? '';
$unUsedScripts = $_POST['unUsedScripts'] ?? '';
$description = $_POST['description'] ?? '';

// Your SQL query to insert data into the overallinvigilationreport table
$sql = "INSERT INTO overallinvigilationreport (fullName, school_id, department_id, courseCode, program, totalStudents, bookletsUsed, unUsedBooklets, usedScripts, unUsedScripts, description) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);

$stmt->bind_param("sssssssssss", $fullName, $schoolId, $departmentId, $courseCode, $program, $totalStudents, $bookletsUsed, $unUsedBooklets, $usedScripts, $unUsedScripts, $description);

if ($stmt->execute()) {
    echo json_encode(array("status" => "success"));
} else {
    echo json_encode(array("status" => "error", "message" => "Failed to create report"));
}

$stmt->close();
$conn->close();
?>
