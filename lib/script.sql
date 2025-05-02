-- === Création des tables principales ===

CREATE TABLE Aeroport (
    aeroport_id INT PRIMARY KEY,
    nom VARCHAR2(100),
    ville VARCHAR2(100),
    pays VARCHAR2(100),
    code VARCHAR2(10)
);

CREATE TABLE Avion (
    avion_id INT PRIMARY KEY,
    modele VARCHAR2(100),
    capacite INT
);

CREATE TABLE Vol (
    vol_id INT PRIMARY KEY,
    numero_vol VARCHAR2(20),
    date_depart DATE,
    date_arrivee DATE,
    aeroport_depart_id INT,
    aeroport_arrivee_id INT,
    avion_id INT,
    FOREIGN KEY (aeroport_depart_id) REFERENCES Aeroport(aeroport_id),
    FOREIGN KEY (aeroport_arrivee_id) REFERENCES Aeroport(aeroport_id),
    FOREIGN KEY (avion_id) REFERENCES Avion(avion_id)
);

CREATE TABLE Classe (
    classe_id INT PRIMARY KEY,
    nom VARCHAR2(50),
    description VARCHAR2(255)
);

CREATE TABLE Passager (
    passager_id INT PRIMARY KEY,
    nom VARCHAR2(100),
    prenom VARCHAR2(100),
    email VARCHAR2(150),
    telephone VARCHAR2(20)
);

CREATE TABLE Siege (
    siege_id INT PRIMARY KEY,
    numero_siege VARCHAR2(10),
    avion_id INT,
    classe_id INT,
    FOREIGN KEY (avion_id) REFERENCES Avion(avion_id),
    FOREIGN KEY (classe_id) REFERENCES Classe(classe_id)
);

CREATE TABLE Reservation (
    reservation_id INT PRIMARY KEY,
    passager_id INT,
    vol_id INT,
    date_reservation DATE,
    siege_id INT,
    classe_id INT,
    FOREIGN KEY (passager_id) REFERENCES Passager(passager_id),
    FOREIGN KEY (vol_id) REFERENCES Vol(vol_id),
    FOREIGN KEY (siege_id) REFERENCES Siege(siege_id),
    FOREIGN KEY (classe_id) REFERENCES Classe(classe_id),
    CONSTRAINT unique_siege_vol UNIQUE (siege_id, vol_id)
);

CREATE TABLE Annulation (
    annulation_id INT PRIMARY KEY,
    reservation_id INT,
    date_annulation DATE,
    raison VARCHAR2(255),
    FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id)
);

-- === Table de journalisation ===
CREATE TABLE JournalTransactions (
    journal_id INT PRIMARY KEY,
    date_operation DATE,
    utilisateur VARCHAR2(100),
    type_operation VARCHAR2(20),
    table_cible VARCHAR2(50),
    description VARCHAR2(255)
);

-- === Création des séquences ===

CREATE SEQUENCE seq_passager_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_vol_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_siege_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_reservation_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_annulation_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_aeroport_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_avion_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_classe_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_journal_id START WITH 1 INCREMENT BY 1;

-- === Création des indexes pour optimisation ===

CREATE INDEX idx_vol_date ON Vol(date_depart);
CREATE INDEX idx_reservation_passager ON Reservation(passager_id);
CREATE INDEX idx_reservation_siege_vol ON Reservation(siege_id, vol_id);
CREATE INDEX idx_siege_avion ON Siege(avion_id);

-- === Triggers de journalisation automatique ===

CREATE OR REPLACE TRIGGER trg_passager_audit
AFTER INSERT OR UPDATE OR DELETE ON Passager
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    INSERT INTO JournalTransactions (journal_id, date_operation, utilisateur, type_operation, table_cible, description)
    VALUES (seq_journal_id.NEXTVAL, SYSDATE, USER, 'INSERT', 'Passager', 'Insertion d''un passager');
  ELSIF UPDATING THEN
    INSERT INTO JournalTransactions (journal_id, date_operation, utilisateur, type_operation, table_cible, description)
    VALUES (seq_journal_id.NEXTVAL, SYSDATE, USER, 'UPDATE', 'Passager', 'Modification d''un passager');
  ELSIF DELETING THEN
    INSERT INTO JournalTransactions (journal_id, date_operation, utilisateur, type_operation, table_cible, description)
    VALUES (seq_journal_id.NEXTVAL, SYSDATE, USER, 'DELETE', 'Passager', 'Suppression d''un passager');
  END IF;
