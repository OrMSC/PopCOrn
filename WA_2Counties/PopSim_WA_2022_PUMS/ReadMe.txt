Kaelem Mohabir
11-28-2023

Popsim install instructions 

1. Go to this location: https://github.com/tlumip/tlumip/wiki/Installation
2. Follow steps 2 and 3 under installation instructions. Download and unzip folder.
3. Once unzipped, navigate to tlumip_dependencies-master folder and copy "swimpy" folder. 
4. Paste "swimpy" folder on machine and rename "popsim". Initial zipped and unzipped folders from steps 2 and 3 can be deleted. 
5. Ensure that location on line 9 of RunPopulationSim.bat script points to the location of python.exe in the newly named "popsim" folder.

Instructions to run PopSim
 
1. Ensure that location on line 9 of "RunPopulationSim.bat" script points to the location of "python.exe" in the newly named "popsim" folder.
2. Run "RunPopulationSim.bat" in a PowerShell window. Open a PowerShell window by holding down shift and right clicking int he whitespace in this folder. Select the prompt "Open PowerShell window here". Drag "RunPopulationSim.bat" into the blue PowerShell window and hit enter to start. You should see output text very soon after the run begins. The run time will depend on the size of the population. For group quarters, runs take 2-5 minutes. For the full state general population runs take between 5 - 7 hours.
3. In order to run the validation script the file "GP_columnMapPopSim.CSV" in the data folder must be aligned with the current controls used for the run. Open the R shortcut and run "2g_GP_validationPopulationSim.r". The plots folder should populate with validation plots.

