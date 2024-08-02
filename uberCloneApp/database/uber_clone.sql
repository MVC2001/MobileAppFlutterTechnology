-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 09, 2024 at 06:51 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `uber_clone`
--

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `client_id` int(11) NOT NULL,
  `fullName` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`client_id`, `fullName`, `email`, `password`, `created_at`) VALUES
(1, 'custmer', 'customer13223@gmal.com', '9a0305f8c834c866671f902cc537f26a', '2024-05-26 16:00:48'),
(2, 'helo cust', 'test12A@gmal.com', '38b21703840206e0869e3dcf499a3721', '2024-07-09 04:42:03');

-- --------------------------------------------------------

--
-- Table structure for table `client_order`
--

CREATE TABLE `client_order` (
  `order_id` int(11) NOT NULL,
  `fullName` varchar(50) NOT NULL,
  `curently_place` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `weight` varchar(50) NOT NULL,
  `route` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `drivers`
--

CREATE TABLE `drivers` (
  `user_id` int(11) NOT NULL,
  `fullName` varchar(255) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `currently_place` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `vehicle_name` varchar(255) NOT NULL,
  `license_plate` varchar(50) NOT NULL,
  `registration_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `drivers`
--

INSERT INTO `drivers` (`user_id`, `fullName`, `phone`, `currently_place`, `email`, `password`, `city`, `vehicle_name`, `license_plate`, `registration_date`) VALUES
(1, 'test user', '0682131140', 'Tabata Mwisho', 'driver12test@gmail.com', '9e23346bf8860cf83a0bb6a2cae41a0d', 'Dar es salaam', 'Daff', 'ASGF33', '2024-07-01 13:52:33'),
(2, 'Driver2', '0683161616', 'Tabata Mwisho', 'driver2@success', '28da2aa20daa9b945a59abb5486befe6', 'Dar es salaam', 'TOYOTA', 'SSWWT2626', '2024-07-01 20:48:47');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `category` varchar(50) NOT NULL,
  `weight` varchar(50) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `fullName` varchar(50) NOT NULL,
  `destination` varchar(50) NOT NULL,
  `currently_place` varchar(50) NOT NULL,
  `route` varchar(50) NOT NULL,
  `user_id` int(50) NOT NULL,
  `confirmation` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `confirmed_by` varchar(255) DEFAULT NULL,
  `user_email` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `category`, `weight`, `phone`, `fullName`, `destination`, `currently_place`, `route`, `user_id`, `confirmation`, `created_at`, `confirmed_by`, `user_email`) VALUES
(1, 'male jeans', '200', '0682131140', 'client', 'karakoo', 'Tabata Mwisho', 'Kimara', 0, 'confirmed', '2024-07-06 21:31:21', NULL, 'driver12test@gmail.com'),
(2, 'JEANS', '200', '', 'Muser', '', 'MAKONGO', 'MAKONGO', 0, '', '2024-07-06 21:30:06', NULL, ''),
(3, 'Male shoes', '300', '', 'MVC USER', '', 'MAKONGO', 'KARUME', 0, '', '2024-07-06 21:29:56', NULL, ''),
(4, 'Female shoes', '200', '', 'user test', '', 'ubungo', 'Mbezi kimara', 0, '', '2024-07-06 21:29:47', NULL, ''),
(5, 'IPHONES', '100', '', 'MUDHIHIR HAMIS', '', 'DTV MLIMAN CITY', 'MACHINGA COMPLEX', 0, '', '2024-07-06 21:29:38', NULL, ''),
(6, 'Male jeans, male shoes', '223', '', 'user test', '', 'MBEZI', 'KIMARA', 0, '', '2024-07-06 21:29:15', NULL, ''),
(7, 'PC,smartphone,bag, and ethernet cnvertr', '333', '', 'mvc user', '', 'makongo', 'TCB BANK', 0, '', '2024-07-06 21:29:03', NULL, ''),
(8, 'test data', '', '0682131140', 'full name', 'kenya', 'mbezi', '', 0, 'confirmed', '2024-07-06 21:28:55', NULL, 'driver2@success'),
(9, 'Shoes', '', '068215252', 'test', 'Kimara', 'Tabata Mwisho', '', 0, 'confirmed', '2024-07-06 21:46:11', NULL, 'driver2@success'),
(10, 'jeans ', '', '0682131140', 'test user', 'Mwenge', 'Kimara', '', 0, '', '2024-07-09 04:36:56', NULL, '');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `fullName` varchar(50) NOT NULL,
  `make` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `year` varchar(50) DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `licensePlate` varchar(50) DEFAULT NULL,
  `vin` varchar(50) DEFAULT NULL,
  `ownerContact` varchar(50) DEFAULT NULL,
  `insuranceCompany` varchar(50) DEFAULT NULL,
  `policyNumber` varchar(50) DEFAULT NULL,
  `insuranceExpiry` varchar(50) DEFAULT NULL,
  `mileage` varchar(50) DEFAULT NULL,
  `image` varchar(50) DEFAULT NULL,
  `route` varchar(50) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `comfirmation` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `fullName`, `make`, `model`, `year`, `color`, `licensePlate`, `vin`, `ownerContact`, `insuranceCompany`, `policyNumber`, `insuranceExpiry`, `mileage`, `image`, `route`, `email`, `comfirmation`, `password`, `created_at`) VALUES
(1, '66', '', '', '', '', '', '', '', '', '', '', '', '', '', 'clien123@gmail.com', '', 'c062d89e7a7e093fcb42e35aa084a841', '2024-05-25 20:48:40'),
(2, 'passeger one', '', '', '', '', '', '', '', '', '', '', '', '', '', 'passenger1@gmail.com', '', 'dadee73fc33926da37ba4dd74a333f34', '2024-05-26 03:44:21'),
(3, 'clinetv1', '', '', '', '', '', '', '', '', '', '', '', '', '', 'clientv1@gmail.com', '', '0a3b15964075b94168fa5253da968ae1', '2024-05-26 03:46:56'),
(4, 'client1', '', '', '', '', '', '', '', '', '', '', '', '', '', 'clinet1@gmail.com', '', '8539a31e934777c73e238c931eb2fce3', '2024-05-26 03:53:42'),
(5, 'hello user', '', '', '', '', '', '', '', '', '', '', '', '', '', 'hello123@gmail.com', '', '6b98fd7d9ef2bffced77a98ae95677e3', '2024-05-26 04:01:11'),
(6, 'successfull user', '', '', '', '', '', '', '', '', '', '', '', '', '', 'success123@gmail.com', '', 'a349cae3749a0c6b560a8e0a034b99d6', '2024-05-26 04:07:09'),
(7, 'successfull user', '', '', '', '', '', '', '', '', '', '', '', '', '', 'success4123@gmail.com', '', '0fd8d448674cacfd8384facac8232078', '2024-05-26 04:08:06'),
(8, '', '', '', '', '', '', '', '', '', '', '', '', NULL, '', '', '', 'd41d8cd98f00b204e9800998ecf8427e', '2024-05-26 06:53:31'),
(9, 'hhhhhhhhhhhhh', 'fffffffffffffffffffffff', 'ddddddddddddddddddd', 'reeeeeeeeeeeeeee', 'trrttttttt', 'eee', 'ssssss44', '899876677', 'ffghffd', '99997886664', 'gjfjfftft', 'gfffddd', NULL, 'rrrrrr', 'fddd@gmail.com', '', '8e01a56eb67d7f034cd5d1b34ac4f320', '2024-07-06 20:02:56'),
(10, 'Driver', 'driver@gmail.com', 'driver@gmail.com', 'driver@gmail.com', 'driver@gmail.com', 'driver@gmail.com', 'driver@gmail.com', 'driver@gmail.com', 'driver@gmail.com', 'driver@gmail.com', 'driver@gmail.com', 'driver@gmail.com', NULL, 'mbezi', 'driver@gmail.com', '', '202cb962ac59075b964b07152d234b70', '2024-07-06 20:02:13'),
(11, 'Muser', 'sfsfw', 'sfsffs', 'sfsffsfs', 'sdsddsds', 'sfsfsffs', 'sfsddsds', 'fsffsfs', 'dffssfs', 'rrwrrsrsr', 'sfsfsfs', 'srsfsfsfs', NULL, 'MAKONGO', 'uberdriver123@gmail.com', '', '1319287732d0b7f05fe2ba25f95a9660', '2024-05-26 08:49:13');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`client_id`);

--
-- Indexes for table `client_order`
--
ALTER TABLE `client_order`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `drivers`
--
ALTER TABLE `drivers`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `client_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `client_order`
--
ALTER TABLE `client_order`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `drivers`
--
ALTER TABLE `drivers`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
