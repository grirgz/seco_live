///// draft
BufDef('loop/lovin.flac').play
BufDef('loop/lovin.flac').numFrames
e = SCMIRAudioFile("~/Musique/sc/samplekit/loop/lovin.flac".standardizePath, [[MFCC, 13], [Chromagram, 12]]);

{e.extractFeatures()}.fork //wrapped in fork gives posted feedback as it goes; won't block main thread

(
    d = e.similarityMatrix(10, 2);     
    n = e.novelty(d,30); 
    n.normalize.plot; //plot it
)

l = e.findSections(); //wait for me to finish

l = e.findSections(0,10,2);

SCMIRSimilarityMatrix


    m = e.similarityMatrix(unit:10, metric:2);     
	m.plot(4)
	m.rows
	m.reducedrows
	m.sequence1.size
	e.size
	m.reducedcolumns

	m.matrix[10*m.reducedrows+6]
	m.matrix[10*m.reducedrows+(10..m.reducedcolumns-1)].minIndex
	m.matrix[10*m.reducedrows+(0..m.reducedcolumns-1)].order
	m.matrix[21*m.reducedrows+(0..m.reducedcolumns-1)].order
	m.matrix[10*m.reducedrows+(1..m.reducedcolumns-3)]


l = e.findSections(metric:2,unit:10,kernelsize:6);


///// draft 2
~t = 185/4/60; TempoClock.default.tempo = ~t;

e = SCMIRAudioFile("~/Musique/sc/samplekit/loop/lovin.flac".standardizePath, [[MFCC, 13], [Chromagram, 12]]);
{e.extractFeatures()}.fork //wrapped in fork gives posted feedback as it goes; won't block main thread
m = e.similarityMatrix(unit:1, metric:0);     
m.reducedrows


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			// take sample at column 105 and play other columns by order of similarity
			\pos, Pser(m.matrix[915*m.reducedrows+(0..m.reducedcolumns-1)].order,10).loop * BufDef('loop/lovin.flac').duration/m.reducedrows, //pos is position in the sample in seconds
			\sustain, BufDef('loop/lovin.flac').duration/m.reducedrows,
			\dur, BufDef('loop/lovin.flac').duration/m.reducedrows / ~t,
			\gain, 1,
		).trace
		
	])
)).play;
);



///////////////////////////////////////////////////
///////////////////// find similarity

e = SCMIRAudioFile("~/Musique/sc/samplekit/loop/lovin.flac".standardizePath, [[MFCC, 13], [Chromagram, 12]]);
{e.extractFeatures()}.fork //wrapped in fork gives posted feedback as it goes; won't block main thread
m = e.similarityMatrix(unit:10, metric:2);     


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/lovin.flac'),
			// take sample at column 105 and play other columns by order of similarity
			\pos, Pseq(m.matrix[105*m.reducedrows+(0..m.reducedcolumns-1)].order) * BufDef('loop/lovin.flac').duration/m.reducedrows, //pos is position in the sample in seconds
			\sustain, BufDef('loop/lovin.flac').duration/m.reducedrows,
			\dur, 1,
			\gain, 1,
		).trace
		
	])
)).play;
);

//////// sharable example

~file = "~/Musique/sc/samplekit/loop/lovin.flac".standardizePath;

e = SCMIRAudioFile(~file, [[MFCC, 13], [Chromagram, 12]]); // open file for SCMIR
b = Buffer.read(Server.default, ~file); // buffer for the Pbind
{e.extractFeatures()}.fork; // extract features before creating similarityMatrix
m = e.similarityMatrix(unit:10, metric:2); // create similarityMatrix    

