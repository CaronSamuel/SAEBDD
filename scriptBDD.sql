DROP TABLE IF EXISTS Oeuvres ;
CREATE TABLE Oeuvres (oeuvre_id_Oeuvres SERIAL PRIMARY KEY,
oeuvre_titre_Oeuvres VARCHAR(50),
oeuvre_descrip_Oeuvres TEXT,
oeuvre_dim_larg_Oeuvres FLOAT,
oeuvre_dim_haut_Oeuvres FLOAT,
prix_TTC_Oeuvres FLOAT DEFAULT 0,
en_stock_Oeuvres BOOLEAN,
auteur_id_Auteurs INT);

DROP TABLE IF EXISTS Auteurs ;
CREATE TABLE Auteurs (auteur_id_Auteurs SERIAL PRIMARY KEY,
auteur_nom_Auteurs VARCHAR(50),
auteur_pnom_Auteurs VARCHAR(50),
auteur_maxime_Auteurs TEXT,
auteur_a_propos_Auteurs TEXT,
auteur_datenai_Auteurs DATE);

DROP TABLE IF EXISTS Clients ;
CREATE TABLE Clients (cli_id_Clients SERIAL PRIMARY KEY,
cli_nom_Clients VARCHAR(50),
cli_pnom_Clients VARCHAR(50),
cli_adr_Clients TEXT,
cli_cp_Clients INTEGER,
cli_ville_Clients TEXT,
cli_mail_Clients TEXT,
cli_ca_Clients FLOAT DEFAULT 0,
cli_nb_oeuvres_Clients INTEGER DEFAULT 0);

DROP TABLE IF EXISTS Factures ;
CREATE TABLE Factures (fac_id_Factures SERIAL PRIMARY KEY,
date_fac_Factures DATE,
montant_ttc_Factures FLOAT,
fac_nb_oeuvre_Factures INT,
cli_id_Clients INT);

DROP TABLE IF EXISTS Ventes ;
CREATE TABLE Ventes (vente_id_Ventes SERIAL PRIMARY KEY,
oeuvre_id_Oeuvres INT,
fac_id_Factures INT);

ALTER TABLE Oeuvres ADD CONSTRAINT FK_Oeuvres_auteur_id_Auteurs FOREIGN KEY (auteur_id_Auteurs) REFERENCES Auteurs (auteur_id_Auteurs);

ALTER TABLE Factures ADD CONSTRAINT FK_Factures_cli_id_Clients FOREIGN KEY (cli_id_Clients) REFERENCES Clients (cli_id_Clients);
ALTER TABLE Ventes ADD CONSTRAINT FK_Ventes_fac_id_Factures FOREIGN KEY (fac_id_Factures) REFERENCES Factures (fac_id_Factures);
ALTER TABLE Ventes ADD CONSTRAINT FK_Ventes_oeuvre_id_Oeuvres FOREIGN KEY (oeuvre_id_Oeuvres) REFERENCES Oeuvres (oeuvre_id_Oeuvres);


CREATE TABLE archives_client(cli_id_Clients INTEGER PRIMARY KEY,
cli_nom_Clients VARCHAR(50),
cli_pnom_Clients VARCHAR(50),
cli_adr_Clients TEXT,
cli_cp_Clients INTEGER,
cli_ville_Clients TEXT,
cli_mail_Clients TEXT,
cli_ca_Clients FLOAT DEFAULT 0,
cli_nb_oeuvres_Clients INTEGER DEFAULT 0,
date_archivage DATE,
user_who_delete VARCHAR(50)
);