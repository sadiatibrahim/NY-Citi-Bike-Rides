{% set execution_date = var('execution_date') %}
{% set previous_month_date = execution_date | parse_date('%Y-%m-%d') - timedelta(days=execution_date | parse_date('%d') + 1) %}

-- Format the date as YYYYMM and set the day as 01
{% set formatted_date = previous_month_date | dateformat('%Y%m') ~ '01' %}

-- Convert the formatted string to a date
{% set date_partition = formatted_date | parse_date('%Y%m%d') %}

INSERT INTO {{ this }}
SELECT '{{ date_partition }}' as date_partition