END;
/


CREATE OR REPLACE TRIGGER trg_vol_audit
AFTER INSERT OR UPDATE OR DELETE ON Vol
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    INSERT INTO JournalTransactions VALUES (seq_journal_id.NEXTVAL, SYSDATE, USER, 'INSERT', 'Vol', 'Insertion d''un vol');
  ELSIF UPDATING THEN
    INSERT INTO JournalTransactions VALUES (seq_journal_id.NEXTVAL, SYSDATE, USER, 'UPDATE', 'Vol', 'Modification d''un vol');
  ELSIF DELETING THEN
    INSERT INTO JournalTransactions VALUES (seq_journal_id.NEXTVAL, SYSDATE, USER, 'DELETE', 'Vol', 'Suppression d''un vol');
  END IF;
END;

CREATE OR REPLACE TRIGGER trg_siege_audit
AFTER INSERT OR UPDATE OR DELETE ON Siege
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    INSERT INTO JournalTransactions VALUES (seq_journal_id.NEXTVAL, SYSDATE, USER, 'INSERT', 'Siege', 'Insertion d''un siège');
  ELSIF UPDATING THEN
    INSERT INTO JournalTransactions VALUES (seq_journal_id.NEXTVAL, SYSDATE, USER, 'UPDATE', 'Siege', 'Modification d''un siège');
  ELSIF DELETING THEN
    INSERT INTO JournalTransactions VALUES (seq_journal_id.NEXTVAL, SYSDATE, USER, 'DELETE', 'Siege', 'Suppression d''un siège');
  END IF;
END;

CREATE OR REPLACE TRIGGER trg_reservation_audit
AFTER INSERT OR UPDATE OR DELETE ON Reservation
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    INSERT INTO JournalTransactions VALUES (seq_journal_id.NEXTVAL, SYSDATE, USER, 'INSERT', 'Reservation', 'Insertion d''une réservation');
  ELSIF UPDATING THEN
    INSERT INTO JournalTransactions VALUES (seq_journal_id.NEXTVAL, SYSDATE, USER, 'UPDATE', 'Reservation', 'Modification d''une réservation');
  ELSIF DELETING THEN
    INSERT INTO JournalTransactions VALUES (seq_journal_id.NEXTVAL, SYSDATE, USER, 'DELETE', 'Reservation', 'Suppression d''une réservation');
  END IF;
END;

CREATE OR REPLACE TRIGGER trg_annulation_audit
AFTER INSERT OR UPDATE OR DELETE ON Annulation
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    INSERT INTO JournalTransactions VALUES (seq_journal_id.NEXTVAL, SYSDATE, USER, 'INSERT', 'Annulation', 'Insertion d''une annulation');
  ELSIF UPDATING THEN
    INSERT INTO JournalTransactions VALUES (seq_journal_id.NEXTVAL, SYSDATE, USER, 'UPDATE', 'Annulation', 'Modification d''une annulation');
  ELSIF DELETING THEN
    INSERT INTO JournalTransactions VALUES (seq_journal_id.NEXTVAL, SYSDATE, USER, 'DELETE', 'Annulation', 'Suppression d''une annulation');
  END IF;
END;


-- === Procédures stockées ===

