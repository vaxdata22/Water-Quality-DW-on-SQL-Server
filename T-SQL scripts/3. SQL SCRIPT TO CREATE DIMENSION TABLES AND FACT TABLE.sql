/****** SQL SCRIPT TO CREATE DIMENSION TABLES AND FACT TABLE AND LOAD THEM *******/

/****** YOU CAN RUN THIS SCRIPT AT ONCE!!! *******/

USE water_quality;


--- To rename the columns ---

--- To rename the 15 columns ---

EXEC sp_rename 'dw_water_quality.[@id]', 'measurementMetadata', 'COLUMN';
    
EXEC sp_rename 'dw_water_quality.samplesamplingPoint', 'locationMetadata', 'COLUMN';
    
EXEC sp_rename 'dw_water_quality.samplesamplingPointnotation', 'locationNotation', 'COLUMN';

EXEC sp_rename 'dw_water_quality.samplesamplingPointlabel', 'measurementLocation', 'COLUMN';

EXEC sp_rename 'dw_water_quality.samplesampleDateTime', 'measurementDateTime', 'COLUMN';

EXEC sp_rename 'dw_water_quality.determinandlabel', 'sensorType', 'COLUMN';

EXEC sp_rename 'dw_water_quality.determinanddefinition', 'sensorTypeDefinition', 'COLUMN';
    
EXEC sp_rename 'dw_water_quality.determinandnotation', 'sensorNotation', 'COLUMN';

EXEC sp_rename 'dw_water_quality.result', 'measurement', 'COLUMN';

EXEC sp_rename 'dw_water_quality.determinandunitlabel', 'sensorUnit', 'COLUMN';
    
EXEC sp_rename 'dw_water_quality.sampleisComplianceSample', 'sampleCompliance', 'COLUMN';

EXEC sp_rename 'dw_water_quality.samplesampledMaterialTypelabel', 'samplingMaterial', 'COLUMN';

EXEC sp_rename 'dw_water_quality.samplepurposelabel', 'samplingPurpose', 'COLUMN';

EXEC sp_rename 'dw_water_quality.samplesamplingPointeasting', 'locationEasting', 'COLUMN';

EXEC sp_rename 'dw_water_quality.samplesamplingPointnorthing', 'locationNorthing', 'COLUMN';



--- To typecast the measurementDateTime column into DATETIME datatype ---

ALTER TABLE dw_water_quality ALTER COLUMN measurementDateTime DATETIME;


--- To add a measurementYear column of INTEGER datatype ---

ALTER TABLE dw_water_quality ADD measurementYear INT;
GO



--- To populate the measurementYear column with year data from measurementDateTime column ---

UPDATE dw_water_quality SET measurementYear = YEAR(measurementDateTime) WHERE measurementMetadata = measurementMetadata;

--- or, UPDATE dw_water_quality SET measurementYear = DATENAME(year, measurementDateTime) WHERE measurementMetadata = measurementMetadata;


--- To add a measurementWeek column of INTEGER datatype ---

ALTER TABLE dw_water_quality ADD measurementWeek INT;
GO



--- To populate the measurementWeek column with week data from measurementDateTime column ---

UPDATE dw_water_quality SET measurementWeek = DATEPART(WEEK, measurementDateTime) WHERE measurementMetadata = measurementMetadata;


--- To add a measurementMonth column of NVARCHAR datatype ---

ALTER TABLE dw_water_quality ADD measurementMonth NVARCHAR(15);
GO



--- To populate the measurementMonth column with week data from measurementDateTime column ---

UPDATE dw_water_quality SET measurementMonth = DATENAME(MONTH, measurementDateTime) WHERE measurementMetadata = measurementMetadata;



--- To create 9 dimension tables and a fact table ---

CREATE TABLE dimLocationTable (
    locationID INT NOT NULL PRIMARY KEY IDENTITY,
    locationMetadata NVARCHAR(255) NOT NULL,
    locationNotation NVARCHAR(255) NOT NULL,
    measurementLocation NVARCHAR(255) NOT NULL,
    locationEasting INT NOT NULL,
    locationNorthing INT NOT NULL
    );

CREATE TABLE dimPurposeTable (
    purposeID INT NOT NULL PRIMARY KEY IDENTITY,
    samplingPurpose NVARCHAR(255) NOT NULL
    );
    
CREATE TABLE dimComplianceTable (
    complianceID INT NOT NULL PRIMARY KEY IDENTITY,
    sampleCompliance INT NOT NULL
    );
    
CREATE TABLE dimSampleTable (
    sampleID INT NOT NULL PRIMARY KEY IDENTITY,
    samplingMaterial NVARCHAR(255) NOT NULL,
    );    
    
