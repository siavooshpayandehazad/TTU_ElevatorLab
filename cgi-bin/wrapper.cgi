#!/bin/bash
echo "Content-type: text/html"
echo ""
xsload.py --fpga /var/www/wrapper/wrapper.bit --usb 0

