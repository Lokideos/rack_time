===============================
VERSION = 1.1.0
===============================

This is a test rack application, which will show you time based on information in your GET HTTP query.

This application will show you the current time according to QUERY STRING you will send to the server.
The path of the request should be in the following form: "/time" and query string should look like this:
"?format=year%2Cday%2Cmonth".
Note that after equality symbol you can provide time format in any order suitable for you.

However, the application will only accept following date formats:
1) year;
2) month;
3) day;
4) hour;
5) minute;
6) second.