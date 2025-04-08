{{ config(materialized='incremental') }}

SELECT
    md5(customer_id || '-' || account_id) AS customer_account_lk,
    md5(customer_id) AS customer_hk,
    md5(account_id) AS account_hk,
    load_date,
    record_source
FROM {{ source('raw', 'customer_account') }}
{% if is_incremental() %}
WHERE load_date > (SELECT max(load_date) FROM {{ this }})
{% endif %}
