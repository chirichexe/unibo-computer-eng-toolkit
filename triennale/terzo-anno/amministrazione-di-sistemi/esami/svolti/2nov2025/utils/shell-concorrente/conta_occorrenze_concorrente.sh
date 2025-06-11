#!/bin/bash

SIZE=$(cat The_Adventures_Of_Sherlock_Holmes.txt | wc -l)

DIMENSION=$(( $SIZE / 2 ))

tail The_Adventures_Of_Sherlock_Holmes.txt -n $DIMENSION | grep -ioE sherlock | wc -w &

head The_Adventures_Of_Sherlock_Holmes.txt -n $DIMENSION | grep -ioE sherlock | wc -w &
