# execfile('parser.py')
# Change directory to OEM RUN
import os
Default = "C:\\Windows\\Setup\\Scripts\\Run"
absFilePath = os.path.abspath('__file__')
if os.path.exists(Default):
	os.chdir(Default)
else:
	os.chdir(os.path.dirname(absFilePath))
	
# Parse Variables from Text File

