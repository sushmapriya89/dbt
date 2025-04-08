{{ config(materialized='incremental') }}

SELECT
    md5(customer_id) AS customer_hk,
    customer_id,
    load_date,
    record_source
FROM {{ source('raw', 'customer_account') }}
{% if is_incremental() %}
WHERE load_date > (SELECT max(load_date) FROM {{ this }})
{% endif %}
