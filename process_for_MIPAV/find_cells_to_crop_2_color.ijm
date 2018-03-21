// define constants for this process
rootd = "E:\\DATA\\" //root directory including drive name
dayf = "20170621\\R11AGFP"; //folder named according to date on which data was acquired
df = "A549_R11AGFP_ER-KDEL-1"; //folder containing actual SPIM data
//bf = df+"_back"; //folder containing background images

open(rootd+dayf+"\\"+df+"\\ARM1C0_mtiff\\"+df+"_AC0T005.tif");
run("Z Project...", "start=3 projection=[Max Intensity]");

open(rootd+dayf+"\\"+df+"\\ARM2C0_mtiff\\"+df+"_BC0T005.tif");
run("Z Project...", "start=3 projection=[Max Intensity]");

//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");

run("Record...");

