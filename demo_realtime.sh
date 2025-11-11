#!/bin/bash

echo "🚀 Real-Time Disk Monitor Demo"
echo "================================"
echo ""
echo "Make sure the Flutter app is running!"
echo "Watch the app update automatically as we create/delete files."
echo ""
read -p "Press Enter to start the demo..."

echo ""
echo "📝 Test 1: Creating a 500MB file..."
echo "Watch the app - it will update automatically within 1 second!"
dd if=/dev/zero of=/tmp/demo_test_500mb bs=1M count=500 2>/dev/null
echo "✅ File created. Did the app update automatically? (Check the usage bar)"
sleep 3

echo ""
echo "📝 Test 2: Creating another 500MB file..."
dd if=/dev/zero of=/tmp/demo_test_500mb_2 bs=1M count=500 2>/dev/null
echo "✅ File created. Usage should have increased again!"
sleep 3

echo ""
echo "📝 Test 3: Deleting the first file..."
rm /tmp/demo_test_500mb
echo "✅ File deleted. Usage should have decreased!"
sleep 3

echo ""
echo "📝 Test 4: Deleting the second file..."
rm /tmp/demo_test_500mb_2
echo "✅ File deleted. Usage should be back to original!"
sleep 2

echo ""
echo "🎉 Demo complete!"
echo ""
echo "Key observations:"
echo "  ✅ No refresh button was pressed"
echo "  ✅ Updates happened automatically"
echo "  ✅ Changes appeared within 500ms-1s"
echo "  ✅ UI remained smooth throughout"
echo ""
echo "Try plugging/unplugging a USB drive to see hotplug detection!"
