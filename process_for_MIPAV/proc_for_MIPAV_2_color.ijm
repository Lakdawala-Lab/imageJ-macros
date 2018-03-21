// define constants for this process
rootd = "E:\\DATA\\" //root directory including drive name
dayf = "20170613"; //folder named according to date on which data was acquired
df = "A549_R11AGFP_ERRed_1"; //folder containing actual SPIM data
bf = df+"_bgnd"; //folder containing background images
//bf="A549_GFP_test_align1_bgnd";
strt_n=0; //start loop at this count. Change this value only for diagnostics
tot_n=0; //number of volumes ie. time points
	
dir_path1=rootd+dayf+"\\"+df+"\\ARM1C0_mtiff\\";
print("Counting volumes in: "+dir_path1);
countVolumes(dir_path1);
function countVolumes(dir_path) {
	      dlist = getFileList(dir_path);
	      for (i=0; i<dlist.length; i++) {
	          if (startsWith(dlist[i], df))
	              tot_n++;
	      }
}
print("Total volumes: "+tot_n);

//calculate background for camera A
run("Image Sequence...", "open=["+rootd+dayf+"\\"+df+"\\"+bf+"\\ARM1\\"+bf+"_A000\\"+bf+"_AT000C0Z00.tif] sort");
run("Z Project...", "projection=[Average Intensity]");
selectWindow(bf+"_A000");
close();
selectWindow("AVG_"+bf+"_A000");

mt_dir_path=rootd+dayf+"\\"+df+"\\SPIMAC0-C\\";
if (File.isDirectory(mt_dir_path) == 0)
	File.makeDirectory(mt_dir_path);
mt_dir_path=rootd+dayf+"\\"+df+"\\SPIMAC1-C\\";
if (File.isDirectory(mt_dir_path) == 0)
	File.makeDirectory(mt_dir_path);

// subtract above background and crop image stacks for camera A
for(i=strt_n;i<tot_n;i++){
	//run("Image Sequence...", "open="+rootd+dayf+"\\"+df+"\\ARM1\\"+df+"_A"+i+"\\"+df+"_A"+IJ.pad(i,2)+"0000.tif sort");
	open(rootd+dayf+"\\"+df+"\\ARM1C0_mtiff\\"+df+"_AC0T"+IJ.pad(i,3)+".tif");
	imageCalculator("Subtract create stack", df+"_AC0T"+IJ.pad(i,3)+".tif","AVG_"+bf+"_A000");
	selectWindow("Result of "+df+"_AC0T"+IJ.pad(i,3)+".tif");
	makeRectangle(176,102,170,300);
	run("Crop");
	saveAs("Tiff", rootd+dayf+"\\"+df+"\\SPIMAC0-C\\SPIMA"+IJ.pad(i,3)+".tif");
	close();
	selectWindow(df+"_AC0T"+IJ.pad(i,3)+".tif");
	close();
}
for(i=strt_n;i<tot_n;i++){
	//run("Image Sequence...", "open="+rootd+dayf+"\\"+df+"\\ARM1\\"+df+"_A"+i+"\\"+df+"_A"+IJ.pad(i,2)+"0000.tif sort");
	open(rootd+dayf+"\\"+df+"\\ARM1C1_mtiff\\"+df+"_AC1T"+IJ.pad(i,3)+".tif");
	imageCalculator("Subtract create stack", df+"_AC1T"+IJ.pad(i,3)+".tif","AVG_"+bf+"_A000");
	selectWindow("Result of "+df+"_AC1T"+IJ.pad(i,3)+".tif");
	makeRectangle(176,102,170,300);
	run("Crop");
	saveAs("Tiff", rootd+dayf+"\\"+df+"\\SPIMAC1-C\\SPIMA"+IJ.pad(i,3)+".tif");
	close();
	selectWindow(df+"_AC1T"+IJ.pad(i,3)+".tif");
	close();
}
selectWindow("AVG_"+bf+"_A000");
close();


//calculate background for camera B
run("Image Sequence...", "open=["+rootd+dayf+"\\"+df+"\\"+bf+"\\ARM2\\"+bf+"_B000\\"+bf+"_BT000Z00.tif] sort");
run("Z Project...", "projection=[Average Intensity]");
selectWindow(bf+"_B000");
close();
selectWindow("AVG_"+bf+"_B000");

mt_dir_path=rootd+dayf+"\\"+df+"\\SPIMBC0-C\\";
if (File.isDirectory(mt_dir_path) == 0)
	File.makeDirectory(mt_dir_path);
mt_dir_path=rootd+dayf+"\\"+df+"\\SPIMBC1-C\\";
if (File.isDirectory(mt_dir_path) == 0)
	File.makeDirectory(mt_dir_path);

// subtract above background and crop image stacks for camera B
for(i=strt_n;i<tot_n;i++){
	//run("Image Sequence...", "open="+rootd+dayf+"\\"+df+"\\ARM2\\"+df+"_B"+i+"\\"+df+"_B"+IJ.pad(i,2)+"0000.tif sort");
	open(rootd+dayf+"\\"+df+"\\ARM2C0_mtiff\\"+df+"_BC0T"+IJ.pad(i,3)+".tif");
	imageCalculator("Subtract create stack", df+"_BC0T"+IJ.pad(i,3)+".tif","AVG_"+bf+"_B000");
	selectWindow("Result of "+df+"_BC0T"+IJ.pad(i,3)+".tif");
	makeRectangle(180,110,170,300);
	run("Crop");
	saveAs("Tiff", rootd+dayf+"\\"+df+"\\SPIMBC0-C\\SPIMB"+IJ.pad(i,3)+".tif");
	close();
	selectWindow(df+"_BC0T"+IJ.pad(i,3)+".tif");
	close();
}
for(i=strt_n;i<tot_n;i++){
	//run("Image Sequence...", "open="+rootd+dayf+"\\"+df+"\\ARM2\\"+df+"_B"+i+"\\"+df+"_B"+IJ.pad(i,2)+"0000.tif sort");
	open(rootd+dayf+"\\"+df+"\\ARM2C1_mtiff\\"+df+"_BC1T"+IJ.pad(i,3)+".tif");
	imageCalculator("Subtract create stack", df+"_BC1T"+IJ.pad(i,3)+".tif","AVG_"+bf+"_B000");
	selectWindow("Result of "+df+"_BC1T"+IJ.pad(i,3)+".tif");
	makeRectangle(180,110,170,300);
	run("Crop");
	saveAs("Tiff", rootd+dayf+"\\"+df+"\\SPIMBC1-C\\SPIMB"+IJ.pad(i,3)+".tif");
	close();
	selectWindow(df+"_BC1T"+IJ.pad(i,3)+".tif");
	close();
}
selectWindow("AVG_"+bf+"_B000");
close();
print("All done!");
