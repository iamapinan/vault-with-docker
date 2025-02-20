{{ with secret "kv/mysql" }}
MYSQL_USER={{ .Data.data.MYSQL_USER }}
MYSQL_PASSWORD={{ .Data.data.MYSQL_PASSWORD }}
MYSQL_ROOT_PASSWORD={{ .Data.data.MYSQL_ROOT_PASSWORD }}
MYSQL_DATABASE={{ .Data.data.MYSQL_DATABASE }}
{{ end }}