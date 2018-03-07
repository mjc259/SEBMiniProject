#!/bin/sh

#  Fixation_Time.sh
#  
#
#  Created by Rachel Newhouse on 05/03/2018.
#  
cd ~/Desktop/Course_Materials/Mini_Project

GENERATION_TIME=3935
STEP_BASE=0.1
STEPPING=$STEP_BASE/$GENERATION_TIME
echo "$STEPPING"
for j in 0.2 0.4 0.6 0.8 1.0 1.2 1.4 1.6 1.8 2
do
POP_SIZE_SCALE_FACTOR=$j
GENERATIONS=200
for i in 1 2 3 4 5
do
SIMNUM=$i

Rscript Random_Starting_Positions.R $POP_SIZE_SCALE_FACTOR $SIMNUM

smoldyn SmoldynLavaOneCompartmentPopulationSizeRandomStartingPositions.txt  --define Generation_Time="$GENERATION_TIME" --define Ending="$GENERATIONS" --define Stepping="$STEPPING" --define SIMNUM=$i --define R2s22=0 --define POP_SIZE_SCALE_FACTOR=$POP_SIZE_SCALE_FACTOR
done
done
