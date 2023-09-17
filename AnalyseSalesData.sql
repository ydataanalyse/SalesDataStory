/*********** 1. Analyse de la rentabilité des ventes ***********/

-- Quelles sont les tendances de rentabilité au fil des années (YEAR_ID) et des trimestres (QTR_ID) ?
SELECT sum(BENEFICE) AS Benefice, ANNEE_ID AS A, TRIMESTRE_ID AS T
FROM my_sales4
GROUP BY ANNEE_ID, TRIMESTRE_ID;

-- Quels produits ou lignes de produits (PRODUCTLINE) génèrent le plus de profit ?
SELECT LIGNE_PRODUIT, CODE_PRODUIT, sum(BENEFICE) AS BENEFICE
FROM my_sales4
GROUP BY LIGNE_PRODUIT, CODE_PRODUIT
ORDER BY BENEFICE DESC;

-- Quels clients (CUSTOMERNAME) contribuent le plus au profit total ?
SELECT NOM_CLIENT, sum(BENEFICE) AS BENEFICE
FROM my_sales4
GROUP BY NOM_CLIENT
ORDER BY BENEFICE DESC 
LIMIT 5;

-- Comment varie la rentabilité en fonction de la taille de la transaction (DEALSIZE) ?
SELECT TAILLE_TRANSACTION, sum(BENEFICE) AS BENEFICE
FROM my_sales4
GROUP BY TAILLE_TRANSACTION
ORDER BY BENEFICE DESC;

-- Quelles sont les variations de profit en fonction de la localisation géographique (CITY, COUNTRY) ?
SELECT PAYS, sum(BENEFICE) AS BENEFICE
FROM my_sales4
GROUP BY PAYS
ORDER BY BENEFICE DESC;

SELECT VILLE, sum(BENEFICE) AS BENEFICE
FROM my_sales4
GROUP BY VILLE
ORDER BY BENEFICE DESC;

# Comparaison de la rentabilité par rapport aux prévisions
-- Quels sont les produits ou les clients ayant la plus grande différence (ECART_PRIX_CONSEILLE) entre le prix réel et le prix prévu ?

SELECT LIGNE_PRODUIT AS PRODUIT, SUM(ECART_PRIX_CONSEILLE) AS ECART_PRIX_CONSEILLE
FROM my_sales4
GROUP BY LIGNE_PRODUIT
ORDER BY ECART_PRIX_CONSEILLE ASC;

SELECT NOM_CLIENT AS NOM_CLIENT , SUM(ECART_PRIX_CONSEILLE) AS ECART_PRIX_CONSEILLE
FROM my_sales4
GROUP BY NOM_CLIENT
ORDER BY ECART_PRIX_CONSEILLE ASC;

-- Comment varie l'ECART_PRIX_CONSEILLE en fonction de l'année (YEAR_ID) et du trimestre (QTR_ID) ?
SELECT ANNEE_ID, TRIMESTRE_ID, SUM(ECART_PRIX_CONSEILLE) AS ECART_PRIX_CONSEILLE
FROM my_sales4
GROUP BY ANNEE_ID, TRIMESTRE_ID
ORDER BY ECART_PRIX_CONSEILLE ASC;

-- Y a-t-il un lien entre l'ecart prix conseillé (PRICE) et le profit (BENEFICE) ?
SELECT ANNEE_ID, TRIMESTRE_ID, SUM(ECART_PRIX_CONSEILLE) AS ECART_PRIX_CONSEILLE, SUM(BENEFICE)
FROM my_sales4
GROUP BY ANNEE_ID, TRIMESTRE_ID
ORDER BY ECART_PRIX_CONSEILLE ASC;

-- Les produits avec des prix unitaires plus élevés génèrent-ils généralement un profit plus important ?
SELECT LIGNE_PRODUIT, MAX(PRIX_UNITAIRE_REEL) AS PRIX_UNITAIRE_REEL, SUM(BENEFICE) BENEFICE, sum(QUANTITE_COMMANDEE)
FROM my_sales4
GROUP BY LIGNE_PRODUIT
ORDER BY PRIX_UNITAIRE_REEL DESC;

/*********** 2. Suivi des performances des ventes ***********/

-- Comment évoluent les ventes (SALES) au fil du temps en fonction des mois (MONTH_ID) ?
SELECT MOIS_ID, SUM(CA) AS CA, sum(QUANTITE_COMMANDEE) AS QUANTITE_COMMANDEE
FROM my_sales4
GROUP BY MOIS_ID
ORDER BY CA DESC;


-- Les produits avec un écart (ECART) plus élevé entre le prix réel (PRICE_REEL) et le prix conseillé par le fabricant (MSRP) se vendent-ils mieux ?
SELECT
    LIGNE_PRODUIT,
    AVG(CA) AS Moyenne_Ventes,
    AVG(ECART_PRIX_CONSEILLE) AS Moyenne_Ecart
FROM
    my_sales4
GROUP BY
    LIGNE_PRODUIT