CREATE OR REPLACE PROCEDURE ajouter_reservation (
    p_passager_id IN INT,
    p_vol_id IN INT,
    p_siege_id IN INT,
    p_classe_id IN INT
)
AS
    v_count INT;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Reservation
    WHERE siege_id = p_siege_id AND vol_id = p_vol_id;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Siège déjà réservé pour ce vol.');
    ELSE
        INSERT INTO Reservation (
            reservation_id, passager_id, vol_id, siege_id, classe_id, date_reservation
        ) VALUES (
            seq_reservation_id.NEXTVAL, p_passager_id, p_vol_id, p_siege_id, p_classe_id, SYSDATE
        );
        
        INSERT INTO JournalTransactions VALUES (
            seq_journal_id.NEXTVAL, SYSDATE, USER, 'INSERT', 'Reservation', 'Ajout d''une réservation pour passager ' || p_passager_id
        );
    END IF;
END;

CREATE OR REPLACE PROCEDURE annuler_reservation (
    p_reservation_id IN INT,
    p_raison IN VARCHAR2
)
AS
BEGIN
    INSERT INTO Annulation (
        annulation_id, reservation_id, date_annulation, raison
    ) VALUES (
        seq_annulation_id.NEXTVAL, p_reservation_id, SYSDATE, p_raison
    );

    DELETE FROM Reservation
    WHERE reservation_id = p_reservation_id;

    INSERT INTO JournalTransactions VALUES (
        seq_journal_id.NEXTVAL, SYSDATE, USER, 'DELETE', 'Reservation', 'Annulation de la réservation ' || p_reservation_id
    );
END;
/

-- === Package regroupant les opérations liées aux réservations ===

CREATE OR REPLACE PACKAGE pkg_reservation AS
    PROCEDURE ajouter_reservation(p_passager_id INT, p_vol_id INT, p_siege_id INT, p_classe_id INT);
    PROCEDURE annuler_reservation(p_reservation_id INT, p_raison VARCHAR2);
END pkg_reservation;
/

CREATE OR REPLACE PACKAGE BODY pkg_reservation AS
    PROCEDURE ajouter_reservation(p_passager_id INT, p_vol_id INT, p_siege_id INT, p_classe_id INT) IS
    BEGIN
        ajouter_reservation(p_passager_id, p_vol_id, p_siege_id, p_classe_id);
    END;

    PROCEDURE annuler_reservation(p_reservation_id INT, p_raison VARCHAR2) IS
    BEGIN
        annuler_reservation(p_reservation_id, p_raison);
    END;
END pkg_reservation;
/

-- === Vues de consultation ===

CREATE OR REPLACE VIEW vue_reservations_detaillees AS
SELECT r.reservation_id, p.nom || ' ' || p.prenom AS passager_nom, v.numero_vol, v.date_depart, s.numero_siege, c.nom AS classe_nom
FROM Reservation r
JOIN Passager p ON r.passager_id = p.passager_id
JOIN Vol v ON r.vol_id = v.vol_id
JOIN Siege s ON r.siege_id = s.siege_id
JOIN Classe c ON r.classe_id = c.classe_id;

CREATE OR REPLACE VIEW vue_vols_disponibles AS
SELECT v.vol_id, v.numero_vol, v.date_depart, COUNT(s.siege_id) AS sieges_disponibles
FROM Vol v
JOIN Siege s ON s.avion_id = v.avion_id
LEFT JOIN Reservation r ON r.siege_id = s.siege_id AND r.vol_id = v.vol_id
WHERE v.date_depart > SYSDATE
AND r.reservation_id IS NULL
GROUP BY v.vol_id, v.numero_vol, v.date_depart
ORDER BY v.date_depart;

