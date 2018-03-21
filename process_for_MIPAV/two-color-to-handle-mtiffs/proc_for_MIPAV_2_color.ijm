setBatchMode(true);
// define constants for this process
rootd = "E:\\DATA\\" //root directory including drive name
dayf = "20180307"; //folder named according to date on which data was acquired
df = "A549-R11AGFP-ATL1-mRuby-1"; //folder containing actual SPIM data

datfold = getDirectory("Select data folder");
folderarr = split(datfold,"\\");
arrlen = lengthOf(folderarr);
df = folderarr[arrlen-1];

bf = df+"_bgnd"; //folder containing background images
//bf="A549_GFP_test_align1_bgnd";
strt_n=0; //start loop at this count. Change this value only for diagnostics
tot_n=0; //number of volumes ie. time points
	
//dir_path1=rootd+dayf+"\\"+df+"\\ARM1_mtiff\\";
dir_path1=datfold+"\\ARM1_mtiff\\";
dir_path2=datfold+"\\ARM2_mtiff\\";
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
AC1 = 0;
AC2 = 0;
AC3 = 0;
AC4 = 0;
BC1 = 0;
BC2 = 0;
BC3 = 0;
BC4 = 0;

//GUI dialog for selecting folders and crop limits
Dialog.create("Crop cells for 2-color diSPIM fusion");
Dialog.addString("Data folder",datfold,40);
Dialog.addString("Backdround Folder",bf,40);
Dialog.addNumber("Start number",strt_n);
Dialog.addNumber("No. of Fusions", tot_n);
Dialog.addString("SPIMA mTIFF Directory",dir_path1,80);
Dialog.addString("SPIMB mTIFF Directory",dir_path2,80);
Dialog.addNumber("SPIM A crop indices", AC1);
Dialog.setInsets(-30, 70, 0);
Dialog.addNumber("", AC2);
Dialog.setInsets(-30, 140, 0);
Dialog.addNumber("", AC3);
Dialog.setInsets(-30, 210, 0);
Dialog.addNumber("", AC4);

Dialog.addNumber("SPIM B crop indices", BC1);
Dialog.setInsets(-30, 70, 0);
Dialog.addNumber("", BC2);
Dialog.setInsets(-30, 140, 0);
Dialog.addNumber("", BC3);
Dialog.setInsets(-30, 210, 0);
Dialog.addNumber("", BC4);
Dialog.show();

//Get parameters from dialog

datfold = Dialog.getString();
bf = Dialog.getString(); //background
strt_n = Dialog.getNumber(); //start number
tot_n = Dialog.getNumber(); //end number
dir_path1 = Dialog.getString();
dir_path2 = Dialog.getString();

//crop limits
AC1 = Dialog.getNumber();
AC2 = Dialog.getNumber();
AC3 = Dialog.getNumber();
AC4 = Dialog.getNumber();
BC1 = Dialog.getNumber();
BC2 = Dialog.getNumber();
BC3 = Dialog.getNumber();
BC4 = Dialog.getNumber();

print("No A:"+AC1+" ,"+AC2+" ,"+AC3+" ,"+AC4);
print("No B:"+BC1+" ,"+BC2+" ,"+BC3+" ,"+BC4);

//calculate background for camera A
print("Calculating Camera A background from "+datfold);
run("Image Sequence...", "open=["+datfold+"\\"+bf+"\\ARM1\\"+bf+"_A000\\"+bf+"_AT000Z00.tif] sort");
run("Z Project...", "projection=[Average Intensity]");
selectWindow(bf+"_A000");
close();
selectWindow("AVG_"+bf+"_A000");

mt_dir_path=datfold+"\\SPIMAC0-C\\";
if (File.isDirectory(mt_dir_path) == 0)
	File.makeDirectory(mt_dir_path);
mt_dir_path=datfold+"\\SPIMAC1-C\\";
if (File.isDirectory(mt_dir_path) == 0)
	File.makeDirectory(mt_dir_path);

