Licensed under the Ruby license.

Data Interchange Format (DIF) is an ancient format used by
spreadsheet programs that are really, really, old.

It is also one of the only export formats supported by FOCUS 7.1
that isn't fixed-width. For Google's sake, here's a list of
"ON TABLE SAVE" formats supported by FOCUS 7.1:

 * FORMAT ALPHA (fixed width)
 * FORMAT DIF (this archaic format, used by 1980's VisiCalc)
 * FORMAT EXCEL (probably 1980's Excel)
 * FORMAT HTML (docs say only for use with WebFOCUS)
 * FORMAT HTMTABLE (docs say only for use with WebFOCUS)
 * FORMAT LOTUS (the Lotus 1-2-3 format)
 * FORMAT PDF (docs say only for use with WebFOCUS)
 * FORMAT WP (for word processors, probably 1980's word processors)

As you can see from the above list, your choices for data interchange
are pretty much down to ALPHA (but you have to always know how big
every column is), ancient DIF, ancient Excel, and ancient Lotus 1-2-3.
DIF is plaintext, so easier to digest. Maybe some really crazy
person can make a DIF XSLT.

This is a port of a Python DIF parser: <http://newcenturycomputers.net/projects/dif.html>