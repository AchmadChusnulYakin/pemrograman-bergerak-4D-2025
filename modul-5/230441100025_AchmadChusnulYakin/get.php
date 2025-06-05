<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
include 'config.php';

$query = mysqli_query($conn, "SELECT * FROM tiket_pendakian ORDER BY tanggal_pendakian DESC");
$data = [];
while ($row = mysqli_fetch_assoc($query)) {
  $data[] = $row;
}
echo json_encode($data);
?>
