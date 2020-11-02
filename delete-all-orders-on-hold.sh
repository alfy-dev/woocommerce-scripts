#!/bin/bash

# This script will delete all orders from Woocommerce that are on hold.
# It must be executed from the Wordpress root directory
# It relies on WP-CLI, see here: https://wp-cli.org/
# Download WP-CLI with curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# Rename wp-cli.phar simply "wp", make it executable and put it in the path 
# The script will rely on temp file /tmp/to_delete.txt and will log everything into /tmp/to_delete.log
# The filenames should be changed if several instances of the script are to be run on the same system at the same time.
# This script is provided for demo purposes, and it is not resilient to error. USE AT YOUR OWN RISK.
# Tested on Woocommerce 4.5.2 with Wordpress 5.5.3 and WP-CLI 2.4.0.

a=1

while [ 1 ] ; do

rm -f /tmp/to_delete.txt 2> /dev/null

wp wc shop_order list --user=1 --format=ids --status='on-hold' --allow-root | tr ' ' '\n' > /tmp/to_delete.txt

b=0

lines=$(cat /tmp/to_delete.txt | wc -l)

while [ $b -le $lines ] ; do

b=`expr $b + 1`

number=$(cat /tmp/to_delete.txt | head -n $b | tail -n 1)

echo "Deleting on iteration $a order $b (ID: $number) " >> /tmp/to_delete.log

wp --allow-root wc shop_order delete --force=1 --user=1 $number 2>> /tmp/to_delete.log >> /tmp/to_delete.log


done

if [ $b -lt 99 ] ; then
echo "All done, went through $b iterations." >> /tmp/to_delete.log
break
fi

a=`expr $a + 1`


done