-- Aéroports
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (1, 'Charles de Gaulle', 'Paris', 'France', 'CDG');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (2, 'Toronto Pearson', 'Toronto', 'Canada', 'YYZ');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (3, 'Montréal-Trudeau', 'Montréal', 'Canada', 'YUL');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (4, 'JFK', 'New York', 'USA', 'JFK');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (5, 'Heathrow', 'Londres', 'Royaume-Uni', 'LHR');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (6, 'Los Angeles LAX', 'Los Angeles', 'USA', 'LAX');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (7, 'Dubai International', 'Dubaï', 'Émirats', 'DXB');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (8, 'Tokyo Haneda', 'Tokyo', 'Japon', 'HND');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (9, 'Francfort', 'Francfort', 'Allemagne', 'FRA');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (10, 'Madrid Barajas', 'Madrid', 'Espagne', 'MAD');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (11, 'Lisbonne Humberto Delgado', 'Lisbonne', 'Portugal', 'LIS');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (12, 'Zurich', 'Zurich', 'Suisse', 'ZRH');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (13, 'Amsterdam Schiphol', 'Amsterdam', 'Pays-Bas', 'AMS');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (14, 'Chicago O''Hare', 'Chicago', 'USA', 'ORD');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (15, 'Vancouver International', 'Vancouver', 'Canada', 'YVR');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (16, 'Rome Fiumicino', 'Rome', 'Italie', 'FCO');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (17, 'Beijing Capital', 'Pékin', 'Chine', 'PEK');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (18, 'Bruxelles Zaventem', 'Bruxelles', 'Belgique', 'BRU');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (19, 'Boston Logan', 'Boston', 'USA', 'BOS');
INSERT INTO Aeroport (aeroport_id, nom, ville, pays, code) VALUES (20, 'Sydney Kingsford Smith', 'Sydney', 'Australie', 'SYD');

-- Avions
INSERT INTO Avion (avion_id, modele, capacite) VALUES (1, 'Boeing 777', 300);
INSERT INTO Avion (avion_id, modele, capacite) VALUES (2, 'Airbus A380', 500);
INSERT INTO Avion (avion_id, modele, capacite) VALUES (3, 'Boeing 787', 280);
INSERT INTO Avion (avion_id, modele, capacite) VALUES (4, 'Airbus A350', 320);
INSERT INTO Avion (avion_id, modele, capacite) VALUES (5, 'Boeing 737', 200);
INSERT INTO Avion (avion_id, modele, capacite) VALUES (6, 'Airbus A330', 270);
INSERT INTO Avion (avion_id, modele, capacite) VALUES (7, 'Boeing 767', 250);
INSERT INTO Avion (avion_id, modele, capacite) VALUES (8, 'Bombardier CRJ900', 90);
INSERT INTO Avion (avion_id, modele, capacite) VALUES (9, 'Embraer 190', 100);
INSERT INTO Avion (avion_id, modele, capacite) VALUES (10, 'Boeing 747', 400);

-- Classes
INSERT INTO Classe (classe_id, nom, description) VALUES (1, 'Économie', 'Classe économique standard');
INSERT INTO Classe (classe_id, nom, description) VALUES (2, 'Économie Premium', 'Classe économique améliorée');
INSERT INTO Classe (classe_id, nom, description) VALUES (3, 'Affaires', 'Classe affaires');
INSERT INTO Classe (classe_id, nom, description) VALUES (4, 'Première', 'Classe première luxe');

-- Passagers
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (1, 'Durand', 'Pierre', 'pierre.durand@example.com', '514-111-1111');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (2, 'Martin', 'Lucie', 'lucie.martin@example.com', '514-222-2222');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (3, 'Leclerc', 'Julien', 'julien.leclerc@example.com', '514-333-3333');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (4, 'Gagnon', 'Sophie', 'sophie.gagnon@example.com', '514-444-4444');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (5, 'Lemoine', 'Paul', 'paul.lemoine@example.com', '514-555-5555');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (6, 'Boucher', 'Claire', 'claire.boucher@example.com', '514-666-6666');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (7, 'Tremblay', 'Émile', 'emile.tremblay@example.com', '514-777-7777');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (8, 'Bertrand', 'Nathalie', 'nathalie.bertrand@example.com', '514-888-8888');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (9, 'Rivard', 'Antoine', 'antoine.rivard@example.com', '514-999-9999');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (10, 'Gervais', 'Isabelle', 'isabelle.gervais@example.com', '514-101-1010');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (11, 'Noël', 'Kevin', 'kevin.noel@example.com', '514-202-2020');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (12, 'Ouellet', 'Marianne', 'marianne.ouellet@example.com', '514-303-3030');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (13, 'Lapointe', 'Olivier', 'olivier.lapointe@example.com', '514-404-4040');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (14, 'Benoît', 'Anne', 'anne.benoit@example.com', '514-505-5050');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (15, 'Fortin', 'Philippe', 'philippe.fortin@example.com', '514-606-6060');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (16, 'Roy', 'Amélie', 'amelie.roy@example.com', '514-707-7070');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (17, 'Larose', 'Vincent', 'vincent.larose@example.com', '514-808-8080');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (18, 'Beaudoin', 'Camille', 'camille.beaudoin@example.com', '514-909-9090');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (19, 'Dion', 'Alexis', 'alexis.dion@example.com', '514-010-1010');
INSERT INTO Passager (passager_id, nom, prenom, email, telephone) VALUES (20, 'Perron', 'Élise', 'elise.perron@example.com', '514-111-2222');