// subtract above background and crop image stacks for camera A
print("CamA: subtracting background and cropping to specified limits");
for(i=strt_n;i<tot_n;i++){
	//run("Image Sequence...", "open="+rootd+dayf+"\\"+df+"\\ARM1\\"+df+"_A"+i+"\\"+df+"_A"+IJ.pad(i,2)+"0000.tif sort");
	open(datfold+"\\ARM1_mtiff\\"+df+"_A"+IJ.pad(i,3)+".tif");
	run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=49 frames=1 display=Grayscale");
	imageCalculator("Subtract create stack", df+"_A"+IJ.pad(i,3)+".tif","AVG_"+bf+"_A000");
	selectWindow("Result of "+df+"_A"+IJ.pad(i,3)+".tif");
	makeRectangle(AC1,AC2,AC3,AC4);
	run("Crop");
	run("Duplicate...", "duplicate slices=3-49");
	run("Split Channels");
	selectWindow("C1-Result of "+df+"_A"+IJ.pad(i,3)+"-1.tif");
	saveAs("Tiff", datfold+"\\SPIMAC0-C\\SPIMA"+IJ.pad(i,3)+".tif");
	close();
	selectWindow("C2-Result of "+df+"_A"+IJ.pad(i,3)+"-1.tif");
	saveAs("Tiff", datfold+"\\SPIMAC1-C\\SPIMA"+IJ.pad(i,3)+".tif");
	close();
	selectWindow("Result of "+df+"_A"+IJ.pad(i,3)+".tif");
	close();
	selectWindow(df+"_A"+IJ.pad(i,3)+".tif");
	close();
}
/*
for(i=strt_n;i<tot_n;i++){
	//run("Image Sequence...", "open="+rootd+dayf+"\\"+df+"\\ARM1\\"+df+"_A"+i+"\\"+df+"_A"+IJ.pad(i,2)+"0000.tif sort");
	open(rootd+dayf+"\\"+df+"\\ARM1_mtiff\\"+df+"_A"+IJ.pad(i,3)+".tif");
	//open(rootd+dayf+"\\"+df+"\\ARM1C1_mtiff\\"+df+"_AC1T"+IJ.pad(i,3)+".tif");
	imageCalculator("Subtract create stack", df+"_AC1T"+IJ.pad(i,3)+".tif","AVG_"+bf+"_A000");
	selectWindow("Result of "+df+"_AC1T"+IJ.pad(i,3)+".tif");
	makeRectangle(176,102,170,300);
	run("Crop");
	saveAs("Tiff", rootd+dayf+"\\"+df+"\\SPIMAC1-C\\SPIMA"+IJ.pad(i,3)+".tif");
	close();
	selectWindow(df+"_AC1T"+IJ.pad(i,3)+".tif");
	close();
}*/
selectWindow("AVG_"+bf+"_A000");
close();


//calculate background for camera B
print("Calculating Camera B background from "+datfold);
run("Image Sequence...", "open=["+datfold+"\\"+bf+"\\ARM2\\"+bf+"_B000\\"+bf+"_BT000Z00.tif] sort");
run("Z Project...", "projection=[Average Intensity]");
selectWindow(bf+"_B000");
close();
selectWindow("AVG_"+bf+"_B000");

mt_dir_path=datfold+"\\SPIMBC0-C\\";
if (File.isDirectory(mt_dir_path) == 0)
	File.makeDirectory(mt_dir_path);
mt_dir_path=datfold+"\\SPIMBC1-C\\";
if (File.isDirectory(mt_dir_path) == 0)
	File.makeDirectory(mt_dir_path);

// subtract above background and crop image stacks for camera B
print("CamB: subtracting background and cropping to specified limits");
for(i=strt_n;i<tot_n;i++){
	//run("Image Sequence...", "open="+rootd+dayf+"\\"+df+"\\ARM1\\"+df+"_A"+i+"\\"+df+"_A"+IJ.pad(i,2)+"0000.tif sort");
	open(datfold+"\\ARM2_mtiff\\"+df+"_B"+IJ.pad(i,3)+".tif");
	run("Stack to Hyperstack...", "order=xyczt(default) channels=2 slices=49 frames=1 display=Grayscale");
	imageCalculator("Subtract create stack", df+"_B"+IJ.pad(i,3)+".tif","AVG_"+bf+"_B000");
	selectWindow("Result of "+df+"_B"+IJ.pad(i,3)+".tif");
	makeRectangle(BC1,BC2,BC3,BC4);
	run("Crop");
	run("Duplicate...", "duplicate slices=3-49");
	run("Split Channels");
	selectWindow("C1-Result of "+df+"_B"+IJ.pad(i,3)+"-1.tif");
	saveAs("Tiff", datfold+"\\SPIMBC0-C\\SPIMB"+IJ.pad(i,3)+".tif");
	close();
	selectWindow("C2-Result of "+df+"_B"+IJ.pad(i,3)+"-1.tif");
	saveAs("Tiff", datfold+"\\SPIMBC1-C\\SPIMB"+IJ.pad(i,3)+".tif");
	close();
	selectWindow("Result of "+df+"_B"+IJ.pad(i,3)+".tif");
	close();
	selectWindow(df+"_B"+IJ.pad(i,3)+".tif");
	close();
}
/*
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
}*/
selectWindow("AVG_"+bf+"_B000");
close();
print("All done!");

