// define constants for this process
rootd = "E:\\DATA\\" //root directory including drive name
dayf = "20180228\\"; //folder named according to date on which data was acquired
df = "a549-mRuby-Atl1-1"; //folder containing actual SPIM data
//bf = df+"_back"; //folder containing background images
print("	Opening: "+rootd+dayf+"\\"+df+"\\ARM1_mtiff\\"+df+"_A025.tif");
open(rootd+dayf+"\\"+df+"\\ARM1_mtiff\\"+df+"_A005.tif");
run("Z Project...", "start=5 projection=[Max Intensity]");
run("Enhance Contrast", "saturated=0.35");
open(rootd+dayf+"\\"+df+"\\ARM2_mtiff\\"+df+"_B005.tif");
run("Z Project...", "start=5 projection=[Max Intensity]");

//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");

run("Record...");