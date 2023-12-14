/****** SQL QUERIES TO EXPLORE THE COLUMNS IN OUR STAGING TABLE AND DO SOME CLEANING ******/

/****** RUN EACH QUERY ONE BY ONE TO SEE THE RESULTS *******/

USE water_quality;

--- samplesamplingPointlabel column ---

SELECT DISTINCT samplesamplingPointlabel
	FROM dw_water_quality;	--- 81 unique locations

SELECT * FROM dw_water_quality
	WHERE samplesamplingPointlabel IS NULL;		--- no null records

SELECT * FROM dw_water_quality
	WHERE samplesamplingPointlabel NOT IN 
		(
		SELECT DISTINCT samplesamplingPointlabel
			FROM dw_water_quality
		);	--- no inconsistent records

SELECT samplesamplingPointlabel, COUNT(samplesamplingPointlabel) cnt
	FROM dw_water_quality
GROUP BY samplesamplingPointlabel 
ORDER BY cnt;	--- up to 20 locations appear less than three times


--- samplesampleDateTime column ---

SELECT DISTINCT samplesampleDateTime
	FROM dw_water_quality;	--- 1077 unique timestamps

SELECT * FROM dw_water_quality
	WHERE samplesampleDateTime IS NULL;		--- no null records


--- determinandlabel column ---

SELECT DISTINCT determinandlabel, determinanddefinition
	FROM dw_water_quality;	--- 173 unique sensor types

SELECT * FROM dw_water_quality
	WHERE determinandlabel IS NULL
	OR determinanddefinition IS NULL;	--- no null records

SELECT * FROM dw_water_quality
	WHERE determinandlabel NOT IN 
		(
		SELECT DISTINCT determinandlabel
			FROM dw_water_quality
		);	--- no inconsistent records

SELECT determinandlabel, COUNT(determinandlabel) cnt
	FROM dw_water_quality
GROUP BY determinandlabel 
ORDER BY cnt;	--- up to 95 sensors out of 173 appear less than three times


--- determinandlabel column ---

SELECT DISTINCT determinandunitlabel
	FROM dw_water_quality;	--- 12 unique units

SELECT * FROM dw_water_quality
	WHERE determinandunitlabel IS NULL;	--- no null records

SELECT * FROM dw_water_quality
	WHERE determinandunitlabel NOT IN 
		(
		SELECT DISTINCT determinandunitlabel
			FROM dw_water_quality
		);	--- no inconsistent records

SELECT determinandunitlabel, COUNT(determinandunitlabel) cnt
	FROM dw_water_quality
GROUP BY determinandunitlabel 
ORDER BY cnt;	--- about 5 out of 12 units appear in less than 50 records

SELECT * FROM dw_water_quality
	WHERE determinandunitlabel = 'unitless'
		UNION
SELECT * FROM dw_water_quality
	WHERE determinandunitlabel = 'text'	
		UNION
SELECT * FROM dw_water_quality
	WHERE determinandunitlabel = 'coded';	--- to be deleted because these 49 records seem not to be important

SELECT DISTINCT s.determinanddefinition FROM
	(
	SELECT * FROM dw_water_quality
		WHERE determinandunitlabel = 'unitless'
			UNION
	SELECT * FROM dw_water_quality
		WHERE determinandunitlabel = 'text'	
			UNION
	SELECT * FROM dw_water_quality
		WHERE determinandunitlabel = 'coded'
	) s;	--- this shows the reason why these 49 records seem not to be important


--- result column ---

SELECT DISTINCT result
	FROM dw_water_quality
		ORDER BY result;	--- 1190 unique results

SELECT * FROM dw_water_quality
	WHERE result IS NULL;	--- no null records

SELECT * FROM dw_water_quality
	WHERE result NOT IN 
		(
		SELECT DISTINCT result
			FROM dw_water_quality
		);	--- no inconsistent records


--- DATA CLEANING ---

DELETE FROM dw_water_quality 
	WHERE id IN
		(
		SELECT s.id FROM
			(
			SELECT * FROM dw_water_quality
				WHERE determinandunitlabel = 'unitless'
					UNION
			SELECT * FROM dw_water_quality
				WHERE determinandunitlabel = 'text'	
					UNION
			SELECT * FROM dw_water_quality
				WHERE determinandunitlabel = 'coded'
			) s
		);	--- deleted 49 out of 2348 records



--- view the residual staging table ---

SELECT * FROM dw_water_quality;	


/****** END OF FILE *******//****** END OF FILE *******/
