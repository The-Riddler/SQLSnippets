--
-- DRAW A FREQUENCY COUNT TO SSMS
--
-- To use, replace INSERT INTO @TMP with a query to populate
-- the table with real data. It will be plotted in a "Spatial results"
-- tab in SSMS
--
-- Bars are unlabeled but drawn in ascending catagory order
--

DECLARE @XWidth FLOAT;
DECLARE @DRAWBUF AS VARCHAR(8000);
DECLARE @TMP AS TABLE (
	catagory INT,
	frequency INT
)

INSERT INTO @TMP (catagory, frequency) VALUES
	(1,  2853627),
	(2,  479779),
	(3,  613216),
	(4,  312677),
	(5,  163185),
	(6,  231329),
	(7,  139842),
	(8,  56902),
	(9,  174677),
	(10, 14651),
	(11, 163320),
	(12, 9028),
	(13, 89383),
	(14, 3592),
	(15, 1306),
	(16, 2873),
	(17, 628),
	(18, 271),
	(19, 3251),
	(20, 2875),
	(21, 110),
	(22, 34),
	(23, 804),
	(25, 12)
;

SET @XWidth = (SELECT MAX(frequency) FROM @TMP) / (SELECT COUNT(catagory) FROM @tmp);
SET @DRAWBUF = STUFF(
	(SELECT ',((' +
		CAST( @XWidth * (ROW_NUMBER() OVER (order by catagory)) AS VARCHAR(30) ) + ' 0,', --BOTTOM LEFT
		CAST( @XWidth * (ROW_NUMBER() OVER (order by catagory)) AS VARCHAR(30) ) + ' '  + CAST(frequency AS VARCHAR(30)) + ',', --TOP LEFT
		CAST( @XWidth * (ROW_NUMBER() OVER (order by catagory)) + @XWidth * 0.6 AS VARCHAR(30) ) + ' '  + CAST(frequency AS VARCHAR(30)) + ',', --TOP RIGHT
		CAST( @XWidth * (ROW_NUMBER() OVER (order by catagory)) + @XWidth * 0.6 AS VARCHAR(30) ) + ' 0,', --BOTTOM RIGHT
		CAST( @XWidth * (ROW_NUMBER() OVER (order by catagory)) AS VARCHAR(30) ) + ' 0))' --BACK TO THE START
	FROM @TMP
	ORDER BY catagory ASC
	FOR XML PATH('')),
	1, 1, ''
);
--SELECT @DRAWBUF;
SELECT * FROM @TMP ORDER BY catagory ASC;
SELECT geometry::STGeomFromText('MULTIPOLYGON(' + @DRAWBUF + ')', 0);
