CREATE DATABASE tiket_pendakian;
USE tiket_pendakian;

CREATE TABLE tiket_pendakian (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama_pendaki VARCHAR(100),
  gunung VARCHAR(100),
  jumlah_tiket INT,
  status_pembayaran ENUM('lunas', 'belum lunas'),
  tanggal_pendakian DATE
);

SELECT * FROM tiket_pendakian;