#!/bin/sh

source /u/local/Modules/default/init/modules.sh
module load opensees/2.5.0_MP

echo "Task id is $SGE_TASK_ID"

OpenSeesMP   RunIDAHoffmanXx.tcl   $SGE_TASK_ID
