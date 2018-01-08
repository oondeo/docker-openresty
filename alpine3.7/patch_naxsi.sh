#!/bin/bash
raw_string=$1
quoted_string=${raw_string//\\//\\\\}
for c in \[ \] \( \) \. \^ \$ \? \* \+ \/; do
  quoted_string=${quoted_string//"$c"/"\\$c"}
done

sed -i "s/my \$cmd \= \"sh .\/configure/my \$cmd \= \"sh .\/configure ${quoted_string}/" configure 
