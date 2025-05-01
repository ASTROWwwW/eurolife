CREATE TABLE `wCambriolage` (
  `identifier` varchar(100) NOT NULL,
  `id` tinyint(23) NOT NULL,
  `coord` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `wCambriolage`
  ADD PRIMARY KEY (`identifier`) USING BTREE;
COMMIT;