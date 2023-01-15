/* QUESTION 7 */


CREATE OR REPLACE FUNCTION del_archivage_clients() RETURNS TRIGGER AS $$
    DECLARE

    BEGIN
        IF (TG_OP = 'DELETE') THEN
            INSERT INTO archives_client VALUES (
                OLD.cli_id_Clients, 
                OLD.cli_nom_Clients,
                OLD.cli_pnom_Clients,
                OLD.cli_adr_Clients,
                OLD.cli_cp_Clients,
                OLD.cli_ville_Clients,
                OLD.cli_mail_Clients,
                OLD.cli_ca_Clients,
                OLD.cli_nb_oeuvres_Clients,
                CURRENT_TIMESTAMP,
                (SELECT current_user)
            );
            RETURN OLD;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archives_client 
AFTER DELETE ON clients
FOR EACH ROW EXECUTE FUNCTION del_archivage_clients();
            