setBatchMode(true);
// define constants for this process
rootd = "E:\\DATA\\"; //root directory including drive name
dayf = "20180228\\"; //folder named according to date on which data was acquired
df = "a549-mRuby-Atl1-3"; //folder containing actual SPIM data

datfold = getDirectory("Select data folder");
folderarr = split(datfold,"\\");
arrlen = lengthOf(folderarr);
df = folderarr[arrlen-1];
//df = getDirectory("Select SPIMB folder");
	
//pathOutput = getDirectory("Select output folder");

bf = df+"_bgnd"; //folder containing background images
//bf="A549_R11aGFP_RSV488_1_bgnd";
strt_n=0; //start loop at this count. Change this value only for diagnostics
tot_n=0; //number of volumes ie. time points
	
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

Dialog.create("Crop cells for diSPIM fusion");
	//input images parameters
//Dialog.addString("Root Directory",rootd,80);
//Dialog.addString("Day Directory",dayf,80);
Dialog.addString("Data folder",datfold,40);
Dialog.addString("Backdround Folder",bf,40);
Dialog.addNumber("Start number",strt_n);
Dialog.addNumber("No. of Fusions", tot_n);
Dialog.addString("SPIMA mTIFF Directory",dir_path1,80);
Dialog.addString("SPIMB mTIFF Directory",dir_path2,80);
//Dialog.addString("Color 2 ImageA Name",nameA2,20);
//Dialog.addString("Color 2 ImageB Name",nameB2,20);

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
//rootd = Dialog.getString();
//dayf = Dialog.getString();
datfold = Dialog.getString();
bf = Dialog.getString();
//pathOutput = Dialog.getString();
strt_n = Dialog.getNumber();
tot_n = Dialog.getNumber();
//dualColor = Dialog.getCheckbox();
dir_path1 = Dialog.getString();
dir_path2 = Dialog.getString();

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
run("Image Sequence...", "open=["+datfold+"\\"+bf+"\\ARM1\\"+bf+"_A000\\"+bf+"_AT000Z00.tif] sort");
//run("Image Sequence...", "open=["+rootd+dayf+"\\"+df+"\\"+bf+"\\ARM1\\"+bf+"_A000\\"+bf+"_AT000Z00.tif] sort");
run("Z Project...", "projection=[Average Intensity]");
rename("AVG_"+bf+"_A000");
selectWindow(bf+"_A000");
close();
selectWindow("AVG_"+bf+"_A000");

mt_dir_path=datfold+"\\SPIMA-C\\";
if (File.isDirectory(mt_dir_path) == 0)
	File.makeDirectory(mt_dir_path);

// subtract above background and crop image stacks for camera A
for(i=strt_n;i<tot_n;i++){
	//run("Image Sequence...", "open="+rootd+dayf+"\\"+df+"\\ARM1\\"+df+"_A"+i+"\\"+df+"_A"+IJ.pad(i,2)+"0000.tif sort");
	open(dir_path1+df+"_A"+IJ.pad(i,3)+".tif");
	imageCalculator("Subtract create stack", df+"_A"+IJ.pad(i,3)+".tif","AVG_"+bf+"_A000");
	selectWindow("Result of "+df+"_A"+IJ.pad(i,3)+".tif");
	makeRectangle(AC1,AC2,AC3,AC4);
	run("Crop");
	run("Duplicate...", "duplicate range=3-49 use");
	saveAs("Tiff", datfold+"\\SPIMA-C\\SPIMA"+IJ.pad(i,3)+".tif");
	close();
	selectWindow("Result of "+df+"_A"+IJ.pad(i,3)+".tif");
	close();
	selectWindow(df+"_A"+IJ.pad(i,3)+".tif");
	close();
}
selectWindow("AVG_"+bf+"_A000");
close();


//calculate background for camera B
run("Image Sequence...", "open=["+datfold+"\\"+bf+"\\ARM2\\"+bf+"_B000\\"+bf+"_BT000Z00.tif.tif] sort");
//run("Image Sequence...", "open=["+rootd+dayf+"\\"+df+"\\"+bf+"\\ARM2\\"+bf+"_B000\\"+bf+"_BT000Z00.tif] sort");
run("Z Project...", "projection=[Average Intensity]");
rename("AVG_"+bf+"_B000");
selectWindow(bf+"_B000");
close();
selectWindow("AVG_"+bf+"_B000");

mt_dir_path=datfold+"\\SPIMB-C\\";
if (File.isDirectory(mt_dir_path) == 0)
	File.makeDirectory(mt_dir_path);

// subtract above background and crop image stacks for camera B
for(i=strt_n;i<tot_n;i++){
	//run("Image Sequence...", "open="+rootd+dayf+"\\"+df+"\\ARM2\\"+df+"_B"+i+"\\"+df+"_B"+IJ.pad(i,2)+"0000.tif sort");
	open(dir_path2+df+"_B"+IJ.pad(i,3)+".tif");
	imageCalculator("Subtract create stack", df+"_B"+IJ.pad(i,3)+".tif","AVG_"+bf+"_B000");
	selectWindow("Result of "+df+"_B"+IJ.pad(i,3)+".tif");
	makeRectangle(BC1,BC2,BC3,BC4);
	run("Crop");
	run("Duplicate...", "duplicate range=3-49 use");
	saveAs("Tiff", datfold+"\\SPIMB-C\\SPIMB"+IJ.pad(i,3)+".tif");
	close();
	selectWindow("Result of "+df+"_B"+IJ.pad(i,3)+".tif");
	close();
	selectWindow(df+"_B"+IJ.pad(i,3)+".tif");
	close();
}
selectWindow("AVG_"+bf+"_B000");
close();
print("All done!");
