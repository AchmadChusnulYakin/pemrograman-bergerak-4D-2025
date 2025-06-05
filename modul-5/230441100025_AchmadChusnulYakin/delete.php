<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
include 'config.php';

$data = json_decode(file_get_contents("php://input"));
mysqli_query($conn, "DELETE FROM tiket_pendakian WHERE id = $data->id");
echo json_encode(["success" => true]);
?>
