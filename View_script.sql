USE [Prod]
GO

/****** Object:  View [dbo].[v_prod_info_eb_zmd_axel]    Script Date: 19/10/2025 18:06:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER VIEW [dbo].[v_prod_info_eb_zmd_axel]
AS
/*
	update 17/10/2025 : PNI
	  - je supprime d'abord les doublons de la table prod.dbo.prod_pm_info parce qu'on passe de la granularité liaison à id_PM
	  - Je supprime les NRO avec O cartes installées. Ce sont des NRO où l'OLT n'est pas encore déployé
*/


with my_v_prod_pm_info as
	  -- je supprime d'abord les doublons de la table prod.dbo.prod_pm_info parce qu'on passe de la granularité liaison à id_PM
(select distinct
I.id_pm, I.partenaire_ff, I.splitter_c1, I.splitter_c2, I.splitter_c0, I.pon_paths
	, I.capa_increase
	, I.port_libre, I.port_total, I.lr_cible, I.lr_date, I.id_nro
	, I.etat_last_projet, I.zone
	, JAKA.Etat, JAKA.[Date Operation]

from prod.dbo.prod_pm_info AS I 
LEFT OUTER JOIN STG_BO.dbo.stg_bo_gcr_swap_jakarta AS JAKA ON I.id_olt = JAKA.[Element Conf]
)
SELECT      
	I.id_pm, I.partenaire_ff, I.splitter_c1, I.splitter_c2, I.splitter_c0, I.pon_paths
	, I.capa_increase
	, I.port_libre, I.port_total, I.lr_cible, I.lr_date, I.id_nro
	, I.etat_last_projet

	, I.Etat, I.[Date Operation]

	, NC.calibre_pm
	, NC.occupation
	, NC.partenaire_fiabilise
	, NRO.nb_pm_occup_sup_75
	, NRO.id_nra
	, NRO.Ports_dispo_ff
FROM           my_v_prod_pm_info AS I 
LEFT OUTER JOIN  Network_Configuration.dbo.nc_pm AS NC ON I.id_pm = NC.id_pm 
----LEFT OUTER JOIN  Network_Configuration.dbo.nc_nro AS NRO ON  NC.id_nro = NRO.id_nro 
LEFT OUTER JOIN  Network_Configuration.dbo.nc_nro AS NRO ON NC.id_nro = NRO.id_nro_prdm 

WHERE        (I.zone <> 'ZTD') 
	  -- Je supprime les NRO avec O cartes installées. Ce sont des NRO où l'OLT n'est pas encore déployé
and NRO.Ports_installés >0

/*
SELECT       distinct I.id_pm, I.partenaire_ff, I.splitter_c1, I.splitter_c2, I.splitter_c0, I.pon_paths, NC.calibre_pm, I.capa_increase, NRO.nb_pm_occup_sup_75, JAKA.Etat, JAKA.[Date Operation], NRO.Ports_dispo_ff, I.port_libre, I.port_total, I.lr_cible, 
                         I.lr_date, I.id_nro, NC.occupation, I.etat_last_projet, NRO.id_nra, NC.partenaire_fiabilise
FROM            dbo.prod_pm_info AS I LEFT OUTER JOIN
                         Network_Configuration.dbo.nc_pm AS NC ON I.id_pm = NC.id_pm LEFT OUTER JOIN
                         Network_Configuration.dbo.nc_nro AS NRO ON NC.id_nro = NRO.id_nro_prdm OR NC.id_nro = NRO.id_nro 
						 LEFT OUTER JOIN STG_BO.dbo.stg_bo_gcr_swap_jakarta AS JAKA ON I.id_olt = JAKA.[Element Conf]
WHERE        (I.zone <> 'ZTD')
*/
GO


