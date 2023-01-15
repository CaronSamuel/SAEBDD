/* Question 10 */

create or replace function infos_factures(integer) returns void as $$
DECLARE 
    cur cursor for select c.cli_nom_Clients, c.cli_pnom_Clients, c.cli_nb_oeuvres_Clients, f.montant_ttc_Factures from clients as c
    inner join factures as f on c.cli_id_Clients = f.cli_id_Clients where fac_id_Factures = $1;
    _nom varchar(50);
    _prenom varchar(50);
    _nb_oeuvres integer;
    _montant float;
BEGIN
    open cur;
    fetch cur into _nom, _prenom, _nb_oeuvres, _montant;
    raise notice 'Facture de % oeuvres d`un montant de % € par % %.', _nb_oeuvres, _montant, _nom, _prenom;
    close cur;
END;
$$ language plpgsql;