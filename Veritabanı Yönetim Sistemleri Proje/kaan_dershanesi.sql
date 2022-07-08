-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 31 May 2021, 19:15:53
-- Sunucu sürümü: 10.4.14-MariaDB
-- PHP Sürümü: 7.4.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `dershanedb`
--

DELIMITER $$
--
-- Yordamlar
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `devamsizlik_ekle` (IN `TC` VARCHAR(11), IN `GUN` DATE, IN `SURE` DOUBLE(2,1))  NO SQL
    DETERMINISTIC
BEGIN
DECLARE D INT(11);
SET D = (SELECT ogrenciID FROM tblogrenci WHERE ogrenciTC=TC);
INSERT INTO tbldevamsizlik (ogrenciID, devamsizlikTarih, devamsizlikSure) VALUES (D, GUN, SURE);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `maas_guncelleme` (IN `TC` VARCHAR(11), IN `MAAS` DOUBLE(15,2))  NO SQL
UPDATE tblogretmen
SET Maas = MAAS
WHERE tblogretmen.ogretmenTC=TC$$

--
-- İşlevler
--
CREATE DEFINER=`root`@`localhost` FUNCTION `en_yakin_ders` (`TC` VARCHAR(11)) RETURNS DATE NO SQL
BEGIN
DECLARE d DATE;
  SET d = (SELECT d.dersTarih
FROM tblogretmen o INNER JOIN tblders d ON o.ogretmenID=d.ogretmenID
WHERE o.ogretmenTC=TC AND d.dersTarih >= NOW()
ORDER BY d.dersTarih ASC
LIMIT 1);
  RETURN d;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `kasada_bulunan_para` () RETURNS DOUBLE(15,2) UNSIGNED ZEROFILL NO SQL
    DETERMINISTIC
BEGIN
DECLARE profit DOUBLE(15,2);
SET profit = (SELECT SUM(odemeMiktar) FROM tblodeme);
RETURN profit;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `tblbrans`
--