(
// simple buffer player
SynthDef(\playersec, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
);

(
Pdef(\sortsample,
	Pbind(
		\instrument, \playersec,
		\bufnum, b,
		// take sample at column 105 and play other columns by order of similarity
		// pos is position in the sample in seconds
		// column 105 start at 105*m.reducedrows+0 and ends at 105*m.reducedrows+m.reducedcolumns
		// we take this slice of array, sort it and return the indexes (.order)
		// then scale column number to position in second
		\pos, Pseq(m.matrix[105*m.reducedrows+(0..m.reducedcolumns-1)].order) * b.duration/m.reducedrows, 
		\sustain, b.duration/m.reducedrows,
		\dur, 1,
		\gain, 1,
	)
).play;
);


///////////////////////////////// /////////////////////////////////
///////////////////////////////// /////////////////////////////////
///////////////////////////////// /////////////////////////////////
///////////////////////////////// /////////////////////////////////
//
// doc code




e = SCMIRAudioFile(Platform.resourceDir +/+ "sounds/a11wlk01.wav", [[MFCC, 13], [Chromagram, 12]]);

//shortcut versions also work, defaults will be applied for MFCC (10 coeffs) and Chromagram (12TET)
//e = SCMIRAudioFile(Platform.resourceDir +/+"sounds/a11wlk01.wav",[MFCC,Chromagram]);

e.extractFeatures()

{e.extractFeatures()}.fork //wrapped in fork gives posted feedback as it goes; won't block main thread

e.save("/Users/nickcollins/Desktop/a11wlk01.scmirZ")    //save .scmirZ files using ZArchive; binary storage of feature data and other instance variables

e.load("/Users/nickcollins/Desktop/a11wlk01.scmirZ")
//if no filenames are provided, will be placed in temp directory

e.featuredata

e.numfeatures

e.numframes

e.plotFeatures(300,300,40); //will resample feature data to fit dimensions requested

e.plotFeatures(400,600,40, true); //line based plot

//caution: if featuredata size is large, working out a similarityMatrix gets heavier (which is why an external program is being invoked for the heavy lifting). 
//you can downsample to reduce computation time using the first argument, units, to this method, which aggregates frames into larger blocks in bunches of unit frames
m = e.similarityMatrix();  //m is an SCMIRSimilarityMatrix object

m.plot(4)
m.columns
m.dtw
m.plot(100)

//shortcut
e.plotSelfSimilarity(1,4); //unit = 1, stretch = 4, params as above 


//if already saved .scmirZ file, create directly from it. 
e = SCMIRAudioFile.newFromZ("/Users/nickcollins/Desktop/a11wlk01.scmirZ") //Z archive will have stored original location of audio file; if moved in meantime, may need to update instance variable data, or just start anew



//a bigger file (substitute your own)
f = SCMIRAudioFile("/data/audio/mirdata/pixiesivebeentired.wav", [[MFCC, 13], [Chromagram, 12]]);

f.extractFeatures(); //wait for me to finish

f.plotFeatures(800,600,100); 

f.plotFeatures(1000,800,100,true); 



//faster calculation of similiarity matrix via external command line app; can specify different metrics
//Euclidean
b = f.similarityMatrix(100, 2);
b.plot(5,6);

//Manhattan
c = f.similarityMatrix(100, 1);
c.plot(5,6);

//Cosine
d = f.similarityMatrix(100, 0);
d.plot(5,20); //boosted contrast


//find novelty curve
(
    d = e.similarityMatrix(10, 2);     
    n = e.novelty(d,30); 
    n.normalize.plot; //plot it
)



//find novelty curve and peak pick to extract sections
l = f.findSections(); //wait for me to finish

l //l is a list of section boundaries 



//predominant f0, hasFreq, and 4 chroma (activity in minor third regions of the octave)
f = SCMIRAudioFile("/data/audio/mirdata/pixiesivebeentired.wav", [[Tartini],[Chromagram, 4]]);

f.extractFeatures(); //wait for me to finish

f.plotFeatures(800,600,100,true); 

a = f.similarityMatrix(100); //100 features per similarity unit

//file is about 180 seconds long; eventual plot will be around 180*4 pixels to a side 
a.plot(4); 



e = SCMIRAudioFile(Platform.resourceDir +/+ "sounds/a11wlk01.wav", [Loudness]);

e.extractFeatures(); //wait for me to finish

e.plotFeatureTrail    //plot first feature by default; only one, so plots that

//pretty image
e.plotSelfSimilarity(1,3,1); //one pixel is one similarity unit, can be stretched using second argument for smaller matrices

        

//data provided:
e.duration
e.numframes
e.featuredata
e.numfeatures
e.numChannels
e.featureinfo
e.basename
e.analysispath
e.sourcepath
MFCC




//test more features:

e = SCMIRAudioFile(Platform.resourceDir +/+ "sounds/a11wlk01.wav", [[Loudness],[SpecCentroid],[SpecPcile, 0.95],[SpecPcile, 0.8],[SpecFlatness],[FFTCrest],[FFTCrest, 0, 2000], [FFTCrest, 2000, 10000],[FFTSpread],[FFTSlope],[SensoryDissonance]]);

e.extractFeatures(); //wait for me to finish

e.plotFeatureTrail(0,0.0,2.0) //Loudness over two seconds
e.plotFeatureTrail(4,1.0,3.0) //SpecFlatness over two seconds starting at time 1.0


//export ARFF file (for use with Weka Java-based machine learning software)
//defaults to features.arff filename in the SC application directory
e.exportARFF



e.plotSelfSimilarity(1,3); //one pixel is one similarity unit, can be stretched using second argument for smaller matrices



//test beat extraction: 

f = SCMIRAudioFile("/data/audio/mirdata/pixiesivebeentired.wav", [[MFCC, 13], [Chromagram, 12]]);

f.extractBeats(); //wait for me to finish

a = f.beatdata; //beat locations

b = f.tempi; //tempo curve
b.plot
f.tempo; //estimate of global tempo as median

//Experimental: via auxilliary program: BeatRoot from Simon Dixon http://www.eecs.qmul.ac.uk/~simond/beatroot/
//provide location of the jar file
f.extractBeatsViaBeatRoot("/Users/nickcollins/Desktop/tosort/beatroot/beatroot-0.5.7.jar"); //wait for me to finish

a = f.beatdata



//test beatwise feature accumulation

f = SCMIRAudioFile("/data/audio/mirdata/pixiesivebeentired.wav", [[MFCC, 13], [Chromagram, 12]]);

(
    f.extractFeatures(); 
    f.extractBeats();
)


f.numfeatures
f.numframes

b = f.similarityMatrix(50, 2);
b.plot(4,10);

//by default, replaces old featuredata with beatwise features
f.gatherFeaturesByBeats //after this operation, featuredata will be beat locked; if referencing specific frames, must use beatdata to get (starting) times

e.featuresbysegments //this flag has now been set to true

//should now be same:
f.featuredata.size/f.numfeatures
f.numbeats

b = f.similarityMatrix(4, 2);
b.plot(5,10);

l = e.findSections(0,1,20);

l

//comparison of beat locked features and standard feature vectors for section finding; on this track, get better estimates from beat-locked segments (if out by a second or two)
//found by beat based feature vectors: [ 13.556099891663, 44.077278137207, 57.808979034424, 67.929977416992, 78.484901428223, 98.114463806152, 113.2437210083, 121.31120300293, 129.8851776123, 140.64761352539, 154.83645629883 ]
//found by blocks of standard feature frames
//[ 19.272562358277, 58.049886621315, 97.52380952381, 129.10294784581, 135.37233560091, 141.87392290249 ]




//test of onset detection


f = SCMIRAudioFile("/data/audio/mirdata/pixiesivebeentired.wav", [[MFCC, 13], [Chromagram, 12]]);
//f = SCMIRAudioFile(Platform.resourceDir +/+ "sounds/a11wlk01.wav", [[MFCC, 13], [Chromagram, 12]]);

(
f.extractFeatures(); 
f.extractOnsets();
)

f.onsetdata
f.numonsets

f.gatherFeaturesByOnsets //after this operation, featuredata will be onset locked; if referencing specific frames, must use onsetdata to get (starting) times

f.featuresbysegments //this flag has now been set to true

//should now be same:
f.featuredata.size/f.numfeatures
f.numonsets

b = f.similarityMatrix(5, 2);
b.plot(1,10);

l = f.findSections(0,1,20);

l

//found by onset detection, compare to above
//[ 11.3429479599, 20.416145324707, 29.779592514038, 35.247890472412, 41.052879333496, 47.008796691895, 58.955463409424, 67.877731323242, 78.233833312988, 82.494697570801, 89.559364318848, 99.642631530762, 106.09777832031, 111.35709381104, 121.05142974854, 130.75736999512, 140.81161499023, 156.64181518555, 167.87446594238 ]



//raw onset detection function as feature
f = SCMIRAudioFile("/data/audio/mirdata/pixiesivebeentired.wav", [[Onsets,\rcomplex]]);

f.extractFeatures(); 

f.numframes

f.featuredata.plot

f.duration

//artificial segmentation: one per second
a= (0.0,1.0..(f.duration))

//averaging for each second
f.gatherFeaturesBySegments(a); 

f.numframes

f.featuredata.plot

//must recalculate features, didn't keep them in previous call when replaced with segment averages
f.extractFeatures(); //wait for me to finish

//max over each second rather than mean
f.gatherFeaturesBySegments(a, true, 1); 

f.numframes

f.featuredata.plot




//test of batch processing


//or via pathMatch, e.g. "sounds/*.aiff".pathMatch

SCMIR.setTempDir("/Users/nickcollins/Desktop/SCMIRTest") //all saved files will go here

~files = [Platform.resourceDir +/+"sounds/a11wlk01.wav", "/data/audio/mirdata/pixiesivebeentired.wav"]; 

//batch process; within Routine to get progress feedback as it calculates (would be slightly faster without, but calculation beachball locking sclang may seem alarming)
(    
{
~files.do{|filename,i|     

[i, filename].postln;
    
e = SCMIRAudioFile(filename, [[Loudness]]);
    
e.extractFeatures();

e.save("/Users/nickcollins/Desktop/SCMIRTest/"++(filename.splitext[0].basename++".scmirZ"));
        
}
}.fork;
)


a= ~files.collect{|filename| SCMIRAudioFile.newFromZ("/Users/nickcollins/Desktop/SCMIRTest/"++(filename.splitext[0].basename)++".scmirZ")}

a[0].numframes
a[1].numframes





//test of global normalization processing


//first run 
(
~files = [Platform.resourceDir +/+ "sounds/a11wlk01.wav", "/data/audio/mirdata/pixiesivebeentired.wav","/data/audio/mirdata/Yellow Submarine.wav"]; 
~featureinfo= [[MFCC,13],[Chromagram,12]]; 

{SCMIR.findGlobalFeatureNorms(~files,~featureinfo); }.fork
    
)


SCMIR.globalfeaturenorms //in this case, will be minimums in first array, maximums in second


//you can save this file for later reuse (assumes exactly same featureinfo settings, which is up to you to check)

SCMIR.saveGlobalFeatureNorms("/Users/nickcollins/Desktop/testglobfeat.scmirZ"); 

//recall
SCMIR.loadGlobalFeatureNorms("/Users/nickcollins/Desktop/testglobfeat.scmirZ"); 



//now to normalize individual files with respect to global normalization
(
~normed = ~files.collect{|filename|
    var e; 
    
    e= SCMIRAudioFile(filename,~featureinfo);    
    
    e.extractFeatures(true, true); //will use global normalization 
    
}
)

//normalized SCMIRAudioFiles
//find max and mins in different files, so did normalize with respect to larger corpus
~normed[0].getFeatureTrail(0).minItem
~normed[1].getFeatureTrail(0).minItem



//compare standardization


e = SCMIRAudioFile(Platform.resourceDir +/+ "sounds/a11wlk01.wav", [[MFCC, 13], [Chromagram, 12]], 1); //additional third argument non zero means standardize, not normalize

e.extractFeatures();

e.featuredata

(
for(0,24,{|j|  
    var a; 
    
    a = e.getFeatureTrail(j); 
    [a.minItem,a.maxItem].postln;

    }); 
)


//graphing issues; by default, assumes 3 standard deviations either side of zero mean work out to 0.0 to 1.0 range

e.plotFeatures(300,300,40); 
e.plotFeatures(300,300,40,true); 


b = e.similarityMatrix(2, 2);
b.plot(5,6);


b.matrix.minItem




//time domain features and comparison to perceptual loudness and pitch

e = SCMIRAudioFile(Platform.resourceDir +/+ "sounds/a11wlk01.wav", [\ZCR,\RMS,\Loudness,\Tartini]);

e.extractFeatures()

e.numfeatures

e.featuredata

e.plotFeatures(300,300); //will resample feature data to fit dimensions requested

e.plotFeatures(400,600,40, true); //line based plot



//test MP3 loading, and taking a section from the middle of the file 

//take 30 seconds at middle (defaults to extracting 10 MFCCs)
(
{
f = SCMIRAudioFile("/data/audio/mp3mixed/dj/dubstari.mp3",start:0.5,dur: 30.0);

f.extractFeatures(); 

}.fork;
)

f.numfeatures

f.plotFeatures(300,300,40,true); 





//Chromagram Difference and summation between frames

e = SCMIRAudioFile("/data/teachingmaterials/electronicmusic/seminar/seminaraudio/MeanBeat_Amen_Loop.wav",[[Chromagram,12]]);

e.extractFeatures()

e.differentiateFeature(0,1)

e.sumMultiFeature(0)

e.featuredata

e.numfeatures

e.renormalize; 

e.plotFeatures(300,300,40,true); 







e = SCMIRAudioFile("/data/teachingmaterials/electronicmusic/seminar/seminaraudio/MeanBeat_Amen_Loop.wav", [[\Loudness],[\Transient,0.7,0.2],[\Transient,0.1,0.05],[\Transient,0.1,0.0],[\Transient,0.9,0.0],[\Transient,0.2,0.01],[\Onsets,\rcomplex]]);

e.extractFeatures()

e.plotFeatures(300,300,40); 

e.differentiateFeature([0,1],0)

e.plotFeatures(300,300,40); 

e.plotFeatureTrail(0) //difference of Loudness
e.plotFeatures(400,600,40, true); //line based plot




////////////////////////////////////////////////////////////////////////////////




