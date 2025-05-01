CREATE TABLE IF NOT EXISTS `boutique` (
  `idboutique` INT(11) NOT NULL AUTO_INCREMENT,
  `ptsboutique` INT(100) NOT NULL DEFAULT 0,
  `avatar` VARCHAR(1000) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'https://image.noelshack.com/fichiers/2024/30/6/1722103155-image-w856.jpg', -- Mettre l'url que vous voulez pour l'avatar par défaut 
  PRIMARY KEY (`idboutique`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `wBoutiqueHistorique` (
  `id` int(255) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `Type` varchar(50) NOT NULL,
  `Montant` varchar(50) NOT NULL,
  `Date` text NOT NULL,
  `Achat` varchar(50) NOT NULL,
  `SoldeAfterAchat` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;