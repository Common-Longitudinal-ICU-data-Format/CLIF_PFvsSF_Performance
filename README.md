# Differential Severity Classification and Prognostic Performance of PaO2/FiO2 versus SpO2/FiO2 Ratios in Acute Hypoxemic Respiratory Failure

## CLIF VERSION 

[2].[1]

## Objective

To evaluate for differential severity classification and prognostic performance of PaO2/FiO2 versus SpO2/FiO2 in a sample of hospitalized patients receiving non-invasive or invasive respiratory support across the Common Longitudinal ICU data Format (CLIF).

## Required CLIF tables and fields

Please refer to the online [CLIF data dictionary](https://clif-icu.com/data-dictionary), and [ETL tools]([https://github.com/clif-consortium/CLIF/tree/main/etl-to-clif-resources](https://clif-icu.com/tools)) for more information on constructing the required tables and fields. 

The following tables are required:
1. **adt**: `hospitalization_id`, `hospital_id`, `hospital_type`, `in_dttm`, `out_dttm`, `location_name`, `location_category`, `location_type`
2. **code_status**:`patient_id`, `start_dttm`, `code_status_name`, `code_status_category`
3. **hospitalization**: `patient_id`, `hospitalization_id`, `admission_dttm`, `discharge_dttm`, `age_at_admission`, `admission_type_category`, `discharge_category`
5. **hospital_diagnosis**: `hospitalization_id`, `diagnosis_code`, `diagnosis_code_format`, `diagnosis_primary`, `poa_present`
6. **labs**: `hospitalization_id`, `lab_collect_dttm`, `lab_category`, `lab_order_category`, `lab_value_numeric`, `reference_unit`
   - `lab_category` = 'platelet_count', `bilirubin_total`, `creatinine`
7. **medication_admin_continuous**: `hospitalization_id`, `admin_dttm`, `med_name`, `med_category`, `med_dose`, `med_dose_unit`
   - `med_category` = "norepinephrine", "epinephrine", "phenylephrine", "vasopressin", "dopamine", "angiotensin", "nicardipine"
8. **patient**: `patient_id`, `race_category`, `ethnicity_category`, `sex_category`
9. **respiratory_support**: `hospitalization_id`, `recorded_dttm`, `device_category`, `mode_category`, `tracheostomy`, `fio2_set`, `lpm_set`, `resp_rate_set`, `peep_set`, `resp_rate_obs`
10. **vitals**: `hospitalization_id`, `recorded_dttm`, `vital_category`, `vital_value`
   - `vital_category` = 'heart_rate', 'resp_rate', 'sbp', 'dbp', 'map', 'resp_rate', 'spo2'

## Cohort identification
Inclusion Criteria: 
1)	Adults (>=18 years) treated in a CLIF consortium hospital between 2021-2024
2)	Admitted to the hospital (any level of care initially) via the emergency department
3)	Received HIFNC with flow of > 30 L/min, NIPPV, or IMV for > 24 hours within 7 days of ED presentation
4)	ICU and/or Intermediate-care Admission During Index Hospitalization 

Exclusion Criteria: 
1)	First airway is tracheostomy [To exclude chronic mechanical ventilation)
2)	Does not have orders for comfort-care code status in the first 24 hours of respiratory support
3)	No available data for FIO2
4)	For patients with more than 1 eligible encounter, 1 eligible encounter per patient will be randomly selected for inclusion in the final sample

 ## Expected Results
a. Table 1 details for cohort
b. Flow diagram details for inclusion/exclusion criteria
c. Table of counts and percentage of oxygenation severity classification by S/F vs P/V
d. Table of events (in-hospital death or hospice discharge) within S/F ratios (will pool across fine strata so no patient level data is shared)

## Detailed Instructions for running the project

## 1. Update `config_tempate.yaml` to reflect local details
Required elements are:
clif_data_path
project_path
file_type

## 2. Set up the project environment

Libraries are loaded in the R markdown files.

## 3. Run code
In the Code file you will find:
00_pf_sf_cohort_id.Rmd
01_pf_sf_local_analysis.Rmd

Please run these one after the other. The 01 file can run off of tables that are saved from the 00 fle, so doesn't need to be during same session.

Detailed instructions on the code workflow are provided in the [code directory](code/README.md)

## 4. Upload Results
Please upload all the tables in proj_output (all summary tables) to the BOX folder. 


---