CREATE TABLE dimSensorTable (
    sensorID INT NOT NULL PRIMARY KEY IDENTITY,
    sensorType NVARCHAR(255) NOT NULL,
    sensorTypeDefinition NVARCHAR(255) NOT NULL,
    sensorNotation INT NOT NULL,
    sensorUnit NVARCHAR(255) NOT NULL
    );

CREATE TABLE dimYearTable (
    yearID INT NOT NULL PRIMARY KEY IDENTITY,
    measurementYear INT NOT NULL
    );

CREATE TABLE dimWeekTable (
    weekID INT NOT NULL PRIMARY KEY IDENTITY,
    measurementWeek INT NOT NULL
    );

CREATE TABLE dimMonthTable (
    monthID INT NOT NULL PRIMARY KEY IDENTITY,
    measurementMonth NVARCHAR(15) NOT NULL
    );

CREATE TABLE dimTimeTable (
    dateTimeID INT NOT NULL PRIMARY KEY IDENTITY,
    measurementDateTime DATETIME NOT NULL,
    yearID INT NOT NULL FOREIGN KEY REFERENCES dimYearTable(yearID),
    weekID INT NOT NULL FOREIGN KEY REFERENCES dimWeekTable(weekID),
    monthID INT NOT NULL FOREIGN KEY REFERENCES dimMonthTable(monthID)
    );

CREATE TABLE factMeasurementsTable (
    factID INT NOT NULL PRIMARY KEY IDENTITY,
    locationID INT NOT NULL FOREIGN KEY REFERENCES dimLocationTable(locationID),
    dateTimeID INT NOT NULL FOREIGN KEY REFERENCES dimTimeTable(dateTimeID),
    sensorID INT NOT NULL FOREIGN KEY REFERENCES dimSensorTable(sensorID),
    purposeID INT NOT NULL FOREIGN KEY REFERENCES dimPurposeTable(purposeID),
    complianceID INT NOT NULL FOREIGN KEY REFERENCES dimComplianceTable(complianceID),
    sampleID INT NOT NULL FOREIGN KEY REFERENCES dimSampleTable(sampleID),
    measurement FLOAT NOT NULL,
    sensorUnit NVARCHAR(255) NOT NULL
    );

GO



--- To add reference ID columns with INTEGER datatype to the staging table from the 7 dimension tables ---

ALTER TABLE dw_water_quality ADD locationID INT;

ALTER TABLE dw_water_quality ADD dateTimeID INT;

ALTER TABLE dw_water_quality ADD sensorID INT;

ALTER TABLE dw_water_quality ADD yearID INT;

ALTER TABLE dw_water_quality ADD monthID INT;

ALTER TABLE dw_water_quality ADD weekID INT;

ALTER TABLE dw_water_quality ADD purposeID INT;

ALTER TABLE dw_water_quality ADD complianceID INT;

ALTER TABLE dw_water_quality ADD sampleID INT;

GO



--- To load each of the 9 dimension tables with data as well as update the staging table with their IDs ---

INSERT INTO dimLocationTable(locationMetadata, locationNotation, measurementLocation, locationEasting, locationNorthing)
    SELECT DISTINCT locationMetadata, locationNotation, measurementLocation, locationEasting, locationNorthing
        FROM dw_water_quality 
    ORDER BY locationMetadata;

UPDATE dw_water_quality 
    SET dw_water_quality.locationID = dimLocationTable.locationID 
        FROM dw_water_quality 
    INNER JOIN dimLocationTable 
        ON dw_water_quality.measurementLocation = dimLocationTable.measurementLocation;

INSERT INTO dimSensorTable(sensorType, sensorTypeDefinition, sensorNotation, sensorUnit)
    SELECT DISTINCT sensorType, sensorTypeDefinition, sensorNotation, sensorUnit
        FROM dw_water_quality 
    ORDER BY sensorType;

UPDATE dw_water_quality 
    SET dw_water_quality.sensorID = dimSensorTable.sensorID 
        FROM dw_water_quality 
    INNER JOIN dimSensorTable 
        ON dw_water_quality.sensorType = dimSensorTable.sensorType;

INSERT INTO dimYearTable(measurementYear)
    SELECT DISTINCT measurementYear 
        FROM dw_water_quality 
    ORDER BY measurementYear;

UPDATE dw_water_quality 
    SET dw_water_quality.yearID = dimYearTable.yearID 
        FROM dw_water_quality 
    INNER JOIN dimYearTable 
        ON dw_water_quality.measurementYear = dimYearTable.measurementYear;

INSERT INTO dimWeekTable(measurementWeek)
    SELECT DISTINCT measurementWeek 
        FROM dw_water_quality 
    ORDER BY measurementWeek;