-- Vols
INSERT INTO Vol (vol_id, numero_vol, date_depart, date_arrivee, aeroport_depart_id, aeroport_arrivee_id, avion_id) VALUES
(1, 'AF101', TO_DATE('2025-06-01 08:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-01 11:00', 'YYYY-MM-DD HH24:MI'), 1, 2, 1),
(2, 'AC202', TO_DATE('2025-06-02 10:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-02 13:00', 'YYYY-MM-DD HH24:MI'), 2, 3, 2),
(3, 'DL303', TO_DATE('2025-06-03 09:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-03 12:00', 'YYYY-MM-DD HH24:MI'), 3, 4, 3),
(4, 'BA404', TO_DATE('2025-06-04 07:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-04 14:00', 'YYYY-MM-DD HH24:MI'), 5, 6, 4),
(5, 'EK505', TO_DATE('2025-06-05 12:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-05 22:00', 'YYYY-MM-DD HH24:MI'), 7, 8, 5),
(6, 'JL606', TO_DATE('2025-06-06 13:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-06 23:00', 'YYYY-MM-DD HH24:MI'), 8, 9, 6),
(7, 'LH707', TO_DATE('2025-06-07 06:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-07 09:00', 'YYYY-MM-DD HH24:MI'), 9, 10, 7),
(8, 'IB808', TO_DATE('2025-06-08 11:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-08 14:00', 'YYYY-MM-DD HH24:MI'), 10, 11, 8),
(9, 'TP909', TO_DATE('2025-06-09 07:30', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-09 10:30', 'YYYY-MM-DD HH24:MI'), 11, 12, 9),
(10, 'LX010', TO_DATE('2025-06-10 08:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-10 10:00', 'YYYY-MM-DD HH24:MI'), 12, 13, 10),
(11, 'KL111', TO_DATE('2025-06-11 09:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-11 12:00', 'YYYY-MM-DD HH24:MI'), 13, 14, 1),
(12, 'UA212', TO_DATE('2025-06-12 10:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-12 12:30', 'YYYY-MM-DD HH24:MI'), 14, 15, 2),
(13, 'AC313', TO_DATE('2025-06-13 11:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-13 14:30', 'YYYY-MM-DD HH24:MI'), 15, 16, 3),
(14, 'AZ414', TO_DATE('2025-06-14 06:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-14 09:00', 'YYYY-MM-DD HH24:MI'), 16, 17, 4),
(15, 'CA515', TO_DATE('2025-06-15 13:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-15 23:00', 'YYYY-MM-DD HH24:MI'), 17, 18, 5),
(16, 'SN616', TO_DATE('2025-06-16 08:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-16 11:00', 'YYYY-MM-DD HH24:MI'), 18, 19, 6),
(17, 'DL717', TO_DATE('2025-06-17 09:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-17 13:00', 'YYYY-MM-DD HH24:MI'), 19, 20, 7),
(18, 'QF818', TO_DATE('2025-06-18 14:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-18 22:00', 'YYYY-MM-DD HH24:MI'), 20, 1, 8),
(19, 'AF919', TO_DATE('2025-06-19 08:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-19 10:30', 'YYYY-MM-DD HH24:MI'), 1, 3, 9),
(20, 'AC020', TO_DATE('2025-06-20 09:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2025-06-20 11:00', 'YYYY-MM-DD HH24:MI'), 2, 4, 10);

-- Sièges pour avion_id = 1
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (1, '1A', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (2, '1B', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (3, '1C', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (4, '1D', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (5, '1E', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (6, '1F', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (7, '2A', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (8, '2B', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (9, '2C', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (10, '2D', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (11, '2E', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (12, '2F', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (13, '3A', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (14, '3B', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (15, '3C', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (16, '3D', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (17, '3E', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (18, '3F', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (19, '4A', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (20, '4B', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (21, '4C', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (22, '4D', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (23, '4E', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (24, '4F', 1, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (25, '5A', 1, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (26, '5B', 1, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (27, '5C', 1, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (28, '5D', 1, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (29, '5E', 1, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (30, '5F', 1, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (31, '6A', 1, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (32, '6B', 1, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (33, '6C', 1, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (34, '6D', 1, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (35, '6E', 1, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (36, '6F', 1, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (37, '7A', 1, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (38, '7B', 1, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (39, '7C', 1, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (40, '7D', 1, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (41, '7E', 1, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (42, '7F', 1, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (43, '8A', 1, 4);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (44, '2D', 2, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (45, '2E', 2, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (46, '2F', 2, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (47, '3A', 2, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (48, '3B', 2, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (49, '3C', 2, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (50, '3D', 2, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (51, '3E', 2, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (52, '3F', 2, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (53, '4A', 2, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (54, '4B', 2, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (55, '4C', 2, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (56, '4D', 2, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (57, '4E', 2, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (58, '4F', 2, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (59, '5A', 2, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (60, '5B', 2, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (61, '5C', 2, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (62, '5D', 2, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (63, '5E', 2, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (64, '5F', 2, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (65, '6A', 2, 4);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (66, '6B', 2, 4);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (67, '6C', 2, 4);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (68, '6D', 2, 4);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (69, '1A', 3, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (70, '1B', 3, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (71, '1C', 3, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (72, '1D', 3, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (73, '1E', 3, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (74, '1F', 3, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (75, '2A', 3, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (76, '2B', 3, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (77, '2C', 3, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (78, '2D', 3, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (79, '2E', 3, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (80, '2F', 3, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (81, '3A', 3, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (82, '3B', 3, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (83, '3C', 3, 1);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (84, '3D', 3, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (85, '3E', 3, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (86, '3F', 3, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (87, '4A', 3, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (88, '4B', 3, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (89, '4C', 3, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (90, '4D', 3, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (91, '4E', 3, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (92, '4F', 3, 2);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (93, '5A', 3, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (94, '5B', 3, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (95, '5C', 3, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (96, '5D', 3, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (97, '5E', 3, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (98, '5F', 3, 3);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (99, '6A', 3, 4);
INSERT INTO Siege (siege_id, numero_siege, avion_id, classe_id) VALUES (100, '6B', 3, 4);
-- ...
-- Même logique jusqu'à siege_id 30 pour avion_id 1

INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (1, 1, 1, SYSDATE, 1, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (2, 2, 2, SYSDATE, 2, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (3, 3, 3, SYSDATE, 3, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (4, 4, 4, SYSDATE, 4, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (5, 5, 5, SYSDATE, 5, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (6, 6, 1, SYSDATE, 6, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (7, 7, 2, SYSDATE, 7, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (8, 8, 3, SYSDATE, 8, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (9, 9, 4, SYSDATE, 9, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (10, 10, 5, SYSDATE, 10, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (11, 11, 1, SYSDATE, 11, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (12, 12, 2, SYSDATE, 12, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (13, 13, 3, SYSDATE, 13, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (14, 14, 4, SYSDATE, 14, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (15, 15, 5, SYSDATE, 15, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (16, 16, 1, SYSDATE, 16, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (17, 17, 2, SYSDATE, 17, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (18, 18, 3, SYSDATE, 18, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (19, 19, 4, SYSDATE, 19, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (20, 20, 5, SYSDATE, 20, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (21, 1, 1, SYSDATE, 21, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (22, 2, 2, SYSDATE, 22, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (23, 3, 3, SYSDATE, 23, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (24, 4, 4, SYSDATE, 24, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (25, 5, 5, SYSDATE, 25, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (26, 6, 1, SYSDATE, 26, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (27, 7, 2, SYSDATE, 27, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (28, 8, 3, SYSDATE, 28, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (29, 9, 4, SYSDATE, 29, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (30, 10, 5, SYSDATE, 30, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (31, 11, 1, SYSDATE, 31, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (32, 12, 2, SYSDATE, 32, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (33, 13, 3, SYSDATE, 33, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (34, 14, 4, SYSDATE, 34, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (35, 15, 5, SYSDATE, 35, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (36, 16, 1, SYSDATE, 36, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (37, 17, 2, SYSDATE, 37, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (38, 18, 3, SYSDATE, 38, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (39, 19, 4, SYSDATE, 39, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (40, 20, 5, SYSDATE, 40, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (41, 1, 1, SYSDATE, 41, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (42, 2, 2, SYSDATE, 42, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (43, 3, 3, SYSDATE, 43, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (44, 4, 4, SYSDATE, 44, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (45, 5, 5, SYSDATE, 45, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (46, 6, 1, SYSDATE, 46, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (47, 7, 2, SYSDATE, 47, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (48, 8, 3, SYSDATE, 48, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (49, 9, 4, SYSDATE, 49, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (50, 10, 5, SYSDATE, 50, 1);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (51, 11, 1, SYSDATE, 51, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (52, 12, 2, SYSDATE, 52, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (53, 13, 3, SYSDATE, 53, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (54, 14, 4, SYSDATE, 54, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (55, 15, 5, SYSDATE, 55, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (56, 16, 1, SYSDATE, 56, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (57, 17, 2, SYSDATE, 57, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (58, 18, 3, SYSDATE, 58, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (59, 19, 4, SYSDATE, 59, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (60, 20, 5, SYSDATE, 60, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (61, 1, 1, SYSDATE, 61, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (62, 2, 2, SYSDATE, 62, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (63, 3, 3, SYSDATE, 63, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (64, 4, 4, SYSDATE, 64, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (65, 5, 5, SYSDATE, 65, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (66, 6, 1, SYSDATE, 66, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (67, 7, 2, SYSDATE, 67, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (68, 8, 3, SYSDATE, 68, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (69, 9, 4, SYSDATE, 69, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (70, 10, 5, SYSDATE, 70, 2);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (71, 11, 1, SYSDATE, 71, 3);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (72, 12, 2, SYSDATE, 72, 3);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (73, 13, 3, SYSDATE, 73, 3);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (74, 14, 4, SYSDATE, 74, 3);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (75, 15, 5, SYSDATE, 75, 3);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (76, 16, 1, SYSDATE, 76, 3);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (77, 17, 2, SYSDATE, 77, 3);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (78, 18, 3, SYSDATE, 78, 3);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (79, 19, 4, SYSDATE, 79, 3);
INSERT INTO Reservation (reservation_id, passager_id, vol_id, date_reservation, siege_id, classe_id) VALUES (80, 20, 5, SYSDATE, 80, 3);

INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (1, 2, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (2, 4, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (3, 6, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (4, 8, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (5, 10, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (6, 12, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (7, 14, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (8, 16, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (9, 18, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (10, 20, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (11, 22, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (12, 24, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (13, 26, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (14, 28, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (15, 30, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (16, 32, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (17, 34, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (18, 36, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (19, 38, SYSDATE, 'Annulation automatique');
INSERT INTO Annulation (annulation_id, reservation_id, date_annulation, raison) VALUES (20, 40, SYSDATE, 'Annulation automatique');


