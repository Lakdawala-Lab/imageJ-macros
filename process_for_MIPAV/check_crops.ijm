// define constants for this process
rootd = "E:\\DATA\\" //root directory including drive name
dayf = "20160721"; //folder named according to date on which data was acquired
df = "MDCK_CA0709eGFP2"; //folder containing actual SPIM data
bf = df+"_bgnd"; //folder containing background images

open(rootd+dayf+"\\"+df+"\\SPIMA-C\\SPIMA000.tif");
//run("Z Project...", "projection=[Max Intensity]");

open(rootd+dayf+"\\"+df+"\\SPIMB-C\\SPIMB000.tif");
//run("Z Project...", "projection=[Max Intensity]");

run("Tile");
selectWindow("SPIMA000.tif");
selectWindow("SPIMB000.tif");
