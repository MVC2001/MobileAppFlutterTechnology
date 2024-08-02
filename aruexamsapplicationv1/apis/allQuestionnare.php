<?php
// Allow from any origin
header('Access-Control-Allow-Origin: http://localhost:64520');

// Set the content type to application/json
header('Content-Type: application/json');

include 'config.php';


// SQL query to select all records from the table
$sql = "SELECT * FROM allQuestionnairesDetails";
$result = $conn->query($sql);

$rows = array();
if ($result->num_rows > 0) {
    // Fetch all records and store them in an array
    while($row = $result->fetch_assoc()) {
        $rows[] = $row;
    }
} else {
    // No records found, return an empty array
    $rows = array();
}

// Close the database connection
$conn->close();

// Echo the JSON encoded array
echo json_encode($rows);
?>
