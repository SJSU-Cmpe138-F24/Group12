--Activity Recommendation
SELECT 
creation_time as _date,
geography as location,
(`forecast`[SAFE_OFFSET(0)].temperature_2m_above_ground * 9 / 5) + 32 AS temperature_F,
  
  SQRT(
    POW(`forecast`[SAFE_OFFSET(0)].u_component_of_wind_10m_above_ground, 2) +
    POW(`forecast`[SAFE_OFFSET(0)].v_component_of_wind_10m_above_ground, 2)
  ) AS wind_speed,

CASE
  WHEN (`forecast`[SAFE_OFFSET(0)].temperature_2m_above_ground * 9 / 5) + 32 BETWEEN 65 AND 80 AND 
  SQRT(
    POW(`forecast`[SAFE_OFFSET(0)].u_component_of_wind_10m_above_ground, 2) +
    POW(`forecast`[SAFE_OFFSET(0)].v_component_of_wind_10m_above_ground, 2)
  ) BETWEEN 0 AND 10 THEN 'Baseketball'

  WHEN (`forecast`[SAFE_OFFSET(0)].temperature_2m_above_ground * 9 / 5) + 32 BETWEEN 55 AND 85 AND 
  SQRT(
    POW(`forecast`[SAFE_OFFSET(0)].u_component_of_wind_10m_above_ground, 2) +
    POW(`forecast`[SAFE_OFFSET(0)].v_component_of_wind_10m_above_ground, 2)
  ) BETWEEN 0 AND 15 THEN 'Hiking'

  WHEN (`forecast`[SAFE_OFFSET(0)].temperature_2m_above_ground * 9 / 5) + 32 BETWEEN 25 AND 75 AND 
  SQRT(
    POW(`forecast`[SAFE_OFFSET(0)].u_component_of_wind_10m_above_ground, 2) +
    POW(`forecast`[SAFE_OFFSET(0)].v_component_of_wind_10m_above_ground, 2)
  ) BETWEEN 0 AND 20 THEN 'Snowboarding'
END AS sport_rec,

FROM `bigquery-public-data.noaa_global_forecast_system.NOAA_GFS0P25` 

WHERE creation_time BETWEEN DATETIME("2024-7-02") AND DATETIME_ADD("2024-7-02", INTERVAL 1 DAY)
AND ST_WITHIN(geography_polygon, ST_GEOGFROMTEXT('POLYGON((-179 51, -179 71, -141 71, -141 51, -179 51))'))
 LIMIT 10