#!/bin/sh

source /u/local/Modules/default/init/modules.sh
module load python/3.6.1

echo "Task id is $SGE_TASK_ID"

python3 PostProcessing.py $SGE_TASK_ID