CREATE TABLE `tblbrans` (
  `bransID` int(11) NOT NULL,
  `bransAdi` varchar(50) COLLATE utf8_turkish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `tblbrans`
--

INSERT INTO `tblbrans` (`bransID`, `bransAdi`) VALUES
(1, 'Matematik'),
(2, 'Kimya'),
(3, 'Fizik'),
(4, 'Türkçe'),
(5, 'İngilizce'),
(6, 'Biyoloji'),
(7, 'Coğrafya'),
(8, 'Tarih');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `tblders`
--

CREATE TABLE `tblders` (
  `dersID` int(11) NOT NULL,
  `dersTarih` date DEFAULT NULL,
  `sinifID` int(11) DEFAULT NULL,
  `ogretmenID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `tblders`
--

INSERT INTO `tblders` (`dersID`, `dersTarih`, `sinifID`, `ogretmenID`) VALUES
(2, '2020-12-24', 5, 1),
(4, '2020-12-24', 1, 5),
(6, '2020-12-24', 3, 6),
(15, '2020-12-30', 6, 1),
(17, '2021-05-31', 5, 18),
(18, '2021-06-08', 1, 14),
(19, '2021-06-10', 1, 14),
(20, '2021-06-12', 1, 14);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `tbldevamsizlik`
--

CREATE TABLE `tbldevamsizlik` (
  `devamsizlikID` int(200) NOT NULL,
  `ogrenciID` int(200) DEFAULT NULL,
  `devamsizlikTarih` date DEFAULT NULL,
  `devamsizlikSure` double(2,1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `tbldevamsizlik`
--

INSERT INTO `tbldevamsizlik` (`devamsizlikID`, `ogrenciID`, `devamsizlikTarih`, `devamsizlikSure`) VALUES
(1, 1, '2020-01-14', 1.0),
(2, 2, '2020-01-15', 1.0),
(3, 4, '2020-01-21', 0.5),
(4, 9, '2021-05-01', 1.0),
(5, 9, '2021-05-02', 1.0),
(6, 9, '2021-05-03', 0.5),
(7, 9, '2021-05-10', 1.0),
(8, 9, '2021-05-11', 1.0),
(9, 6, '2021-05-02', 1.0),
(10, 9, '2021-05-12', 1.0),
(11, 4, '2021-05-17', 1.0),
(12, 9, '2021-05-24', 1.0),
(13, 4, '2021-05-03', 1.0),
(14, 4, '2021-05-09', 1.0),
(15, 4, '2021-05-25', 1.0),
(16, 4, '2021-05-28', 1.0),
(17, 15, '2021-05-17', 1.0),
(19, 7, '2021-04-30', 0.5);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `tblkategori`
--

CREATE TABLE `tblkategori` (
  `kategoriID` int(11) NOT NULL,
  `kategoriAdi` varchar(50) COLLATE utf8_turkish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `tblkategori`
--

INSERT INTO `tblkategori` (`kategoriID`, `kategoriAdi`) VALUES
(1, '8.sınıf'),
(2, '9.sınıf'),
(3, '10.sınıf'),
(4, '11.sınıf'),
(5, '12.sınıf'),
(6, 'Mezun');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `tblodeme`
--

CREATE TABLE `tblodeme` (
  `odemeID` int(11) NOT NULL,
  `ogrenciID` int(11) DEFAULT NULL,
  `odeyenAdi` varchar(50) COLLATE utf8_turkish_ci DEFAULT NULL,
  `odeyenSoyadi` varchar(50) COLLATE utf8_turkish_ci DEFAULT NULL,
  `odemeMiktar` decimal(15,2) DEFAULT NULL,
  `odemeTarih` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `tblodeme`
--

INSERT INTO `tblodeme` (`odemeID`, `ogrenciID`, `odeyenAdi`, `odeyenSoyadi`, `odemeMiktar`, `odemeTarih`) VALUES
(1, 1, 'Nedime', 'Alparslan', '6000.00', '2020-01-01'),
(2, 2, 'Furkan', 'Ünal', '3500.00', '2020-01-02'),
(3, 3, 'Murat', 'Gezgin', '3000.00', '2020-01-10'),
(4, 4, 'Deniz', 'Oklava', '6000.00', '2020-01-03'),
(5, 5, 'Onur', 'Durmuş', '4500.00', '2020-01-05'),
(6, 6, 'Gamze', 'Dürbün', '3500.00', '2020-01-09'),
(7, 11, 'Ali ', 'Tava', '5750.00', '2021-05-29');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `tblogrenci`
--

CREATE TABLE `tblogrenci` (
  `ogrenciID` int(11) NOT NULL,
  `ogrenciAdi` varchar(50) COLLATE utf8_turkish_ci DEFAULT NULL,
  `ogrenciSoyadi` varchar(50) COLLATE utf8_turkish_ci DEFAULT NULL,
  `ogrenciTC` varchar(11) COLLATE utf8_turkish_ci DEFAULT NULL,
  `ogrenciAdres` varchar(200) COLLATE utf8_turkish_ci DEFAULT NULL,
  `ogrenciKitapDurum` varchar(50) COLLATE utf8_turkish_ci DEFAULT NULL,
  `sinifID` int(11) DEFAULT NULL,
  `veliID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `tblogrenci`
--

INSERT INTO `tblogrenci` (`ogrenciID`, `ogrenciAdi`, `ogrenciSoyadi`, `ogrenciTC`, `ogrenciAdres`, `ogrenciKitapDurum`, `sinifID`, `veliID`) VALUES
(1, 'Kaan', 'Alparslan', '54621548573', 'Paşa Mh. Güzeller Apart. No:15/4 Kartal', 'Almadı', 6, 1),
(2, 'Ayça', 'Geçmiş', '45621514253', 'Torun Mh. Şimşek Apart. No:15/4 Üsküdar', 'Aldı', 4, 2),
(3, 'Ali', 'Gezgin', '65897854278', 'Dursun Mh. Gemiş Apart. No:13/2 Levent', 'Almadı', 3, 3),
(4, 'Anıl', 'Durmuş', '65897854213', 'Kireç Mh. Gürcistan Apart. No:23/2 Zincirlikuyu', 'Aldı', 6, 4),
(5, 'Sinem', 'Oklava', '54879856321', 'Çerez Mh. Küçük Apart. No:13/5 Mecidiyeköy', 'Aldı', 5, 5),
(6, 'Gizem', 'Dürbün', '54653221546', 'Çamlıca Mh. Kireçhane Apart. No:39/5 Şişli', 'Almadı', 4, 6),
(7, 'Ali', 'Çakır', '34434343433', 'Lamba Mh. No: 16/3 Şişli', 'Almadı', 1, 7),
(8, 'Ozan', 'Pamuk', '67676776676', 'Pamuk Mh. No: 88/4 Arnavutköy', 'Almadı', 2, 8),
(9, 'Hilal', 'Hol', '65565656565', 'Paşa Mh. No: 16/4 Bakırköy', 'Aldı', 2, 9),
(10, 'Ayça', 'Sönmez', '34433434433', 'Çınar Mh. No: 19/4 Beşiktaş', 'Aldı', 3, 10),
(11, 'Ebru', 'Çiçek', '21212121211', 'Kedi Mh. No: 28/4 Arnavutköy', 'Aldı', 4, 11),
(12, 'Mert', 'Düzine', '54122365898', NULL, 'Aldı', 1, 12),
(13, 'Gamze', 'Kaygısız', '87543256985', NULL, 'Almadı', 5, 13),
(14, 'Erhan', 'Çelik', '78455623896', NULL, 'Almadı', 1, 14),
(15, 'Yelda', 'Gül', '87546532659', 'Yağmur Mh. No:19/5 Feriköy', 'Almadı', 5, 15);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `tblogretmen`
--

CREATE TABLE `tblogretmen` (
  `ogretmenID` int(11) NOT NULL,
  `ogretmenAdi` varchar(50) COLLATE utf8_turkish_ci DEFAULT NULL,
  `ogretmenSoyadi` varchar(50) COLLATE utf8_turkish_ci DEFAULT NULL,
  `ogretmenTC` varchar(11) COLLATE utf8_turkish_ci DEFAULT NULL,
  `ogretmenTelNo` varchar(11) COLLATE utf8_turkish_ci DEFAULT NULL,
  `ogretmenAdres` varchar(200) COLLATE utf8_turkish_ci DEFAULT NULL,
  `bransID` int(11) DEFAULT NULL,
  `Maas` decimal(15,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `tblogretmen`
--

INSERT INTO `tblogretmen` (`ogretmenID`, `ogretmenAdi`, `ogretmenSoyadi`, `ogretmenTC`, `ogretmenTelNo`, `ogretmenAdres`, `bransID`, `Maas`) VALUES
(1, 'Ceyda', 'İnce', '12346712984', '05352451876', 'Ortabayır, Bacadibi Sk. No 24/A Arnavutköy', 2, '5000.00'),
(4, 'Özgür ', 'Çalışkan', '59261365984', '05368956425', 'Günaydın Mahallesi Atatürk cd, Gül apt, no: 15/8 K', 3, '7260.00'),
(5, 'Zeynep', 'Geçmez', '26142502369', '05345874962', 'Mustafa Kemal Mh. Darıca Sokak 17/4 Şişli', 4, '7865.00'),
(6, 'Kübra', 'Şimşek', '48572613569', '05341265983', 'Atatürk Caddesi, Gül apartmanı, No: 15 Daire: 8 Be', 5, '8470.00'),
(11, 'Buse', 'Taşçı', '22147854785', '05417845691', 'Fevzi Çakmak Mah. Bediüzzaman Cad. Anibal Sok. No: 28/1', 1, '6050.00'),
(12, 'Abdulhamit', 'Savunucu', '44781247853', '05054782145', 'Fevzi Çakmak Mah. Erzincan Cad. (Kaynarca Spor Tesisleri Karşısı) ', 1, '6000.00'),
(13, 'Merve', 'Koç', '44157896412', '05084751247', 'Örnek Mah. Deneme Sk. No:24/8 Ankara', 1, '6000.00'),
(14, 'Veli', 'Köylü', '22485764125', '05054861278', 'Kızılay, İzmir-1 Cd. No:6, 06420', 4, '6000.00'),
(15, 'Burak', 'Çekmece', '44785124578', '05314573200', 'Kızılay, Atatürk Blv 60-3, 06420', 4, '5500.00'),
(16, 'Mehmet', 'Ay', '11147854233', NULL, 'Menderes mah. 123.sok 24/3', 1, '6050.00'),
(17, 'Pınar', 'Demircioğlu', '12478546310', NULL, 'Fevzi çakmak mah. 127.sokak 11/7', 1, '6352.50'),
(18, 'Ahmad', 'Al Khas', '11478546201', NULL, 'Nine hatun mah. 18.sokak 17/1', 4, '5500.00'),
(20, 'Mehmet', 'Hasan', '11478541246', '05478941250', 'Çanakkale mahallesi 123. sokak 17/5', NULL, '5500.00'),
(21, 'Mustafa', 'Özkaynak', '44785145632', '05417854126', 'Erzincan mahallesi 145.sokak 17/2', NULL, '6000.00');

--
-- Tetikleyiciler `tblogretmen`
--
DELIMITER $$
CREATE TRIGGER `kayit_silme` AFTER DELETE ON `tblogretmen` FOR EACH ROW DELETE tblders FROM tblders
WHERE tblders.ogretmenID=OLD.ogretmenID
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `tblsinif`
--

CREATE TABLE `tblsinif` (
  `sinifID` int(11) NOT NULL,
  `subeID` int(11) DEFAULT NULL,
  `kategoriID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `tblsinif`
--

INSERT INTO `tblsinif` (`sinifID`, `subeID`, `kategoriID`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 1, 4),
(5, 1, 5),
(6, 1, 6);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `tblsube`
--

CREATE TABLE `tblsube` (
  `subeID` int(11) NOT NULL,
  `subeAdi` varchar(50) COLLATE utf8_turkish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `tblsube`
--

INSERT INTO `tblsube` (`subeID`, `subeAdi`) VALUES
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E'),
(6, 'F');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `tblveli`
--

CREATE TABLE `tblveli` (
  `veliID` int(11) NOT NULL,
  `veliAdi` varchar(50) COLLATE utf8_turkish_ci DEFAULT NULL,
  `veliSoyadi` varchar(50) COLLATE utf8_turkish_ci DEFAULT NULL,
  `veliTC` varchar(11) COLLATE utf8_turkish_ci DEFAULT NULL,
  `veliTelNo` varchar(11) COLLATE utf8_turkish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `tblveli`
--

INSERT INTO `tblveli` (`veliID`, `veliAdi`, `veliSoyadi`, `veliTC`, `veliTelNo`) VALUES
(1, 'Tolga', 'Alparslan', '30635428596', '05312456895'),
(2, 'Nisa', 'Geçmiş', '99635428596', '05312465895'),
(3, 'Murat', 'Gezgin', '30699928596', '05217465895'),
(4, 'Hilal', 'Durmuş', '36548928596', '05316545895'),
(5, 'Anıl', 'Oklava', '30699928666', '05316456123'),
(6, 'Gamze', 'Dürbün', '30699928333', '05316545651'),
(7, 'Cüneyt', 'Çakır', '30635428596', '05312457845'),
(8, 'Halis', 'Pamuk', '54213265985', '05365465263'),
(9, 'Murat', 'Hol', '65548798652', '05365469856'),
(10, 'Sinem', 'Sönmez', '54216598874', '05365489856'),
(11, 'Aylin', 'Çiçek', '12212121212', '05365465896'),
(12, 'Ömer', 'Düzine', '21211212121', '05366549856'),
(13, 'Doğukan', 'Kaygısız', '5632451287', '0532659856'),
(14, 'Mert', 'Çelik', '78451232659', '05366549856'),
(15, 'Dilara', 'Gül', '78541265326', '05362145632');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `tblveli_toplanti`
--

CREATE TABLE `tblveli_toplanti` (
  `toplantiID` int(11) NOT NULL,
  `toplantiAdi` varchar(50) COLLATE utf8_turkish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `tblveli_toplanti`
--

INSERT INTO `tblveli_toplanti` (`toplantiID`, `toplantiAdi`) VALUES
(1, 'Tanışma Toplantısı'),
(2, 'Durum Toplantısı'),
(3, 'Katılım Toplantısı'),
(4, 'İlerleyiş Toplantısı');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `tblveli_toplanti_katilim`
--

CREATE TABLE `tblveli_toplanti_katilim` (
  `katilimID` int(11) NOT NULL,
  `toplantiID` int(11) DEFAULT NULL,
  `veliID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Tablo döküm verisi `tblveli_toplanti_katilim`
--

INSERT INTO `tblveli_toplanti_katilim` (`katilimID`, `toplantiID`, `veliID`) VALUES
(1, 1, 6),
(2, 1, 3),
(3, 2, 2),
(4, 2, 5),
(5, 3, 6),
(6, 3, 1),
(7, 4, 5);

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `tblbrans`
--
ALTER TABLE `tblbrans`
  ADD PRIMARY KEY (`bransID`);

--
-- Tablo için indeksler `tblders`
--
ALTER TABLE `tblders`
  ADD PRIMARY KEY (`dersID`),
  ADD KEY `sinifID` (`sinifID`),
  ADD KEY `ogretmenID` (`ogretmenID`);

--
-- Tablo için indeksler `tbldevamsizlik`
--
ALTER TABLE `tbldevamsizlik`
  ADD PRIMARY KEY (`devamsizlikID`),
  ADD KEY `ogrenciID` (`ogrenciID`);

--
-- Tablo için indeksler `tblkategori`
--
ALTER TABLE `tblkategori`
  ADD PRIMARY KEY (`kategoriID`);

--
-- Tablo için indeksler `tblodeme`
--
ALTER TABLE `tblodeme`
  ADD PRIMARY KEY (`odemeID`),
  ADD KEY `ogrenciID` (`ogrenciID`);

--
-- Tablo için indeksler `tblogrenci`
--
ALTER TABLE `tblogrenci`
  ADD PRIMARY KEY (`ogrenciID`),
  ADD KEY `veliID` (`veliID`),
  ADD KEY `sinifID` (`sinifID`);

--
-- Tablo için indeksler `tblogretmen`
--
ALTER TABLE `tblogretmen`
  ADD PRIMARY KEY (`ogretmenID`),
  ADD KEY `bransID` (`bransID`);

--
-- Tablo için indeksler `tblsinif`
--
ALTER TABLE `tblsinif`
  ADD PRIMARY KEY (`sinifID`),
  ADD KEY `subeID` (`subeID`),
  ADD KEY `kategoriID` (`kategoriID`);

--
-- Tablo için indeksler `tblsube`
--
ALTER TABLE `tblsube`
  ADD PRIMARY KEY (`subeID`);

--
-- Tablo için indeksler `tblveli`
--
ALTER TABLE `tblveli`
  ADD PRIMARY KEY (`veliID`);

--
-- Tablo için indeksler `tblveli_toplanti`
--
ALTER TABLE `tblveli_toplanti`
  ADD PRIMARY KEY (`toplantiID`);

--
-- Tablo için indeksler `tblveli_toplanti_katilim`
--
ALTER TABLE `tblveli_toplanti_katilim`
  ADD PRIMARY KEY (`katilimID`),
  ADD KEY `toplantiID` (`toplantiID`),
  ADD KEY `veliID` (`veliID`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `tblbrans`
--
ALTER TABLE `tblbrans`
  MODIFY `bransID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Tablo için AUTO_INCREMENT değeri `tblders`
--
ALTER TABLE `tblders`
  MODIFY `dersID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Tablo için AUTO_INCREMENT değeri `tbldevamsizlik`
--
ALTER TABLE `tbldevamsizlik`
  MODIFY `devamsizlikID` int(200) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Tablo için AUTO_INCREMENT değeri `tblkategori`
--
ALTER TABLE `tblkategori`
  MODIFY `kategoriID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Tablo için AUTO_INCREMENT değeri `tblodeme`
--
ALTER TABLE `tblodeme`
  MODIFY `odemeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Tablo için AUTO_INCREMENT değeri `tblogrenci`
--
ALTER TABLE `tblogrenci`
  MODIFY `ogrenciID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Tablo için AUTO_INCREMENT değeri `tblogretmen`
--
ALTER TABLE `tblogretmen`
  MODIFY `ogretmenID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Tablo için AUTO_INCREMENT değeri `tblsinif`
--
ALTER TABLE `tblsinif`
  MODIFY `sinifID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Tablo için AUTO_INCREMENT değeri `tblsube`
--
ALTER TABLE `tblsube`
  MODIFY `subeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Tablo için AUTO_INCREMENT değeri `tblveli`
--
ALTER TABLE `tblveli`
  MODIFY `veliID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Tablo için AUTO_INCREMENT değeri `tblveli_toplanti`
--
ALTER TABLE `tblveli_toplanti`
  MODIFY `toplantiID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `tblveli_toplanti_katilim`
--
ALTER TABLE `tblveli_toplanti_katilim`
  MODIFY `katilimID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `tblders`
--
ALTER TABLE `tblders`
  ADD CONSTRAINT `tblders_ibfk_1` FOREIGN KEY (`sinifID`) REFERENCES `tblsinif` (`sinifID`),
  ADD CONSTRAINT `tblders_ibfk_2` FOREIGN KEY (`ogretmenID`) REFERENCES `tblogretmen` (`ogretmenID`);

--
-- Tablo kısıtlamaları `tbldevamsizlik`
--
ALTER TABLE `tbldevamsizlik`
  ADD CONSTRAINT `tbldevamsizlik_ibfk_1` FOREIGN KEY (`ogrenciID`) REFERENCES `tblogrenci` (`ogrenciID`);

--
-- Tablo kısıtlamaları `tblodeme`
--
ALTER TABLE `tblodeme`
  ADD CONSTRAINT `tblodeme_ibfk_1` FOREIGN KEY (`ogrenciID`) REFERENCES `tblogrenci` (`ogrenciID`);

--
-- Tablo kısıtlamaları `tblogrenci`
--
ALTER TABLE `tblogrenci`
  ADD CONSTRAINT `tblogrenci_ibfk_1` FOREIGN KEY (`veliID`) REFERENCES `tblveli` (`veliID`),
  ADD CONSTRAINT `tblogrenci_ibfk_2` FOREIGN KEY (`sinifID`) REFERENCES `tblsinif` (`sinifID`);

--
-- Tablo kısıtlamaları `tblogretmen`
--
ALTER TABLE `tblogretmen`
  ADD CONSTRAINT `tblogretmen_ibfk_1` FOREIGN KEY (`bransID`) REFERENCES `tblbrans` (`bransID`);

--
-- Tablo kısıtlamaları `tblsinif`
--
ALTER TABLE `tblsinif`
  ADD CONSTRAINT `tblsinif_ibfk_1` FOREIGN KEY (`subeID`) REFERENCES `tblsube` (`subeID`),
  ADD CONSTRAINT `tblsinif_ibfk_2` FOREIGN KEY (`kategoriID`) REFERENCES `tblkategori` (`kategoriID`);

--
-- Tablo kısıtlamaları `tblveli_toplanti_katilim`
--
ALTER TABLE `tblveli_toplanti_katilim`
  ADD CONSTRAINT `tblveli_toplanti_katilim_ibfk_1` FOREIGN KEY (`veliID`) REFERENCES `tblveli` (`veliID`),
  ADD CONSTRAINT `tblveli_toplanti_katilim_ibfk_2` FOREIGN KEY (`toplantiID`) REFERENCES `tblveli_toplanti` (`toplantiID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
