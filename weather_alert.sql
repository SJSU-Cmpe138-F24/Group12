--Weather Emergency Alert
SELECT 
creation_time as _date,
geography as location,
(`forecast`[SAFE_OFFSET(0)].temperature_2m_above_ground * 9 / 5) + 32 AS temperature_F,
  
 `forecast`[SAFE_OFFSET(0)].specific_humidity_2m_above_ground,

  SQRT(
    POW(`forecast`[SAFE_OFFSET(0)].u_component_of_wind_10m_above_ground, 2) +
    POW(`forecast`[SAFE_OFFSET(0)].v_component_of_wind_10m_above_ground, 2)
  ) AS wind_speed,

CASE
  WHEN (`forecast`[SAFE_OFFSET(0)].temperature_2m_above_ground * 9 / 5) + 32 > 100 THEN 'Extreme Heat'
  WHEN (`forecast`[SAFE_OFFSET(0)].temperature_2m_above_ground * 9 / 5) + 32 < 0 THEN 'Extreme Cold'
  WHEN SQRT(
    POW(`forecast`[SAFE_OFFSET(0)].u_component_of_wind_10m_above_ground, 2) +
    POW(`forecast`[SAFE_OFFSET(0)].v_component_of_wind_10m_above_ground, 2)
  ) > 100 THEN 'High Wind'
  WHEN (`forecast`[SAFE_OFFSET(0)].precipitable_water_entire_atmosphere) > 40 THEN 'Heavy Rain'
END AS emergency_alert,

FROM `bigquery-public-data.noaa_global_forecast_system.NOAA_GFS0P25` 

--Bottom line is for current day
--WHERE creation_time >= CURRENT_DATETIME() AND creation_time < CURRENT_DATETIME + INTERVAL 1 DAY
WHERE creation_time BETWEEN DATETIME("2024-12-02") AND DATETIME_ADD("2024-12-02", INTERVAL 1 DAY)
AND ST_WITHIN(geography_polygon, ST_GEOGFROMTEXT('POLYGON((-179 51, -179 71, -141 71, -141 51, -179 51))'))
 LIMIT 10