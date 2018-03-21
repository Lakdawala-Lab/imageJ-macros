setBatchMode(true);

rootd="E:\\DATA\\" //root directory including drive name
dayf="20170621\\R11AGFP\\"; //folder named according to date on which data was acquired
day_dir_path=rootd+dayf;
list_day = getFileList(day_dir_path);

for (run_idx=0; run_idx<list_day.length; run_idx++){ //list_day.length; run_idx++){
	end_str=indexOf(list_day[run_idx],"/");
	df=substring(list_day[run_idx],0,end_str); //folder containing actual SPIM data
	//df="A549_GFP_Noco_2";
	print("Converting "+df);

	strt_n=0; //start loop at this count. Change this value only for diagnostics
	tot_n=0; //number of volumes ie. time points
	tot_frm = 0; //number of slices ie. camera frames
	dir_path1=rootd+dayf+df+"\\ARM1\\";
	dir_path2=rootd+dayf+df+"\\ARM1\\"+df+"_A000\\";
	print("Counting volumes in "+dir_path1);
	countVolumes(dir_path1);
	print("Counting slices in "+dir_path2);
	countSlices(dir_path2);

	print("Number of volumes = "+tot_n);
	print("Number of slices = "+tot_frm);
	//substring(dlist[i],0,end_str)
	dlist = getFileList(dir_path1);
	mt_dir_path=rootd+dayf+df+"\\ARM1C0_mtiff\\";
	if (File.isDirectory(mt_dir_path) == 0)
		File.makeDirectory(mt_dir_path);
	mt_dir_path=rootd+dayf+df+"\\ARM1C1_mtiff\\";
	if (File.isDirectory(mt_dir_path) == 0)
		File.makeDirectory(mt_dir_path);
	
	for(i=0;i<tot_n;i++){
		//end_str=indexOf(dlist[i],"/");
		//IJ.redirectErrorMessages();
		if(File.exists(rootd+dayf+df+"\\ARM1\\"+df+"_A"+IJ.pad(i,3)+"\\"+df+"_AT"+IJ.pad(i,3)+"C0Z00.tif")){
			run("Image Sequence...", "open=["+rootd+dayf+df+"\\ARM1\\"+df+"_A"+IJ.pad(i,3)+"\\"+df+"_AT"+IJ.pad(i,3)+"C0Z00.tif] number=19 starting=0 sort");
			//run("Properties...", "channels=1 slices="+tot_frm+" frames=1 unit=um pixel_width=0.1625 pixel_height=0.1625 voxel_depth=0.5");
			saveAs("Tiff", rootd+dayf+df+"\\ARM1C0_mtiff\\"+df+"_AC0T"+IJ.pad(i,3)+".tif");
			close();
		}
		if(File.exists(rootd+dayf+df+"\\ARM1\\"+df+"_A"+IJ.pad(i,3)+"\\"+df+"_AT"+IJ.pad(i,3)+"C0Z00.tif")){
			run("Image Sequence...", "open=["+rootd+dayf+df+"\\ARM1\\"+df+"_A"+IJ.pad(i,3)+"\\"+df+"_AT"+IJ.pad(i,3)+"C0Z00.tif] number=19 starting=20 sort");
			//run("Properties...", "channels=1 slices="+tot_frm+" frames=1 unit=um pixel_width=0.1625 pixel_height=0.1625 voxel_depth=0.5");
			saveAs("Tiff", rootd+dayf+df+"\\ARM1C1_mtiff\\"+df+"_AC1T"+IJ.pad(i,3)+".tif");
			close();
		}
	}
	
	dir_path3=rootd+dayf+df+"\\ARM2\\";
	dlist = getFileList(dir_path3);
	mt_dir_path=rootd+dayf+df+"\\ARM2C0_mtiff\\";
	if (File.isDirectory(mt_dir_path) == 0)
		File.makeDirectory(mt_dir_path);
	mt_dir_path=rootd+dayf+df+"\\ARM2C1_mtiff\\";
	if (File.isDirectory(mt_dir_path) == 0)
		File.makeDirectory(mt_dir_path);
	for(i=0;i<tot_n;i++){
		//end_str=indexOf(dlist[i],"/");
		//IJ.redirectErrorMessages();
		if(File.exists(rootd+dayf+df+"\\ARM2\\"+df+"_B"+IJ.pad(i,3)+"\\"+df+"_BT"+IJ.pad(i,3)+"C0Z00.tif")){
			run("Image Sequence...", "open=["+rootd+dayf+df+"\\ARM2\\"+df+"_B"+IJ.pad(i,3)+"\\"+df+"_BT"+IJ.pad(i,3)+"C0Z00.tif] number=19 starting=0 sort");
			//run("Properties...", "channels=1 slices="+tot_frm+" frames=1 unit=um pixel_width=0.1625 pixel_height=0.1625 voxel_depth=0.5");
			saveAs("Tiff", rootd+dayf+df+"\\ARM2C0_mtiff\\"+df+"_BC0T"+IJ.pad(i,3)+".tif");
			close();
		}
		if(File.exists(rootd+dayf+df+"\\ARM2\\"+df+"_B"+IJ.pad(i,3)+"\\"+df+"_BT"+IJ.pad(i,3)+"C0Z00.tif")){
			run("Image Sequence...", "open=["+rootd+dayf+df+"\\ARM2\\"+df+"_B"+IJ.pad(i,3)+"\\"+df+"_BT"+IJ.pad(i,3)+"C0Z00.tif] number=19 starting=20 sort");
			//run("Properties...", "channels=1 slices="+tot_frm+" frames=1 unit=um pixel_width=0.1625 pixel_height=0.1625 voxel_depth=0.5");
			saveAs("Tiff", rootd+dayf+df+"\\ARM2C1_mtiff\\"+df+"_BC1T"+IJ.pad(i,3)+".tif");
			close();
		}
	}
}
print("All done!");
function countVolumes(dir_path) {
	      dlist = getFileList(dir_path);
	      for (i=0; i<dlist.length; i++) {
	          if (startsWith(dlist[i], df))
	              tot_n++;
	      }
}
	
	
function countSlices(dir_path) {
	      flist = getFileList(dir_path);
	      for (i=0; i<flist.length; i++) {
	          if (startsWith(flist[i], df))
	              tot_frm++;
	      }
}