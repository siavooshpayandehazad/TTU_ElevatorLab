#!/bin/bash
echo "Content-type: text/html"
echo ""
xsload.py --fpga /var/www/upload/lift.bit --usb 1

