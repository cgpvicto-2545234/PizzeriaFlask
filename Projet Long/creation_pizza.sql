DROP DATABASE IF EXISTS pizzeria;
CREATE DATABASE IF NOT EXISTS pizzeria
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE pizzeria;

CREATE TABLE clients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    adresse VARCHAR(255) NOT NULL
);

CREATE TABLE croutes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_croute VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE sauces (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_sauce VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE garnitures (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_garniture VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE commandes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_client INT NOT NULL,
    statut VARCHAR(20) NOT NULL DEFAULT 'En_Attente',
    date_commande DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_commandes_clients
        FOREIGN KEY (id_client)
        REFERENCES clients(id),

    CONSTRAINT chk_statut_commande
        CHECK (statut IN ('En_Attente', 'En_Livraison', 'Livree', 'Annulee'))
);

CREATE TABLE pizza (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_commande INT NOT NULL,
    id_croute INT NOT NULL,
    id_sauce INT NOT NULL,

    CONSTRAINT fk_pizza_commandes
        FOREIGN KEY (id_commande)
        REFERENCES commandes(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_pizza_croutes
        FOREIGN KEY (id_croute)
        REFERENCES croutes(id),

    CONSTRAINT fk_pizza_sauces
        FOREIGN KEY (id_sauce)
        REFERENCES sauces(id)
);

CREATE TABLE pizza_garniture (
    id_pizza INT NOT NULL,
    id_garniture INT NOT NULL,

    PRIMARY KEY (id_pizza, id_garniture),

    CONSTRAINT fk_pg_pizza
        FOREIGN KEY (id_pizza)
        REFERENCES pizza(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_pg_garniture
        FOREIGN KEY (id_garniture)
        REFERENCES garnitures(id)
);

CREATE TABLE livraisons_en_attente (
    id_commande INT PRIMARY KEY,
    date_ajout DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_attente_commande
        FOREIGN KEY (id_commande)
        REFERENCES commandes(id)
        ON DELETE CASCADE
);

DELIMITER //

CREATE TRIGGER ajouter_commande_en_attente
AFTER INSERT ON commandes
FOR EACH ROW
BEGIN
    INSERT INTO livraisons_en_attente (id_commande)
    VALUES (NEW.id);
END//

DELIMITER ;