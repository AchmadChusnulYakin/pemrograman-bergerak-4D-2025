<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
include 'config.php';

$data = json_decode(file_get_contents("php://input"));
$query = "INSERT INTO tiket_pendakian (nama_pendaki, gunung, jumlah_tiket, status_pembayaran, tanggal_pendakian)
VALUES ('$data->nama_pendaki', '$data->gunung', $data->jumlah_tiket, '$data->status_pembayaran', '$data->tanggal_pendakian')";
mysqli_query($conn, $query);
echo json_encode(["success" => true]);
?>
