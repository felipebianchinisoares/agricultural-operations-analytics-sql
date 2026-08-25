-- 1. Cost and yield KPIs by field and season.
WITH operation_costs AS (
  SELECT field_season_id, SUM(actual_cost_brl) AS total_cost, SUM(planned_cost_brl) AS planned_cost
  FROM operations GROUP BY field_season_id
)
SELECT fa.farm_name, f.field_name, s.season_label, c.crop_name, f.area_ha, fs.yield_t_ha,
       ROUND(o.total_cost / f.area_ha, 2) AS cost_brl_ha,
       ROUND((o.total_cost - o.planned_cost) * 100.0 / NULLIF(o.planned_cost,0), 2) AS budget_variance_pct
FROM field_seasons fs JOIN fields f USING(field_id) JOIN farms fa USING(farm_id)
JOIN seasons s USING(season_id) JOIN crops c USING(crop_id) JOIN operation_costs o USING(field_season_id)
ORDER BY cost_brl_ha DESC;

-- 2. Machine maintenance ranking with a window function.
WITH machine_kpis AS (
  SELECT m.machine_code, m.machine_type, COUNT(me.event_id) AS event_count,
         COALESCE(SUM(me.downtime_hours),0) AS downtime_hours,
         COALESCE(SUM(me.maintenance_cost_brl),0) AS maintenance_cost_brl
  FROM machines m LEFT JOIN maintenance_events me USING(machine_id)
  GROUP BY m.machine_id
)
SELECT *, DENSE_RANK() OVER (ORDER BY downtime_hours DESC) AS downtime_rank
FROM machine_kpis ORDER BY downtime_rank, machine_code;

-- 3. Operations above plan.
SELECT operation_id, operation_type, operation_date, machine_code, planned_cost_brl, actual_cost_brl,
       ROUND(actual_cost_brl-planned_cost_brl,2) AS overrun_brl
FROM operations LEFT JOIN machines USING(machine_id)
WHERE actual_cost_brl > planned_cost_brl ORDER BY overrun_brl DESC;

-- 4. Maintenance risk rules using conditional aggregation.
SELECT m.machine_code, m.engine_hours,
       SUM(CASE WHEN me.event_type='Corrective' THEN 1 ELSE 0 END) AS corrective_events,
       COALESCE(SUM(me.downtime_hours),0) AS downtime_hours,
       CASE WHEN m.engine_hours >= 4000 AND SUM(CASE WHEN me.event_type='Corrective' THEN 1 ELSE 0 END) >= 2 THEN 'High'
            WHEN COALESCE(SUM(me.downtime_hours),0) >= 10 THEN 'Medium' ELSE 'Low' END AS maintenance_risk
FROM machines m LEFT JOIN maintenance_events me USING(machine_id)
GROUP BY m.machine_id ORDER BY CASE maintenance_risk WHEN 'High' THEN 1 WHEN 'Medium' THEN 2 ELSE 3 END;
