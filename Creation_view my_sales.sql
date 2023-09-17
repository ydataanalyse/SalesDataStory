-- Créer une view avec prise en compte des modifications apportées
CREATE VIEW my_sales AS
SELECT
    ORDERNUMBER,
    QUANTITYORDERED,
    CAST(PRICEEACH AS DECIMAL(10, 2)) AS PRICEEACH,
    ORDERLINENUMBER,
    CAST(SALES AS DECIMAL(10, 2)) AS SALES,
    STATUS,
    QTR_ID,
    MONTH_ID,
    CASE
        WHEN YEAR_ID = 2005 THEN 2022
        WHEN YEAR_ID = 2004 THEN 2021
        WHEN YEAR_ID = 2003 THEN 2020
        ELSE YEAR_ID
    END AS YEAR_ID,
    PRODUCTLINE,
    MSRP,
    PRODUCTCODE,
    CUSTOMERNAME,
    CITY,
    COUNTRY,
    CONTACTLASTNAME,
    CONTACTFIRSTNAME,
    DEALSIZE
FROM
    salesd
ORDER BY
    ORDERNUMBER ASC;
    
  -- select* from my_sales1;
    
-- Créer une vue avec la colonne "ECART" au format décimal avec 2 chiffres après la virgule
CREATE VIEW my_sales1 AS
SELECT
    *,
    CAST((PRICEEACH * QUANTITYORDERED - SALES) AS DECIMAL(10, 2)) AS ECART
FROM
    my_sales;

-- Ajouter la colonne "PRICE REEL" à la vue 
CREATE VIEW my_sales2
AS
SELECT
    *,
    CAST((SALES / QUANTITYORDERED) AS DECIMAL(10, 2)) AS PRICE_REEL
FROM
    my_sales1;
    
     -- select* from my_sales2;
	
-- Afficher le nombre de ligne
SELECT COUNT(*) as TotalRows
FROM my_sales2;

-- Vérifier qu'on a les mêmes chiffres sur Sales et Price_réel
select COUNTRY,
SUM(PRICE_REEL* QUANTITYORDERED),
sum(SALES)
from my_sales2
group by country
order by country DESC;

-- Créer une vue avec les colonnes de "my_sales2" et les nouvelles colonnes calculées
CREATE VIEW my_sales3 AS
SELECT
    *,
    (MSRP - PRICE_REEL) AS Difference,
    (SALES - (MSRP * QUANTITYORDERED)) AS Profit
FROM
    my_sales2;
    
-- Créer une vue avec les colonnes de "my_sales2" et les nouvelles colonnes calculées
CREATE VIEW my_sales3 AS
SELECT
    *,
    CAST((MSRP - PRICE_REEL) AS DECIMAL(10, 2)) AS DIFFERENCE,
    CAST((SALES - (MSRP * QUANTITYORDERED)) AS DECIMAL(10, 2)) AS PROFIT
FROM
    my_sales2;

-- select* from my_sales3;

-- Créer une vue avec des noms de colonnes en français
CREATE VIEW my_sales4 AS
SELECT
    ORDERNUMBER AS NUMERO_COMMANDE,
    QUANTITYORDERED AS QUANTITE_COMMANDEE,
    PRICEEACH AS PRIX_UNITAIRE,
    ORDERLINENUMBER AS NUMERO_LIGNE_COMMANDE,
    SALES AS CA,
    STATUS AS STATUT_COMMANDE,
    QTR_ID AS TRIMESTRE_ID,
    MONTH_ID AS MOIS_ID,
    YEAR_ID AS ANNEE_ID,
    PRODUCTLINE AS LIGNE_PRODUIT,
    MSRP AS PRIX_CONSEILLE_FABRICANT,
    PRODUCTCODE AS CODE_PRODUIT,
    CUSTOMERNAME AS NOM_CLIENT,
    CITY AS VILLE,
    COUNTRY AS PAYS,
    CONTACTLASTNAME AS NOM_CONTACT,
    CONTACTFIRSTNAME AS PRENOM_CONTACT,
    DEALSIZE AS TAILLE_TRANSACTION,
    ECART AS DIFFERENCE_PRIX_UNITAIRE,
    PRICE_REEL AS PRIX_UNITAIRE_REEL,
    DIFFERENCE AS ECART_PRIX_CONSEILLE,
    PROFIT AS BENEFICE
FROM
    my_sales3;



