<?php
$servername ="localhost";
$username="root";
$password ="";
$db_name="uber_clone";


$connect = mysqli_connect($servername,$username,$password,$db_name);


if($connect != true){
    echo json_encode("wrong connection");
}



?>