/****** SQL QUERIES TO MINE DATA FROM THE DATA WAREHOUSE IMPLEMENTATION ******/

/****** RUN EACH QUERY ONE BY ONE TO SEE THE RESULTS *******/

USE water_quality;


--- The list of water sensors measured by type by month ---

SELECT 
	s.measurementMonth, s.sensorType, s.numberOfSensors FROM
	(
	SELECT 
		mt.measurementMonth, 
		st.sensorType, 
		COUNT(measurement) numberOfSensors
	FROM 
		dimSensorTable st 
		INNER JOIN factMeasurementsTable fm ON st.sensorID = fm.sensorID
		INNER JOIN dimTimeTable tt ON fm.dateTimeID = tt.dateTimeID
		INNER JOIN dimMonthTable mt ON tt.monthID = mt.monthID
	GROUP BY 
		st.sensorType, mt.measurementMonth 
	) s 
JOIN dimMonthTable mt ON s.measurementMonth = mt.measurementMonth
ORDER BY 
	mt.monthID, s.sensorType;



--- The number of sensor measurements collected by type by week ---

SELECT 
	wt.measurementWeek, 
	st.sensorType, 
	COUNT(measurement) numberOfMeasurements
FROM 
	dimSensorTable st 
	INNER JOIN factMeasurementsTable fm ON st.sensorID = fm.sensorID
	INNER JOIN dimTimeTable tt ON fm.dateTimeID = tt.dateTimeID
	INNER JOIN dimWeekTable wt ON tt.weekID = wt.weekID
GROUP BY 
	st.sensorType, wt.measurementWeek
ORDER BY
	wt.measurementWeek, st.sensorType;



--- The number of measurements made by location by month ---

SELECT 
	s.measurementMonth, s.measurementLocation, s.numberOfMeasurements FROM
	(
	SELECT 
		mt.measurementMonth, 
		lt.measurementLocation, 
		COUNT(measurement) numberOfMeasurements
	FROM 
		dimLocationTable lt 
		INNER JOIN factMeasurementsTable fm ON lt.locationID = fm.locationID
		INNER JOIN dimTimeTable tt ON fm.dateTimeID = tt.dateTimeID
		INNER JOIN dimMonthTable mt ON tt.monthID = mt.monthID
	GROUP BY 
		lt.measurementLocation, mt.measurementMonth
	) s
JOIN dimMonthTable mt ON s.measurementMonth = mt.measurementMonth
ORDER BY 
	mt.monthID, s.measurementLocation;



--- The average number of measurements covered for pH by year ---

SELECT 
	yt.measurementYear, 
	COUNT(measurement) numberOfMeasurements
FROM 
	dimSensorTable st 
	INNER JOIN factMeasurementsTable fm ON st.sensorID = fm.sensorID
	INNER JOIN dimTimeTable tt ON fm.dateTimeID = tt.dateTimeID
	INNER JOIN dimYearTable yt ON tt.yearID = yt.yearID
WHERE 
	st.sensorType = 'pH'
GROUP BY 
	yt.measurementYear
ORDER BY 
	yt.measurementYear;



--- The average value of nitrate measurements by locations by year ---

SELECT 
	yt.measurementYear,
	lt.measurementLocation,
	ROUND(AVG(measurement), 2) averageValuesOfNitrate
FROM 
	dimLocationTable lt 
	INNER JOIN factMeasurementsTable fm ON lt.locationID = fm.locationID
	INNER JOIN dimSensorTable st ON fm.sensorID = st.sensorID
	INNER JOIN dimTimeTable tt ON fm.dateTimeID = tt.dateTimeID
	INNER JOIN dimYearTable yt ON tt.yearID = yt.yearID
WHERE 
	st.sensorType = 'Nitrate-N'
GROUP BY 
	lt.measurementLocation, yt.measurementYear
ORDER BY 
	yt.measurementYear, lt.measurementLocation;


/****** END OF FILE *******//****** END OF FILE *******/
