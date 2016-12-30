This was for record behavior of the platform when leap second was inserted at 2015-06-30 23:59:60 UTC and for the leap second at 2016-12-31 23:59:60 UTC.

## Deploy
The app does not have any web user interface.

```
heroku ps:scale web=0 worker=1
```

## Check the records
Obtain recent set of records:

```
$ heroku pg:psql << _END > data.csv
COPY (
SELECT uptime,
  dyno_time_str,
  to_char(server_time, 'YYYY-MM-DD"T"HH24:MI:SS.US"Z"') as db_server_time
FROM ticks
WHERE created_at > NOW() - INTERVAL '1 HOUR' AND source LIKE '%:burst'
ORDER BY uptime
) TO STDOUT WITH CSV;
_END
```

Plot:

```
$ gnuplot
set datafile separator ","
set size ratio -1; set grid
set ydata time; set timefmt "%Y-%m-%dT%H:%M:%S"
set key top left
set ytics 1; set mytics 10; set format y "%H:%M:%S"
set xtics 1; set mxtics 10; set xrange [-0.5:4.5]
set xlabel "Relative Uptime (sec)"
set ylabel "System clock (UTC)"
x0=real(system("awk -F, '{if(NF>=3){print($1);exit}}' data.csv"))
plot "data.csv" using ($1-x0):2 tit 'Dyno',\
     "data.csv" using ($1-x0):3 tit 'DB server'
```
