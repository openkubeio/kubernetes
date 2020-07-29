#! /bin/bash

w > /tmp/a

echo "Total number of unique users logged in currently"
cat /tmp/a|  sed '1,2d' | awk '{print $1}' | uniq | wc -l
echo ""

echo "List of unique users logged in currently"
cat /tmp/a | sed '1,2d'|  awk '{print $1}' | uniq
echo ""

echo "The user who is using high %cpu"
cat /tmp/a | sed '1,2d' | awk   '$7 > maxuid { maxuid=$7; maxline=$0 }; END { print maxuid, maxline }' 

echo ""
echo "List of users logged in and what they are doing"
cat /tmp/a