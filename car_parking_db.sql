-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 16, 2026 at 10:38 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `car_parking_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `car`
--

CREATE TABLE `car` (
  `EmpID` int(11) NOT NULL,
  `EmpName` int(11) NOT NULL,
  `EmpAge` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `car enter and out`
--

CREATE TABLE `car enter and out` (
  `EmpCar` int(11) NOT NULL,
  `EmpName` text NOT NULL,
  `EmpOut` int(11) NOT NULL,
  `EmpEnter` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `parking_config`
--

CREATE TABLE `parking_config` (
  `id` int(11) NOT NULL,
  `total_spaces` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parking_config`
--

INSERT INTO `parking_config` (`id`, `total_spaces`) VALUES
(1, 100);

-- --------------------------------------------------------

--
-- Table structure for table `parking_records`
--

CREATE TABLE `parking_records` (
  `id` int(11) NOT NULL,
  `plate_number` varchar(20) NOT NULL,
  `entry_time` datetime NOT NULL DEFAULT current_timestamp(),
  `exit_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `parking_status`
-- (See below for the actual view)
--
CREATE TABLE `parking_status` (
`total_spaces` int(11)
,`occupied_spaces` bigint(21)
,`remaining_spaces` bigint(22)
);

-- --------------------------------------------------------

--
-- Structure for view `parking_status`
--
DROP TABLE IF EXISTS `parking_status`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `parking_status`  AS SELECT `c`.`total_spaces` AS `total_spaces`, count(`p`.`id`) AS `occupied_spaces`, `c`.`total_spaces`- count(`p`.`id`) AS `remaining_spaces` FROM (`parking_config` `c` left join `parking_records` `p` on(`p`.`exit_time` is null)) WHERE `c`.`id` = 1 GROUP BY `c`.`total_spaces` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `car`
--
ALTER TABLE `car`
  ADD PRIMARY KEY (`EmpID`) USING BTREE,
  ADD UNIQUE KEY `EmpID` (`EmpID`,`EmpName`);

--
-- Indexes for table `car enter and out`
--
ALTER TABLE `car enter and out`
  ADD PRIMARY KEY (`EmpCar`);

--
-- Indexes for table `parking_config`
--
ALTER TABLE `parking_config`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `parking_records`
--
ALTER TABLE `parking_records`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `parking_records`
--
ALTER TABLE `parking_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
