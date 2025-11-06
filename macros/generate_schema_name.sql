{% macro generate_schema_name(custom_schema_name, node) -%}
    {#
        Generates schema names with the following rules:
        1. If custom_schema_name is provided (in dbt_project.yml or model config), use that
        2. Otherwise, generates schema name from the folder structure after the database name
        3. For 'snowflake-dev-user', prefixes with the default schema
           (e.g., 'analytics' becomes '<user_schema>_analytics')
        4. In production or in a dev deployment, uses the schema name as-is
    #}
    
    {%- set default_schema = target.schema | trim -%}
    {%- set is_deployment = target.name != "default" -%}
    {%- set schema_name = none -%}
    
    {# Handle custom schema name if provided #}
    {%- if custom_schema_name is not none -%}
        {% set schema_name = custom_schema_name | trim %}
    
    {# No custom schema - generate from folder structure #}
    {%- else -%}
        {% set path_parts = node.fqn[2:-1] if node and node.fqn and node.fqn|length > 2 else [] %}
        {% if path_parts | length > 0 %}
            {% set schema_name = path_parts | join('_') | trim %}
        {% else %}
            {% set schema_name = default_schema %}
        {% endif %}
    {%- endif -%}
    
    {# Apply userschema as prefix if in dev environment and not a deployment #}
    {%- if not is_deployment and schema_name != default_schema -%}
        {{ default_schema }}_{{ schema_name }}
    {%- else -%}
        {{ schema_name }}
    {%- endif -%}
{%- endmacro %}