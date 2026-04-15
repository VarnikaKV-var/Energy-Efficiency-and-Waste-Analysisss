-- Step 1: Create table
CREATE TABLE EnergyEfficiencyFlags (
    MachineID INT,
    Plant VARCHAR(50),
    MonthStart DATE,
    AvgEnergyPerUnit FLOAT,
    EfficiencyFlag VARCHAR(20)
);


-- Step 2: Insert calculated results
INSERT INTO energy_efficiency_flags
SELECT
    e.MachineID,
    e.Plant,
    DATEFROMPARTS(YEAR(e.Timestamp), MONTH(e.Timestamp), 1) AS MonthStart,
    
    (e.EnergyConsumption * 1.0 / NULLIF(e.ProductionUnits,0)) AS AvgEnergyPerUnit,

    CASE
        WHEN (e.EnergyConsumption * 1.0 / NULLIF(e.ProductionUnits,0))
             >
             (stats.PlantMonthAvg + stats.PlantMonthStd)
        THEN 'Inefficient'
        ELSE 'Efficient'
    END AS EfficiencyFlag

FROM [dbo].[ENERGY EFFICIENCY & WASTE] e

JOIN
(
    -- Plant month average + std deviation
    SELECT
        Plant,
        DATEFROMPARTS(YEAR(Timestamp), MONTH(Timestamp), 1) AS MonthStart,
        AVG(EnergyConsumption * 1.0 / NULLIF(ProductionUnits,0)) AS PlantMonthAvg,
        STDEV(EnergyConsumption * 1.0 / NULLIF(ProductionUnits,0)) AS PlantMonthStd
    FROM [dbo].[ENERGY EFFICIENCY & WASTE]
    GROUP BY
        Plant,
        DATEFROMPARTS(YEAR(Timestamp), MONTH(Timestamp), 1)
) stats

ON e.Plant = stats.Plant
AND DATEFROMPARTS(YEAR(e.Timestamp), MONTH(e.Timestamp), 1) = stats.MonthStart;

SELECT * FROM energy_efficiency_flags;