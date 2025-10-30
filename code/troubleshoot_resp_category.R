check <- data_list$analytic_cohort.parquet |>
  filter(!resp_support_category %in% c('imv', 'high_flow_nc', 'nippv', 'cpap')) |>
  as.data.table()

check_resp <- data_list$resp_support_pf_v_sf.parquet |>
  semi_join(check, by='hospital_block_id') |>
  left_join(check %>% select(hospital_block_id, resp_failure_start, resp_failure_stop, resp_support_category)) |>
  relocate(resp_failure_start, resp_support_category, .before = 'recorded_dttm') |>
  as.data.table()
