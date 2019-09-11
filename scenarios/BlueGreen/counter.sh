#!/bin/bash 
# Count the Blue Green Ratio
COUNT=0
TESTS=100
BLUE=0
GREEN=0
HOST="bigip"
echo "###########################################"
echo "###                                     ###"
echo "### Quick Blue/Green Deployment Counter ###"
echo "###                                     ###"
echo "###########################################"
echo "###                                     ###"
echo "### Running $TESTS tests against $HOST     ###"
echo "###                                     ###"
echo "###########################################"
echo "###                                     ###"
while [ $COUNT -lt $TESTS ]; do
   FOUND=`curl -s $HOST | grep -c "Blue"` 	 
   #echo $FOUND
   let BLUE=$BLUE+$FOUND
   #echo $BLUE
   let COUNT=COUNT+1
done  
let BLUE=BLUE/2
let GREEN=TESTS-BLUE
echo "###   Blue Server Hit $BLUE times          ###"
echo "###                                     ###"
echo "###   Green Server Hit $GREEN times         ###"
echo "###                                     ###"
echo "###########################################"
