#!/bin/sh

##################
# Pring all database useage
#
# Login information is stored in ~/.my.cnf or ~/.mylogin.cnf which permission is 600.
##################
mysql --execute="select table_schema, count(1) as tables, concat(round(sum(table_rows)/1000000,2),'M') as rows, concat(round(sum(data_length)/(1024*1024*1024),2),'G') as data, concat(round(sum(index_length)/(1024*1024*1024),2),'G') as idx, concat(round(sum(data_length+index_length)/(1024*1024*1024),2),'G') as total_size,round(sum(index_length)/sum(data_length),2) as idxfrac from information_schema.tables group by table_schema order by table_schema, total_size desc;"
