{#
    
#}

{% macro get_ride_type(rideable_type_id) -%}

    case {{ dbt.safe_cast("rideable_type_id", api.Column.translate_type("integer")) }}  
        when 0 then 'Classic' 
        when 1 then 'Electric'
        else 'EMPTY'
    end

{%- endmacro %}