#!/bin/sh

##################
# Pring all database useage
#
# Login information is stored in ~/.my.cnf or ~/.mylogin.cnf which permission is 600.
##################
QUERY_SQL="SELECT \
     table_schema as \`Database\`, \
     table_name AS \`Table\`, \
     round(((data_length + index_length) / 1024 / 1024), 2) \`Size in MB\` \
  FROM information_schema.TABLES \
  ORDER BY (data_length + index_length) DESC;"
echo ${QUERY_SQL}
mysql --execute="${QUERY_SQL}"

