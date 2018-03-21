// define constants for this process
rootd = "E:\\DATA\\" //root directory including drive name
dayf = "20180307"; //folder named according to date on which data was acquired
df = "A549-R11AGFP-ATL1-mRuby-2"; //folder containing actual SPIM data
//bf = df+"_back"; //folder containing background images

open(rootd+dayf+"\\"+df+"\\ARM1_mtiff\\"+df+"_A005.tif");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=49 frames=1 display=Color");
run("Z Project...", "start=3 projection=[Max Intensity]");

open(rootd+dayf+"\\"+df+"\\ARM2_mtiff\\"+df+"_B005.tif");
run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=49 frames=1 display=Color");
run("Z Project...", "start=3 projection=[Max Intensity]");

//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");

run("Record...");

