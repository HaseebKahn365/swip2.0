#!/bin/bash

echo "=== Testing Linux Disk Monitoring Commands ==="
echo ""

echo "1. Testing lsblk command:"
echo "----------------------------"
lsblk -b -o NAME,SIZE,MOUNTPOINT,TYPE,FSTYPE --noheadings 2>/dev/null
echo ""

echo "2. Testing df command:"
echo "----------------------------"
df -B1 --output=source,size,used,avail,pcent,target 2>/dev/null | tail -n +2
echo ""

echo "3. Testing lsblk JSON output:"
echo "----------------------------"
lsblk -b -o NAME,SIZE,MOUNTPOINT,TYPE,FSTYPE -J 2>/dev/null
echo ""

echo "=== All commands executed successfully ==="