ORDER BY
    Moyenne_Ecart DESC;

/*********** 3. Gestion des clients ***********/

-- Quels sont les clients les plus fidèles en fonction du nombre de commandes (ORDERNUMBER) ?
SELECT
    NOM_CLIENT AS Nom_Client,
    COUNT(DISTINCT QUANTITE_COMMANDEE) AS Nombre_de_Commandes
FROM
    my_sales4
GROUP BY
    NOM_CLIENT
ORDER BY
    Nombre_de_Commandes DESC
    LIMIT 5;

-- Comment varie le profit par client en fonction de leur localisation géographique (CITY, COUNTRY) ?
SELECT
   
    PAYS AS Pays,
    SUM(BENEFICE) AS Total_benefice
FROM
    my_sales4
GROUP BY
	PAYS
ORDER BY
    Total_benefice DESC;

-- Y a-t-il des tendances saisonnières dans les achats des clients ?
SELECT
    MOIS_ID AS Mois,
    AVG(CA) AS Moyenne_Ventes
FROM
    my_sales4
GROUP BY
    MOIS_ID
ORDER BY
    Moyenne_Ventes DESC;

/*********** 4. Analyse des marges bénéficiaires ***********/

-- Quels produits ont les marges bénéficiaires les plus élevées (Profit) ?
SELECT
    LIGNE_PRODUIT AS Ligne_Produit,
    AVG(BENEFICE) AS Moyenne_Marge_Beneficiaire
FROM
    my_sales4
GROUP BY
    LIGNE_PRODUIT
ORDER BY
    Moyenne_Marge_Beneficiaire DESC;

-- Existe-t-il des produits pour lesquels le prix réel est significativement inférieur au prix conseillé par le fabricant (MSRP) ?
SELECT
    LIGNE_PRODUIT,
    CODE_PRODUIT,
    MIN(ECART_PRIX_CONSEILLE) AS ECART_PRIX_CONSEILLE
FROM
    my_sales4
GROUP BY 
    LIGNE_PRODUIT,
    CODE_PRODUIT
HAVING
    MIN(ECART_PRIX_CONSEILLE) < -100
ORDER BY
    ECART_PRIX_CONSEILLE DESC;


/*********** 5. Analyse des performances globales de l'entreprise ***********/

-- Comment évoluent les ventes totales et le profit total au fil du temps (YEAR_ID, MONTH_ID) ?
SELECT
    ANNEE_ID,
    MOIS_ID,
    SUM(CA) AS TotalSales,
    SUM(BENEFICE) AS TotalProfit
FROM
    my_sales4
GROUP BY
    ANNEE_ID,
    MOIS_ID
ORDER BY
    ANNEE_ID ASC,
   MOIS_ID ASC;

-- Quels sont les trimestres les plus rentables (QTR_ID) ?
SELECT
    TRIMESTRE_ID,
    SUM(BENEFICE) AS TotalProfit
FROM
    my_sales4
GROUP BY
    TRIMESTRE_ID
ORDER BY
    TotalProfit DESC;


-- Y a-t-il un lien entre le statut de la commande (STATUS) et le profit ?
SELECT
    STATUT_COMMANDE AS STATUT_COMMANDE, 
    AVG(BENEFICE) AS Moyenne_Profit
FROM
    my_sales4
GROUP BY
    STATUT_COMMANDE
ORDER BY
    Moyenne_Profit DESC;

/*********** 6. Analyse des écarts entre le prix réel et le prix conseillé par le fabricant (MSRP) ***********/

-- Quels sont les produits ayant les écarts les plus élevés entre le prix réel (PRICE_REEL) et le prix conseillé par le fabricant (MSRP) ?
SELECT
    LIGNE_PRODUIT,
    CODE_PRODUIT,
    ECART_PRIX_CONSEILLE
FROM
    my_sales4
ORDER BY
    ECART_PRIX_CONSEILLE DESC
LIMIT 10;


/*********** 7. Suivi de l'efficacité des ajustements de prix ***********/

-- Les produits pour lesquels le prix réel (PRICE_REEL) est inférieur au prix conseillé par le fabricant (MSRP) se vendent-ils mieux ?

SELECT
    LIGNE_PRODUIT,
    CODE_PRODUIT,
    AVG(CA) AS Moyenne_Ventes
FROM
    my_sales4
WHERE
    PRIX_UNITAIRE_REEL < PRIX_CONSEILLE_FABRICANT
GROUP BY 
    LIGNE_PRODUIT,
    CODE_PRODUIT
ORDER BY
    Moyenne_Ventes DESC;

-- VS les autres produits

SELECT
    LIGNE_PRODUIT,
    CODE_PRODUIT,
    AVG(CA) AS Moyenne_Ventes
FROM
    my_sales4
WHERE
    PRIX_UNITAIRE_REEL > PRIX_CONSEILLE_FABRICANT
GROUP BY 
    LIGNE_PRODUIT,
    CODE_PRODUIT
ORDER BY
    Moyenne_Ventes DESC;