UPDATE dw_water_quality 
    SET dw_water_quality.weekID = dimWeekTable.weekID 
        FROM dw_water_quality 
    INNER JOIN dimWeekTable 
        ON dw_water_quality.measurementWeek = dimWeekTable.measurementWeek;

INSERT INTO dimMonthTable(measurementMonth)
    SELECT s.measurementMonth FROM 
        (
        SELECT DISTINCT measurementMonth, DATEPART(MONTH, measurementDateTime) c 
            FROM dw_water_quality
        ) s 
    ORDER BY c ASC;

UPDATE dw_water_quality 
    SET dw_water_quality.monthID = dimMonthTable.monthID 
        FROM dw_water_quality 
    INNER JOIN dimMonthTable 
        ON dw_water_quality.measurementMonth = dimMonthTable.measurementMonth;

INSERT INTO dimTimeTable(measurementDateTime, yearID, weekID, monthID)
    SELECT DISTINCT measurementDateTime, yearID, weekID, monthID 
        FROM dw_water_quality 
    ORDER BY yearID ASC;

UPDATE dw_water_quality 
    SET dw_water_quality.dateTimeID = dimTimeTable.dateTimeID 
        FROM dw_water_quality 
    INNER JOIN dimTimeTable 
        ON dw_water_quality.measurementDateTime = dimTimeTable.measurementDateTime
    AND dw_water_quality.yearID = dimTimeTable.yearID
    AND dw_water_quality.monthID = dimTimeTable.monthID
    AND dw_water_quality.weekID = dimTimeTable.weekID;
    
INSERT INTO dimPurposeTable(samplingPurpose)
    SELECT DISTINCT samplingPurpose 
        FROM dw_water_quality 
    ORDER BY samplingPurpose;

UPDATE dw_water_quality
    SET dw_water_quality.purposeID = dimPurposeTable.purposeID 
        FROM dw_water_quality 
    INNER JOIN dimPurposeTable 
        ON dw_water_quality.samplingPurpose = dimPurposeTable.samplingPurpose;
        
INSERT INTO dimComplianceTable(sampleCompliance)
    SELECT DISTINCT sampleCompliance 
        FROM dw_water_quality 
    ORDER BY sampleCompliance;

UPDATE dw_water_quality
    SET dw_water_quality.complianceID = dimComplianceTable.complianceID 
        FROM dw_water_quality 
    INNER JOIN dimComplianceTable 
        ON dw_water_quality.sampleCompliance = dimComplianceTable.sampleCompliance;
        
INSERT INTO dimSampleTable(samplingMaterial)
    SELECT DISTINCT samplingMaterial 
        FROM dw_water_quality 
    ORDER BY samplingMaterial;

UPDATE dw_water_quality
    SET dw_water_quality.sampleID = dimSampleTable.sampleID 
        FROM dw_water_quality 
    INNER JOIN dimSampleTable 
        ON dw_water_quality.samplingMaterial = dimSampleTable.samplingMaterial;
        
INSERT INTO factMeasurementsTable (
    locationID, dateTimeID, sensorID, purposeID, complianceID, sampleID, measurement, sensorUnit
    ) 
    SELECT 
        l.locationID, t.dateTimeID, s.sensorID, p.purposeID, c.complianceID, sm.sampleID, wq.measurement, s.sensorUnit
    FROM dw_water_quality wq
        INNER JOIN dimLocationTable l 
    ON wq.measurementLocation = l.measurementLocation
        INNER JOIN dimSensorTable s 
    ON wq.sensorType = s.sensorType
        INNER JOIN dimPurposeTable p 
    ON wq.samplingPurpose = p.samplingPurpose
        INNER JOIN dimComplianceTable c 
    ON wq.sampleCompliance = c.sampleCompliance
        INNER JOIN dimSampleTable sm 
    ON wq.samplingMaterial = sm.samplingMaterial
        INNER JOIN dimTimeTable t 
    ON wq.measurementDateTime = t.measurementDateTime
        INNER JOIN dimYearTable y 
    ON wq.measurementYear = y.measurementYear
        INNER JOIN dimWeekTable w 
    ON wq.measurementWeek = w.measurementWeek
        INNER JOIN dimMonthTable m 
    ON wq.measurementMonth = m.measurementMonth;



--- To see each of the 9 dimension tables as well as the fact table ---

SELECT * FROM factMeasurementsTable;
SELECT * FROM dimLocationTable;
SELECT * FROM dimSensorTable;
SELECT * FROM dimPurposeTable;
SELECT * FROM dimComplianceTable;
SELECT * FROM dimSampleTable;
SELECT * FROM dimTimeTable;
SELECT * FROM dimYearTable;
SELECT * FROM dimWeekTable;
SELECT * FROM dimMonthTable;


/****** END OF SCRIPT *******//****** END OF SCRIPT *******/
