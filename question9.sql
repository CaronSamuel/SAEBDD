/* Question 9 */

CREATE OR REPLACE FUNCTION auteur_pourcentage() RETURNS table(nom_auteurs varchar(50), nb_ventes bigint) as $$
BEGIN
    return query select auteur_nom_auteurs, count(*) FROM auteurs as a 
        inner join oeuvres as o on a.auteur_id_auteurs = o.auteur_id_auteurs 
        inner join ventes as v on o.oeuvre_id_Oeuvres = v.oeuvre_id_Oeuvres
            GROUP BY a.auteur_id_auteurs 
            HAVING count(*) >= (select best_auteur()) * 0.80 and count(*) <= (select best_auteur()) * 0.90;
END;
$$ LANGUAGE plpgsql;