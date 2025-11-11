<?php 
$hot = "localhost";
$user = "root";
$spass = "";
$db = "suratwrga_db";

$coon = new mysqli($hot, $user, $spass, $db);
if ($coon->connect_error) {
    http_response_code(500);
    echo json_encode(["success" => false, "error" => "DB connect error: " . $coon->connect_error]);
    exit;
}