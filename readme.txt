

The attached files reproduce simulations conducted for "Active membrane conductances and morphology of a collision detection neuron broaden its impedance profile and improve discrimination of input synchrony" by Dewell and Gabbiani (2019).
It includes a detailed model of the lobula giant movement detector neuron (LGMD) which is a well studied neuron within the optic lobe of grasshoppers, and morphology files for 5 other neuron types. Attached are a number of files which setup the channel and membrane properties of the LGMD model and provide several example simulations.

Auto-launch or Compile special:
The LGMD model uses several custom .mod files for channels and currents. The auto-launch link will use these mod files to compile a special executable version of NEURON with the additional membrane mechanisms. Alternatively, the mknrndll application or nrnivmodl binary can be used to compile the special version containg all custom channels.

cd lgmd_impedance	# change path to location on your computer
nrnivmodl ./mods	# compile special executable 
x86_64/special ./mosinit.hoc -		# execute Neuron and initialize



For simulations resulting in figure 8:
load_file("LGMD/LGMDsynchro.hoc")	# run the simulations


For simulations resulting in figure 6:
load_file("PassiveMorphologies.hoc")	# run the morphology simulations

For simulations resulting in figure 7:
load_file("cable.hoc")	# run the simulations


For simulations resulting in figure S3:
load_file("RallMod.hoc")	# run the Rall model



20190808 dropbox update from Richard Dewell and additional touchups to
make fig 8 button work (from mosinit.hoc)
