<?php
include 'config.php';


// Allow requests from the specified origin
header("Access-Control-Allow-Origin: http://localhost:64520");

// Allow specific methods (POST in this case)
header("Access-Control-Allow-Methods: POST");

// Allow specific headers
header("Access-Control-Allow-Headers: Content-Type");

// Set the content type of the response
header("Content-Type: application/json");

// Check if it's a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Escape and retrieve POST data
    $evaluatorsName = mysqli_real_escape_string($conn, $_POST['evaluatorsName']);
    $date = mysqli_real_escape_string($conn, $_POST['date']);
    $courseCode = mysqli_real_escape_string($conn, $_POST['courseCode']);
    $program = mysqli_real_escape_string($conn, $_POST['program']);
    $reasonFor = mysqli_real_escape_string($conn, $_POST['reasonFor']);
    $venueNo = mysqli_real_escape_string($conn, $_POST['venueNo']);
    $NoOfAdmittedStudents = mysqli_real_escape_string($conn, $_POST['NoOfAdmittedStudents']);
    $examsRoomCapacity = mysqli_real_escape_string($conn, $_POST['examsRoomCapacity']);
    $name = mysqli_real_escape_string($conn, $_POST['name']);
     $invRank = mysqli_real_escape_string($conn, $_POST['invRank']);
    $allStudentsIdentifiedAtEntry = mysqli_real_escape_string($conn, $_POST['allStudentsIdentifiedAtEntry']);
    $studentsFoundWithId = mysqli_real_escape_string($conn, $_POST['studentsFoundWithId']);
    $studentsFoundWithExpiredId = mysqli_real_escape_string($conn, $_POST['studentsFoundWithExpiredId']);
    $studentsFoundWithForgedId = mysqli_real_escape_string($conn, $_POST['studentsFoundWithForgedId']);
    $studentsFoundWithoutARUId = mysqli_real_escape_string($conn, $_POST['studentsFoundWithoutARUId']);
    $studentsFoundWithpRPdUPpermission = mysqli_real_escape_string($conn, $_POST['studentsFoundWithpRPdUPpermission']);
    $studentsFoundWithPoliceReport = mysqli_real_escape_string($conn, $_POST['studentsFoundWithPoliceReport']);
    $reasonForQualityAssessment = mysqli_real_escape_string($conn, $_POST['reasonForQualityAssessment']);
    $restrictionOfUnauthorizedMaterial = mysqli_real_escape_string($conn, $_POST['restrictionOfUnauthorizedMaterial']);
    $wereCorrectionsMadeToExamsPaper = mysqli_real_escape_string($conn, $_POST['wereCorrectionsMadeToExamsPaper']);
    $commitmentOfInv = mysqli_real_escape_string($conn, $_POST['commitmentOfInv']);
    $generalConductOfUE = mysqli_real_escape_string($conn, $_POST['generalConductOfUE']);
    $godOrBadOnPracticesObserved = mysqli_real_escape_string($conn, $_POST['godOrBadOnPracticesObserved']);
    $recommendation = mysqli_real_escape_string($conn, $_POST['recommendation']);
    $sittingArrOfStudents = mysqli_real_escape_string($conn, $_POST['sittingArrOfStudents']);
    $chairsAndTables = mysqli_real_escape_string($conn, $_POST['chairsAndTables']);
    $roomVentilation = mysqli_real_escape_string($conn, $_POST['roomVentilation']);

    // Insert the data into the database table
    $query = "INSERT INTO allQuestionnairesDetails (evaluatorsName, date, courseCode, program, reasonFor, venueNo, NoOfAdmittedStudents, examsRoomCapacity, name, allStudentsIdentifiedAtEntry, studentsFoundWithId, studentsFoundWithExpiredId, studentsFoundWithForgedId, studentsFoundWithoutARUId, studentsFoundWithpRPdUPpermission, studentsFoundWithPoliceReport, reasonForQualityAssessment, restrictionOfUnauthorizedMaterial, wereCorrectionsMadeToExamsPaper, commitmentOfInv, generalConductOfUE, godOrBadOnPracticesObserved, recommendation, sittingArrOfStudents, chairsAndTables, roomVentilation) 
              VALUES ('$evaluatorsName', '$date', '$courseCode', '$program', '$reasonFor', '$venueNo', '$NoOfAdmittedStudents', '$examsRoomCapacity', '$name', '$allStudentsIdentifiedAtEntry', '$studentsFoundWithId', '$studentsFoundWithExpiredId', '$studentsFoundWithForgedId', '$studentsFoundWithoutARUId', '$studentsFoundWithpRPdUPpermission', '$studentsFoundWithPoliceReport', '$reasonForQualityAssessment', '$restrictionOfUnauthorizedMaterial', '$wereCorrectionsMadeToExamsPaper', '$commitmentOfInv', '$generalConductOfUE', '$godOrBadOnPracticesObserved', '$recommendation', '$sittingArrOfStudents', '$chairsAndTables', '$roomVentilation')";
    
    $result = mysqli_query($conn, $query);
    
    if ($result) {
        echo json_encode(array("message" => "Data added successfully"));
    } else {
        echo json_encode(array("message" => "Error adding data"));
    }
} else {
    // If it's not a POST request, return an error
    echo json_encode(array("message" => "Method not allowed"));
}
?>
