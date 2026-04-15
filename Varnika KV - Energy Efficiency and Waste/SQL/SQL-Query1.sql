-- ===============================
-- Monthly Metrics by Plant
-- ===============================
WITH MonthlyMetrics AS (
    SELECT
        Plant,
        DATEFROMPARTS(YEAR([Timestamp]), MONTH([Timestamp]), 1) AS MonthStart,
        SUM(EnergyConsumption) AS TotalEnergyConsumption,
        SUM(ProductionUnits) AS TotalProductionUnits,
        SUM(EnergyConsumption) * 1.0 / NULLIF(SUM(ProductionUnits), 0) AS EnergyPerUnit
    FROM [dbo].[ENERGY EFFICIENCY & WASTE]
    GROUP BY Plant, DATEFROMPARTS(YEAR([Timestamp]), MONTH([Timestamp]), 1)
)
SELECT *
FROM MonthlyMetrics
ORDER BY Plant, MonthStart;


-- ===============================
-- Top 10 Machines Today
-- ===============================
WITH TopMachinesToday AS (
    SELECT TOP 10
        MachineID,
        AVG(EnergyConsumption * 1.0 / NULLIF(ProductionUnits, 0)) AS AvgEnergyPerUnitToday
    FROM [dbo].[ENERGY EFFICIENCY & WASTE]
    WHERE CAST([Timestamp] AS DATE) = CAST(GETDATE() AS DATE)
    GROUP BY MachineID
    ORDER BY AvgEnergyPerUnitToday DESC
)
SELECT *
FROM TopMachinesToday;