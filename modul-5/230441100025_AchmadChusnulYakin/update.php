<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
include 'config.php';

$data = json_decode(file_get_contents("php://input"));
$query = "UPDATE tiket_pendakian SET
  nama_pendaki = '$data->nama_pendaki',
  gunung = '$data->gunung',
  jumlah_tiket = $data->jumlah_tiket,
  status_pembayaran = '$data->status_pembayaran',
  tanggal_pendakian = '$data->tanggal_pendakian'
WHERE id = $data->id";
mysqli_query($conn, $query);
echo json_encode(["success" => true]);
?>
