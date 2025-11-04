{% macro generate_database_name(custom_database_name=none, node=none) -%}
    {#
        Generates database names with the following rules:
        1. If custom_database_name is provided, use that
        2. Otherwise, use the first folder name after the models folder
        3. For 'snowflake-dev-user', always use the target database directly (which should be sandbox)
        4. Always prefix with the environment name (dev_ for snowflake-dev-user)
    #}
    
    {%- set default_database = target.database | trim -%}
    {%- set environment = 'dev' if target.name == 'snowflake-dev-user' else target.name -%}
    
    {# For snowflake-dev-user, always use the target database with environment prefix #}
    {%- if target.name == 'snowflake-dev-user' -%}
        {{ environment }}_{{ default_database }}
    
    {# For other targets, use the standard logic #}
    {%- else -%}
        {%- set db_name = none -%}
        
        {# Handle custom database name if provided #}
        {%- if custom_database_name is not none -%}
            {% set db_name = custom_database_name | trim %}
        
        {# No custom database - generate from folder structure #}
        {%- else -%}
            {% set first_folder = node.fqn[1] if node and node.fqn and node.fqn|length > 1 else none %}
            {% if first_folder %}
                {% set db_name = first_folder | trim %}
            {% else %}
                {% set db_name = default_database %}
            {% endif %}
        {%- endif -%}

        {{ environment }}_{{ db_name }}
    {%- endif -%}
{%- endmacro %}