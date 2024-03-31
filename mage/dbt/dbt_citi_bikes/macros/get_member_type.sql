{#
   
#}

{% macro get_member_type(member_casual_id) -%}

    case {{ dbt.safe_cast("member_casual_id", api.Column.translate_type("integer")) }}  
        when 0 then 'Member'
        when 1 then 'Casual'
        else 'EMPTY'
    end

{%- endmacro %}