-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : lun. 28 avr. 2025 à 21:17
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
-- Structure de la table `eurolife_coffre_items`
--

CREATE TABLE `eurolife_coffre_items` (
  `id` int(11) NOT NULL,
  `coffre_id` int(11) NOT NULL,
  `item_name` varchar(100) DEFAULT NULL,
  `item_count` int(11) NOT NULL DEFAULT 0,
  `money` int(11) NOT NULL DEFAULT 0,
  `black_money` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `eurolife_coffre_items`
--
ALTER TABLE `eurolife_coffre_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `coffre_id` (`coffre_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `eurolife_coffre_items`
--
ALTER TABLE `eurolife_coffre_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `eurolife_coffre_items`
--
ALTER TABLE `eurolife_coffre_items`
  ADD CONSTRAINT `eurolife_coffre_items_ibfk_1` FOREIGN KEY (`coffre_id`) REFERENCES `eurolife_coffres` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
