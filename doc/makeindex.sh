#!/bin/sh

start=components.md
n=1

while true; do

    title=`sed -n -e '1{ s/^## \(.*\) ##$/\1/p}' $start`
    next=`sed -n -e 's/^\[next\](\(.*\))$/\1/p' $start`
    echo "$n. [$title]($start)"
    if [ -z "$next" ]; then
	break
    fi
    
    start=$next
    n=$(($n+1))

done > README.md
