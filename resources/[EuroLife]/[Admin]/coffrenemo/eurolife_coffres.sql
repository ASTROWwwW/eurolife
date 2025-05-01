-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : lun. 28 avr. 2025 à 21:16
-- Version du serveur : 11.6.2-MariaDB-deb11
-- Version de PHP : 8.3.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `s1573_kyranos`
--

-- --------------------------------------------------------

--
-- Structure de la table `eurolife_coffres`
--

CREATE TABLE `eurolife_coffres` (
  `id` int(11) NOT NULL,
  `label` varchar(50) NOT NULL,
  `job` varchar(50) NOT NULL,
  `password` varchar(50) DEFAULT NULL,
  `position` longtext NOT NULL,
  `max_weight` int(11) DEFAULT 100,
  `marker_type` int(11) DEFAULT 1,
  `marker_size` float DEFAULT 1,
  `marker_height` float DEFAULT 1,
  `marker_opacity` int(11) DEFAULT 150,
  `marker_color` longtext DEFAULT NULL,
  `money` int(11) DEFAULT 0,
  `black_money` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `eurolife_coffres`
--
ALTER TABLE `eurolife_coffres`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `eurolife_coffres`
--
ALTER TABLE `eurolife_coffres`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
