/* 
    Creation du trigger de la question 6.
*/

CREATE OR REPLACE FUNCTION update_client_ventes() RETURNS TRIGGER  AS $$
    DECLARE
        stock_oeuvres BOOLEAN;
    BEGIN
        IF (TG_OP = 'DELETE') THEN 
            UPDATE oeuvres set en_stock_Oeuvres = true where oeuvre_id_Oeuvres = OLD.oeuvre_id_Oeuvres;
            UPDATE clients set cli_ca_Clients = cli_ca_Clients - (SELECT prix_TTC_Oeuvres FROM oeuvres WHERE oeuvre_id_Oeuvres = OLD.oeuvre_id_Oeuvres) WHERE cli_id_Clients = (SELECT cli_id_Clients FROM factures WHERE fac_id_Factures = OLD.fac_id_Factures);
            UPDATE clients set cli_nb_oeuvres_Clients = cli_nb_oeuvres_Clients - 1 WHERE cli_id_Clients = (SELECT cli_id_Clients FROM factures WHERE fac_id_Factures = OLD.fac_id_Factures);
            UPDATE factures set montant_ttc_Factures = montant_ttc_Factures - (SELECT prix_TTC_Oeuvres FROM oeuvres WHERE oeuvre_id_Oeuvres = OLD.oeuvre_id_Oeuvres) WHERE fac_id_Factures = OLD.fac_id_Factures;
            UPDATE factures set fac_nb_oeuvre_Factures = fac_nb_oeuvre_Factures - 1 WHERE fac_id_Factures = OLD.fac_id_Factures;
        ELSIF (TG_OP = 'UPDATE') THEN
            SELECT en_stock_Oeuvres FROM Oeuvres INTO stock_oeuvres WHERE oeuvre_id_Oeuvres = NEW.oeuvre_id_Oeuvres;
            IF (stock_oeuvres = true) THEN
                UPDATE oeuvres set en_stock_Oeuvres = true where oeuvre_id_Oeuvres = OLD.oeuvre_id_Oeuvres;
                UPDATE clients set cli_ca_Clients = cli_ca_Clients - (SELECT prix_TTC_Oeuvres FROM oeuvres WHERE oeuvre_id_Oeuvres = OLD.oeuvre_id_Oeuvres) WHERE cli_id_Clients = (SELECT cli_id_Clients FROM factures WHERE fac_id_Factures = OLD.fac_id_Factures);
                UPDATE clients set cli_nb_oeuvres_Clients = cli_nb_oeuvres_Clients - 1 WHERE cli_id_Clients = (SELECT cli_id_Clients FROM factures WHERE fac_id_Factures = OLD.fac_id_Factures);
                UPDATE factures SET fac_nb_oeuvre_Factures = ((SELECT fac_nb_oeuvre_Factures FROM factures WHERE fac_id_Factures = OLD.fac_id_Factures) - 1) , 
                montant_ttc_Factures = ((SELECT montant_ttc_Factures FROM factures WHERE fac_id_Factures = OLD.fac_id_Factures) - (SELECT prix_TTC_Oeuvres FROM oeuvres WHERE oeuvre_id_Oeuvres = OLD.oeuvre_id_Oeuvres)) WHERE fac_id_Factures = OLD.fac_id_Factures;
                
                UPDATE oeuvres set en_stock_Oeuvres = false where oeuvre_id_Oeuvres = NEW.oeuvre_id_Oeuvres;
                UPDATE clients set cli_ca_Clients = cli_ca_Clients + (SELECT prix_TTC_Oeuvres FROM oeuvres WHERE oeuvre_id_Oeuvres = NEW.oeuvre_id_Oeuvres) WHERE cli_id_Clients = (SELECT cli_id_Clients FROM factures WHERE fac_id_Factures = NEW.fac_id_Factures);
                UPDATE clients set cli_nb_oeuvres_Clients = cli_nb_oeuvres_Clients + 1 WHERE cli_id_Clients = (SELECT cli_id_Clients FROM factures WHERE fac_id_Factures = NEW.fac_id_Factures);
                UPDATE factures SET fac_nb_oeuvre_Factures = ((SELECT fac_nb_oeuvre_Factures FROM factures WHERE fac_id_Factures = NEW.fac_id_Factures) + 1) , 
                montant_ttc_Factures = ((SELECT montant_ttc_Factures FROM factures WHERE fac_id_Factures = NEW.fac_id_Factures) + (SELECT prix_TTC_Oeuvres FROM oeuvres WHERE oeuvre_id_Oeuvres = NEW.oeuvre_id_Oeuvres)) WHERE fac_id_Factures = NEW.fac_id_Factures;
            END IF;
        ELSIF (TG_OP = 'INSERT') THEN
            SELECT en_stock_Oeuvres FROM Oeuvres INTO stock_oeuvres WHERE oeuvre_id_Oeuvres = NEW.oeuvre_id_Oeuvres;
            IF (stock_oeuvres = true) THEN
                UPDATE oeuvres set en_stock_Oeuvres = false where oeuvre_id_Oeuvres = NEW.oeuvre_id_Oeuvres;
                UPDATE clients set cli_ca_Clients = cli_ca_Clients + (SELECT prix_TTC_Oeuvres FROM oeuvres WHERE oeuvre_id_Oeuvres = NEW.oeuvre_id_Oeuvres) WHERE cli_id_Clients = (SELECT cli_id_Clients FROM factures WHERE fac_id_Factures = NEW.fac_id_Factures);
                UPDATE clients set cli_nb_oeuvres_Clients = cli_nb_oeuvres_Clients + 1 WHERE cli_id_Clients = (SELECT cli_id_Clients FROM factures WHERE fac_id_Factures = NEW.fac_id_Factures);
                UPDATE factures set montant_ttc_Factures = montant_ttc_Factures + (SELECT prix_TTC_Oeuvres FROM oeuvres WHERE oeuvre_id_Oeuvres = NEW.oeuvre_id_Oeuvres) WHERE fac_id_Factures = NEW.fac_id_Factures;
                UPDATE factures set fac_nb_oeuvre_Factures = fac_nb_oeuvre_Factures + 1 WHERE fac_id_Factures = NEW.fac_id_Factures;
            END IF;
        END IF;
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_client_ventes
AFTER INSERT OR UPDATE OR DELETE ON ventes
    FOR EACH ROW EXECUTE FUNCTION update_client_ventes();