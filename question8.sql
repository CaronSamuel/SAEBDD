/* Question 7 */

/* Pour prouver enlever les order by et limit */

CREATE OR REPLACE FUNCTION best_auteur() RETURNS table(nb_ventes bigint) as $$
BEGIN
    return query select count(*) FROM auteurs as a 
        inner join oeuvres as o on a.auteur_id_auteurs = o.auteur_id_auteurs 
        inner join ventes as v on o.oeuvre_id_Oeuvres = v.oeuvre_id_Oeuvres
            GROUP BY a.auteur_id_auteurs order by count(*) desc limit 1;
END;
$$ LANGUAGE plpgsql;