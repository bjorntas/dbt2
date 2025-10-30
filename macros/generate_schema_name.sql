{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {%- if custom_schema_name is none -%}
        {# If no schema is set in dbt_project.yml or directly in the model #}

        {%- if node.fqn[1:-1]|length == 0 -%}
            {# If the model isnt placed in a subfolder, use the default schema #}
            {{ default_schema }}    
        {%- else -%}
            {# otherwise, use the folder structure as the schema name #}
            {%- set folder_as_schema = node.fqn[1:-1]|join('_') -%}

            {%- if target.name == "user" -%}
                {{ folder_as_schema | trim }}
            {%- else -%}
                {{ default_schema }}_{{ folder_as_schema | trim }}
            {%- endif -%}
        {%- endif -%}

    {%- else -%}

        {%- if target.name == "user" -%}
            {{ default_schema }}_{{ custom_schema_name | trim }}
        {%- else -%}
            {{ custom_schema_name | trim }}
        {%- endif -%}

    {%- endif -%}

{%- endmacro %}
