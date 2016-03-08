# Change directory to OEM RUN / Live Install
import os
Default = "C:\\Windows\\Setup\\Scripts\\Run"
absFilePath = os.path.abspath('__file__')
if os.path.exists(Default): #For the OEM / ISO
	os.chdir(Default)
else:
	os.chdir(os.path.dirname(absFilePath)) # For live install
	
# Parse Variables from Text File
# Loop to EOF
