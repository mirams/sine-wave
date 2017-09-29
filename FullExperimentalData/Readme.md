# Experimental Data

All the data (both raw and processed data used in this study) can be found on [Figshare](http://www.figshare.com) at https://doi.org/10.6084/m9.figshare.4702546.v1.
The raw `.abf` files can be found in the `abf` folder for each cell. 
(For an index as to which experiment set corresponds to which cell number in the paper see the index list in [ExperimentalData/cell_index.txt](../ExperimentalData/cell_index.txt)). 
The individual cell files each contain both plain text format data for each protocol as well as the leak subtracted and both leak and dofetilide subtracted traces. 
We provide all the data for both the repeat of each protocol in control vehicle conditions and in the presence of dofetilide (as indicated by the inclusion of dofetilide after the protocol name for these files).

The [ManualLeakSubtraction.m](ManualLeakSubtraction.m) file is used to estimate the leak resistance values for each data set (one resistance value for the vehicle repeats and one resistance value for the dofetilide repeat for each cell is identified during the sine wave protocol leak step, and used for the leak correction of the other protocols performed in the same conditions for that cell). 
In this file the leak resistance values identified for each cell are detailed. 
After leak subtracting both the control vehicle and dofetilide repeats of each protocol, we then subtract them to determine the leak subtracted and dofetilide subtracted data traces.

Note that different activation kinetics protocols to the ones described in the manuscript were used for cells 7 and 8. 
In this alternative protocol, after the leak step, the duration of the Tstep at 0 mV started at 20 ms and increased by 60 ms on succesive sweeps (with a total of 9 sweeps). 
This step was followed by a step to -120 mV for 1.5 seconds before returning to holding potential of -80mV for 1 second.
(data not used in main manuscript).


