{% if 'wars' in wars_to_upload_to_databases[item] %}
    {% for warname in wars_to_upload_to_databases[item]['wars'] %}
        cat `find {{warname}}*/{{database_subfolder_in_wars}} -maxdepth 1  -iname *.sql | sort -h` | PGPASSWORD="{{dbuserpass}}" psql --echo-errors --host "{{db_host}}" -U "{{dbuser}}" "{{wars_to_upload_to_databases[item]['db']}}"
    {% endfor %}
    {% for warname in wars_to_upload_to_databases[item]['wars'] %}
        cat `find {{warname}}*/{{database_subfolder_in_wars}}/data -maxdepth 1  -iname *.sql | sort -h` | PGPASSWORD="{{dbuserpass}}" psql --echo-errors --host "{{db_host}}" -U "{{dbuser}}" "{{wars_to_upload_to_databases[item]['db']}}"
    {% endfor %}
{% endif %}

{% if 'files' in wars_to_upload_to_databases[item] %}
    {% for sqlfile in wars_to_upload_to_databases[item]['files'] %}
cat '{{sqlfile}}' | PGPASSWORD="{{dbuserpass}}" psql --echo-errors --host "{{db_host}}" -U "{{dbuser}}" "{{wars_to_upload_to_databases[item]['db']}}"
    {% endfor %}
{% endif %}

  
