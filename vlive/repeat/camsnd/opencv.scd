
OSCdef(\test, {|msg, time, addr, recvPort| [\unmatching, msg].postln}, '/hello', n); // def style
OSCdef(\test, {|msg, time, addr, recvPort| [\unmatching, msg].postln}, '/imgsnd/hist', n); // def style


(
OSCdef(\test, {|msg, time, addr, recvPort| 
	//[\unmatching, msg].postln;
	~bins = msg.drop(1);

}, '/imgsnd/hist', n); // def style

OSCdef(\splitmean, {|msg, time, addr, recvPort| 
	[\unmatching, msg].postln;
	~split = msg.drop(1);

}, '/imgsnd/splitmean', n); // def style

)
    
~split
~bins/20

(
Pdef(\part, Pdef(\zedpart, 
	Ppar(
		16.collect { arg idx;
			Pbind(
				\instrument, \default,
				\freq, idx.linexp(0,15,80,10000),
				\dur, 1,
				\amp, 0.1 * Pfunc({topEnvironment[\bins][idx]/50000}),
			)
			
		};
		
	)
)).play;
);

(
SynthDef(\ssin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\ssin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.4) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar(
		16.collect { arg idx;
			Pbind(
				\instrument, \ssin,
				\freq, Pfunc({topEnvironment[\bins][idx]/10}),
				\dur, Pwhite(0.05,0.5),
				\amp, 0.1,
			)
			
		};
		
	)
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar(
		16.collect { arg idx;
			Pmono(
				 \ssin,
				\freq, ~pmodenv.(Pfunc({topEnvironment[\bins][idx]/10}), 0.5).loop,
				\dur, 1,
				\amp, 0.1,
			)
			
		};
		
	)
)).play;
);

~bins[10]
~bins.explin(100,8000000,0,1)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar(
		16.collect { arg idx;
			Pmono(
				 \ssin,
				 \note, ( [0,3,7] +.x ( (0..5)*12 ) )[idx],
				 \note, (30..50)[idx],
				 \note, ( ( (0..5)*12 ) +.x [0,3,7,9,11] )[idx],
				 \note, ( ( (0..5)*12 ) +.x [0,3,7]  )[idx],
				 \octave,3,
				\amp, ~pmodenv.(Pfunc({
					var bi = topEnvironment[\bins][idx];
					//bi.explin(100,8000000,0,1)/20;
					bi.explin(10000,20000,0,1)/10;
				}).trace, 0.5).loop,
				\dur, 1,
			)
			
		};
		
	)
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar(
		16.collect { arg idx;
			Pbind(
				 \instrument, \ssin,
				 \note, ( [0,3,7] +.x ( (0..5)*12 ) )[idx],
				 \note, (30..50)[idx],
				 \note, ( ( (0..5)*12 ) +.x [0,3,7]  )[idx],
				 \note, ( ( (0..5)*12 ) +.x [0,3,7,9,11] )[idx],
				 \octave,3,
				 \root, Pfunc({
					var bi = topEnvironment[\bins][0];
					//bi.explin(100,8000000,0,1)/20;
					var res = bi.explin(100,80000,0,1)/1*10;
					res.asInteger;
				}).stutter(10).trace,
				 \legato, 0.2,
				\dur, Pfunc({
					var bi = topEnvironment[\bins][idx];
					//bi.explin(100,8000000,0,1)/20;
					bi.explin(100,80000,0,1)/1*10;
				})+0.3,
			)
			
		};
		
	)
)).play;
);







/////////////////







// A random pad generation thing. Every time you click EXECUTE, a pad with a certain number of melodic lines is generated using the parameters in the GUI.
// Use it -> study the code -> modify it -> ? -> profit!
(

// This function creates an instance of the Pad Generator
~padGenerator = {

	var res = Environment.make({

		// Score Parameters
		// See the GUI code for explanations.
		~sp = (
			numMelodicLines:         3,
			numNotesPerMelodLine:  8,
			baseNote:         40,
			degrees:            [0,7,12],
			durs:             [1,2,4,3],
			noteOfs:          [0,12,24],
		);
		~sp.minNoteDur =      { 1/16 }!~sp.numMelodicLines;
		~sp.instrs =          { #[sin1,sin2,sin3,sin1,sin1] }!~sp.numMelodicLines;
		// This Semaphores are used to wait synchronously the ending of all the melodic lines.
		// Every melodic line has a lock associated.
		// When a melodic line stop playing it opens the Semaphore.
		~locks =              List[];
		~executing =          false;

		// Utility. Translate Symbols arrays to Strings
		~symbolsArrayToString = { |arr|

			var res;

			if( arr.size == 0 )
			{ res = arr.asString; }
			{
				var strs = arr.collect{|el|
					~symbolsArrayToString.(el);
				};
				if( arr[0].size == 0 ){ res = "#[" }{ res = "[ "; };
				strs.do{ |el,i|
					res = res + el + ",";
				};
				res = res + "]";
			};

			res
		};

		// Utility. Resize a multidimensional array.
		// Ex:
		// IN   arr = [ [1,2,3], [4,] ]    size = 5
		// OUT  arr = [ [1,2,3], [4,], [1,2,3], [4,], [1,2,3] ]
		~resizeMultiDimArray = { |arr,size|

			var res = arr;

			if( arr.size > size ){

				res = Array.newClear( size );
				size.do{ |i| res[i] = arr[i]; };

			};

			if( arr.size < size ){

				res = Array.newClear( size );
				size.do{ |i| res[i] = arr[ i%(arr.size) ]; };

			};

			res
		};

		// This function include all the operations to be carried out before the actual playing
		~prepare = {

			SynthDef(\sin1,{

				|out = 0, amp = 0.1, gate = 1, freq = 440|

				var d = ();

				d.gen    = SinOsc.ar(freq) ** 3;
				d.envAmp = Env.asr(1,1,6).kr(2,Trig1.kr(gate,1,1)) * amp;
				d.res    = Clip.ar( d.gen, -1.01, 1.01 ) * d.envAmp ! 2;

				Out.ar(out,d.res);

			}).add;

			s.sync;

			SynthDef(\sin2,{

				|out = 0, amp = 0.1, gate = 1, freq = 440|

				var d = ();

				d.gen    = SinOsc.ar(freq+[0,1]) ** 2;
				d.envAmp = Env.asr(1,1,6).kr(2,Trig1.kr(gate,1,1)) * amp;
				d.res    = Clip.ar( d.gen, -1.01, 1.01 ) * d.envAmp;

				Out.ar(out,d.res);

			}).add;

			s.sync;

			SynthDef(\sin3,{

				|out = 0, amp = 0.1, gate = 1, freq = 440|

				var d = ();

				d.gen    = SinOsc.ar(freq+[1,0]).abs;
				d.envAmp = Env.asr(1,1,6).kr(2,Trig1.kr(gate,1,1)) * amp;
				d.res    = Clip.ar( d.gen, -1.01, 1.01 ) * d.envAmp ! 2;

				Out.ar(out,d.res);

			}).add;

			s.sync;
		};


		// Utility
		// Ex: ~playNote.(\sin1,[\freq,440],1.5);
		~playNote = { |sdef,args,dur=1|

			var nt;
			s.makeBundle(nil,{ nt = Synth(sdef,args); });
			dur.wait;
			nt.set(\gate,0);

		};

		// This function generates all the melodic lines and play them.
		// It waits for all of them to finish.
		~score = {

			var str, strd, stri, strl, numMelodicLines, numNotesPerMelodLine, minNoteDur, degrees,
			durs, noteOfs, instrs;

			noteOfs    = ~sp.noteOfs.reshape(~sp.numMelodicLines);
			minNoteDur = ~sp.minNoteDur.reshape(~sp.numMelodicLines);

			~sp.instrs = ~resizeMultiDimArray.( ~sp.instrs, ~sp.numMelodicLines );

			// The notes of every melodic line are generated here
			str      = (~sp.numMelodicLines).collect{|p|
				{ ~sp.degrees.choose + noteOfs[p] + ~sp.baseNote }!~sp.numNotesPerMelodLine
			};
			// The durations of every melodic line are generated here
			strd     = ~sp.numMelodicLines.collect{|p|
				{ ~sp.durs.choose * minNoteDur[p] }!~sp.numNotesPerMelodLine
			};
			// The instrument names for every melodic line are generated here
			stri     = ~sp.numMelodicLines.collect{|p| { ~sp.instrs[p].choose }!~sp.numNotesPerMelodLine };

			~locks     = { Semaphore(0) }!~sp.numMelodicLines;

			// Code for the acutal playing
			~sp.numMelodicLines.do{ |i|
				{
					// suona, sequenzialmente, le note di una parte
					str[i].size.do { |j|
						~playNote.(
							stri[i][j],
							[\freq,str[i][j].midicps,\amp,0.01,\gate,1,],
							strd[i][j]
						);
					};
					// segnala fine parte, rilasciando il Semaphore dedicato
					~locks[i].signal;
				}.fork;
			};
			// Wait for all the melodic lines to end
			str.size.do{ |i| ~locks[i].wait; };

			"Done".postln;

		};

		// Unused
		~finish = {

		};

		/* Utility. If this instance of the pad generator is not already generating/playing something,
		this function executes the input function.*/
		~ifNotAlreadyExecuting = { |func|
			if( ~executing, {
				"An instance of the patch is already executing".postln;
			},{
				func.();
			});
		};
		/* Launch the pad generation/execution. */
		~startScore = { |e|
			var func = {
				s.waitForBoot{
					{
						~ifNotAlreadyExecuting.({
							~prepare.();
							~executing = true; ~score.(); ~executing = false;
							~finish.();
						});
					}.fork;
				};
			};
			if( e.class == Environment ){
				e.use{ func.(); };
			}{
				func.();
			};
		};

		~showUi = { |e,parent,bounds|
			var func = {
				var wi, // width
				he=20,  // row height
				rows=8, // rows used for the controls
				helpRows = 3,
				dr       = 0, // #rows for the documentation
				hv,     // help view
				mhb,    // make help button; helper function
				tr       = rows+1+helpRows+dr, // total number of rows
				pa;     // panel view

				if( bounds.isNil ){
					bounds = Rect(0,0,400,he*(tr));
				}{
					he = bounds / (tr);
				};
				wi = bounds.width;

				if( parent.isNil ){
					parent = Window("Pad Generator",bounds);
					parent.front;
				};

				mhb = { |row=0,msg("")|
					Button(pa,Rect(wi-he,he*(dr+row),he,he)+Rect(2,2,-4,-4))
					.states_([["?",Color.white,Color.blue]])
					.mouseEnterAction_{ hv.string=msg; }
					.mouseLeaveAction_{ hv.string=""; };
				};

				pa = View(parent,bounds);

				StaticText(pa,Rect(0,he*0,wi,he*dr)+Rect(2,2,-4,-4))
				// .background_(Color.blue(0.4))
				.stringColor_(Color.blue(0.4))
				.align_(\left)
				.string_("DOCUMENTATION \n ");

				EZNumber(pa,Rect(0,he*dr,wi-he,he),"# melodic lines",[1,100,\lin,1,1],{ |vv|
					e.sp.numMelodicLines = vv.value.asInteger; },e.sp.numMelodicLines,false,100,gap:2@2,margin:2@2);
				mhb.(0,"Number of melodic lines played simultaneously.");

				EZNumber(pa,Rect(0,he*(dr+1),wi-he,he),"# notes per melodic line",[1,40,\lin,1,1],{ |vv|
					e.sp.numNotesPerMelodLine = vv.value.asInteger; },
				    e.sp.numNotesPerMelodLine,false,100,gap:2@2,margin:2@2
				);
				mhb.(1,"Length (in number of notes) of every melodic line");

				EZNumber(pa,Rect(0,he*(dr+2),wi-he,he),"base note",[20,100,\lin,1,40],{ |vv|
					e.sp.baseNote = vv.value.asInteger; },e.sp.baseNote,false,100,gap:2@2,margin:2@2);
				mhb.(2,"A base note the generation algorithm uses as root for the melodic lines");

				EZText(pa,Rect(0,he*(dr+3),wi-he,he),"degrees set",{|vv|
					var val;
					val = vv.value.interpret;
					if( val.class == Array ){
						e.sp.degrees = val;
					};
				},e.sp.degrees.asString,false,100,gap:2@2,margin:2@2);
				mhb.(3,"Set of degrees used by the generation algorithm to create the melodic lines");

				EZText(pa,Rect(0,he*(dr+4),wi-he,he),"relative durs set",{|vv|
					var val;
					val = vv.value.interpret;
					if( val.class == Array ){
						e.sp.durs = val;
					};
				},e.sp.durs.asString,false,100,gap:2@2,margin:2@2);
				mhb.(4,"Set of relative durations used to calculate the final absolute note durations. \n\t\tabs_note_dur = choose_one('relative durs set') * 'min note dur' ");
				EZText(pa,Rect(0,he*(dr+5),wi-he,he),"note offsets",{|vv|
					var val;
					val = vv.value.interpret;
					if( val.class == Array ){
						e.sp.noteOfs = val;
					};
				},e.sp.noteOfs.asString,false,100,gap:2@2,margin:2@2);
				mhb.(5,"Note offset added to the 'base note' for every melodic line. \n\t'note offsets'[i] = note offset for the ith melodic line");

				EZText(pa,Rect(0,he*(dr+6),wi-he,he),"min note durs",{|vv|
					var val;
					val = vv.value.interpret;
					if( val.class == Array ){
						e.sp.minNoteDur = val;
					};
				},e.sp.minNoteDur.asString,false,100,gap:2@2,margin:2@2);
				mhb.(6,"min_note_dur[i] = minimum note duration for the ith melodic line");
				EZText(pa,Rect(0,he*(dr+7),wi-he,he),"instrs",{|vv|
					var val;
					val = vv.value.interpret;
					val.class.postln;
					if( val.class == Array ){
						e.sp.instrs = val;
					};
				},~symbolsArrayToString.(e.sp.instrs),false,100,gap:2@2,margin:2@2);
				mhb.(7,"This array has a sub-array for every melodic line. \nEvery i-th sub-array contains the instruments that the i-th melodic line can randomly choose for its notes");

				Button(pa,Rect(0,he*(dr+8),wi,he))
				.states_([["EXECUTE",Color.white,Color.black]])
				.action_({ e.startScore(); 	});

				hv = StaticText(pa,Rect(0,he*(dr+9),wi,he*helpRows)+Rect(2,2,-4,-4))
				.background_(Color.blue(0.4))
				.stringColor_(Color.white)
				.align_(\left)
				.string_("");

			};
			if( e.class == Environment ){ e.use({ func.(parent,bounds); }); }{ func.(e,parent); };
		};

	});

	res.know = true;

	res
};

~p1 = ~padGenerator.();
~p1.showUi();

)

// CODE FOR DEVELOPMENT/DEBUGGING
~p1.executing = false;
~p1.sp
~p1.startScore();
~sp = nil
s.quit


///////////////////////////////////////


(
//sample creation using the PadSynth algorith described at http://wiki.linuxmusicians.com/doku.php?id=zynaddsubfx_manual#padsynth_algorithm
//based on code from Donald Craig http://new-supercollider-mailing-lists-forums-use-these.2681727.n2.nabble.com/Epic-Pads-td7487382.html#a7492701
s.waitForBoot({
	var table, re, im, tab, fftsize, result, pars, freqs, amps, bandwidth, partials, note;
	var samplerate = s.sampleRate;
	var sgroup;
	var fxgroup1,fxgroup2;
	var reverbbus,chorusbus;
	var reverb, chorus;
	var prepareSingleBuffer, prepareAllBuffers;
	var spectrum, xvals;

	s.freeAll;
	s.freeAllBuffers;
	s.sync;

	sgroup = Group.new;
	fxgroup1 = Group.after(sgroup);
	fxgroup2 = Group.after(fxgroup1);
	reverbbus = Bus.audio(s, 1);
	chorusbus = Bus.audio(s, 1);

	~buffers = [];

	SynthDef(\padfilterenv, {
		| out=0, referencefreq=130, amp=0.5, freq=440, buffer=1, gate=1, attack=0.1, decay=0.2, sustain=0.6, release=2, filtercutoff=10000, filterresonance=1.0, filterattack=0.01, filterdecay=0.2, filtersustain=0.8, filterrelease=2, filtergain=1.0, glissando=0 |
		var env = EnvGen.ar(Env.adsr(attack, decay, sustain, release), gate, doneAction:Done.freeSelf);
		var env2 = EnvGen.ar(Env.adsr(filterattack, filterdecay, filtersustain, filterrelease), gate, doneAction:Done.none);
		var frequency = VarLag.ar(freq, glissando, warp:\exponential);
		var sig = env*PlayBuf.ar(1, buffer, rate:((frequency.cpsmidi)-(referencefreq.cpsmidi)).midiratio, loop:1);
		sig = RLPF.ar(sig, env2*filtercutoff, rq:filterresonance, mul:filtergain);
		Out.ar(out, amp*sig);
	}, rates:[nil, nil, nil, \ar, nil, nil, nil, nil, nil, nil, nil]).add;

	SynthDef(\reverb, {
		| out=0, inbus, mix=0.5, room=1.0 |
		var insig = FreeVerb.ar(In.ar(inbus, 1),mix,room);
		Out.ar(out, insig!2);
	}).add;

	SynthDef(\chorus, {
		| outbus=0, inbus, predelay=0.08, speed=0.05, depth=0.1, ph_diff=0.5 |
		var in, sig, modulators, numDelays = 12;
		in = In.ar(inbus, 1) * numDelays.reciprocal;
		modulators = Array.fill(numDelays, { |i|
			LFPar.kr(speed * rrand(0.94, 1.06), ph_diff * i, depth, predelay);
		});
		sig = DelayC.ar(in, 0.5, modulators);
		sig = sig.sum; //Mix(sig);
		Out.ar(outbus, sig!2); // output in stereo
	}).add;

	s.sync;

	// calculate single wavetable
	prepareSingleBuffer = {
		| partials /* flat list of [partial idx, partial amplitude, partial idx, partial amplitude, ...]. Partials often are integers (or close to) */,
		  min_length, /* min length of generated wave table in seconds */
		  spread /* band width used to generate new partials around the existing partials */,
		  reference_note /* note for which this spectrum is being generated */|

		var fftsize = (min_length*s.sampleRate).nextPowerOfTwo;
		var pars = (partials.size/2);
		var bandwidth = (1+spread);
		var note = reference_note;
		var	table = Signal.newClear(fftsize);
		var tab = Signal.fftCosTable(fftsize);
		var re = Signal.newClear(fftsize);
		var im = Signal.newClear(fftsize);
		var freqs = Array.newClear(pars);
		var amps = Array.newClear(pars);
		var buffer;
		var deinterlaced;
		fftsize.do({ |i|
			re[i] = 0.0;
			im[i] = 0.0;
			table[i] = 0.0;
		});

		// partials are specified in a flat list containing
		// each time partial number followed by corresponding partial volume.
		// first deinterlace this flat list into a list of frequencies and a list of amplitudes
		deinterlaced = partials.unlace;
		freqs = deinterlaced[0]*(note.midicps);
		amps = deinterlaced[1];

		// next we're going to generate extra (smeared) partials. This helps in adding life and warmth to the sounds.
		// if you specify spread == 0, no extra partials will be added
		pars.do({ |i|
			var freq, lo, hi,amp;
			freq = freqs[i];
			amp = amps[i];
			lo = ((freq/bandwidth)*(fftsize/samplerate)).round; // partial at frequency freq will be smeared over frequencies lo to hi
			hi = ((freq*bandwidth)*(fftsize/samplerate)).round;
			// generate extra partials between frequencies lo = freq/(1+spread) and hi = freq*(1+spread)
			(hi-lo+1).do({ |j|
				var mag, phase, val;
				var index = j.linlin(0, hi-lo, lo, hi);
				// only fill up lower half of spectrum:
				// right half later is derived from this left half to ensure a real-valued inverse fourier transform
				if(index < (fftsize/2), {
					if ((hi == lo), {
						mag = amp;
						table[index] = table[index] + mag; // add it to the result table
					}, /* else */ {
						val = j.linlin(0, hi-lo, -1, 1);
						mag = exp(val*val*10.0.neg) * amp; // generates a bell-shaped curve for val in [-1,1] with y-values between [-amp, amp]
						table[index] = table[index] + mag; // add it to the result table to create a "smeared" partial
					});
					phase = rrand(-pi, pi); // set random phase
					re[index] = re[index] + (cos(phase)*mag);
					im[index] = im[index] + (sin(phase)*mag);
				});
			});
		});

		// at this point, table contains the sum of all the specified + extra generated partials

		// calculate right half of spectrum to get a real-valued inverse FFT
		// right half must be the mirrored complex conjugate (i.e. make imaginary part negative) of the left half
		(fftsize/2-1).do({
			| i |
			re[i+(fftsize/2)] = re[(fftsize/2)-i];
			im[i+(fftsize/2)] = im[(fftsize/2)-i].neg;
		});

		// inverse fourier transformation: resulting imaginary part should be (very close to) all zeros
		re = ifft(re, im, tab);

		// re.real.normalize scales the result so it falls between 0 and 1.
		// Next, make sure to normalize the maximum volume to -3dB.
		result = re.real.normalize * ((-3).dbamp);

		// load the result in a buffer
		buffer = Buffer.loadCollection(s, result);

		// and return the buffer as result of the function
		buffer;
	};

	// calculate 2 wavetables per octave
	prepareAllBuffers = {
		| partials = #[ 1.01, 0.1722,  2.00, 0.0056,  2.99, 0.1609,  3.99, 0.0333,  5.00, 0.1157,
			5.99, 0.1149,  6.98, 0.0079, 7.98, 0.0620,  8.99, 0.0601,  9.99, 0.0104,
			10.98, 0.0134, 11.97, 0.0122, 12.99, 0.0058, 13.98, 0.0110, 14.98, 0.0029,
			15.97, 0.0045, 16.98, 0.0023, 17.98, 0.0010, 18.97, 0.0016, 19.96, 0.0021,
			20.96, 0.0008, 21.97, 0.0021, 22.96, 0.0001, 23.96, 0.0012, 24.95, 0.0003,
			25.97, 0.0002, 26.96, 0.0003, 27.95, 0.0002, 30.96, 0.0002, 32.94, 0.0002,
			34.96, 0.0001, 35.95, 0.0002, 37.93, 0.0001 ],
		  min_length=5,
		  spread = 0.1 |
		var buffers = [];
		var maxOctaves = 8;
		// prepare two wavetables per octave
		(0,1..8).do({
			| octave |
			var reference_note_1 = (octave*12);
			var reference_note_2 = (octave*12) + 6;
			buffers = buffers.add(prepareSingleBuffer.value(partials, min_length, spread, reference_note_1));
			buffers = buffers.add(prepareSingleBuffer.value(partials, min_length, spread, reference_note_2));
		});

		buffers;
	};

	// calculate a desired spectrum (note: envelopes and filters/resonators/fx are just as important in determining overall experience)
	xvals = (1,2..33).as(Array);
	spectrum = Signal.newClear(33).waveFill({
		| x, old, idx |
		var lookup;
		lookup = [ 14.2, 8.8, 7.3, 8, 5.7, 7, 6.8, 5.8, 8.7, 6.9, 3.2, 2.1, 4, 3, 1.8, 1.1, 2.5, 1.5]; // cello-esque if attack 0.3, no filter env, small reverb
		if ((idx < lookup.size), {lookup[idx]}, {0});

	}, start:1, end:0).as(Array);
	spectrum = [xvals, spectrum].lace;

	// prepare the wavetables using inverse FFT
	~buffers = prepareAllBuffers.value(spectrum,
		5 /* minimum length of buffer in seconds */,
		0.03 /* spread of partials during detuning */);

	s.sync;

	// start the fx synths
	reverb = Synth(\reverb, [
		\out, 0,
		\inbus, reverbbus,
		\mix, 0.1,
		\room, 0.5,
	],
	target:fxgroup2);

	chorus = Synth(\chorus, [
		\out, reverbbus,
		\inbus, chorusbus
	],
	target:fxgroup1);

	// create a composition
	// Pbind a new synth for each note.
	p = Pbind(
		\instrument, \padfilterenv,
		\out, reverbbus,
		\mynote, Pseq([Pseq((40,41..72), 1), Prand((48,49..72), 100)], inf),
		\myreference, (Pkey(\mynote)-(Pkey(\mynote)%6)),
		\referencefreq, Pkey(\myreference).midicps,
		\freq, Pkey(\mynote).midicps,
		\dur, Pseq([Pseq([0.5], 72-24), Prand((0.1,0.2..1.0), 100)], inf),
		\amp, 0.7,
		\buffer, Pfunc({ |ev| ~buffers[(ev[\myreference]/6).round(1)].bufnum; }),
		\attack, 0.3,
		\decay, 0.1,
		\sustain, 0.9,
		\release, 1.0,
		\filtergain, 0.3,
		\filtercutoff, 1000,
		\filterattack, 0.01,
		\filterdecay, 0.1,
		\filtersustain, 1.0,
		\filterrelease, 0.3,
		\filterresonance, 1.0,
		\glissando, 0,
		\vibratofreq, 3.0,
		\vibratodepth, 0.015,
		\group, sgroup);

	// Pmono creates only one synth, and updates its parameters. This allows e.g. for glissando's.
	q = Pmono(
		\padfilterenv,
		\out, reverbbus,
		\mynote, Pseq([40, 52], inf),
		\myreference, (Pkey(\mynote)-(Pkey(\mynote)%6)),
		\referencefreq, Pkey(\myreference).midicps,
		\freq, Pkey(\mynote).midicps,
		\dur, Pseq([2], inf),
		\amp, 0.7,
		\buffer, Pfunc({ |ev| ~buffers[(ev[\myreference]/6).round(1)].bufnum; }),
		\attack, 0.3,
		\decay, 0.1,
		\sustain, 0.9,
		\release, 1.0,
		\filtergain, 0.3,
		\filtercutoff, 1000,
		\filterattack, 0.01,
		\filterdecay, 0.1,
		\filtersustain, 1.0,
		\filterrelease, 0.3,
		\filterresonance, 1.0,
		\glissando, 0.5,
		\vibratofreq, 3.0,
		\vibratodepth, 0.015,
		\group, sgroup);

	c = Ppar([p,q], inf);
	c.play;

});
)

///////////////

/*
 A SuperCollider implementation of the synth sound described here:
 "http://www.attackmagazine.com/technique/synth-secrets/detuned-pad/"
*/

// Chord seq:
// 1. (E1, E2, B3, D4, G4)
// 2. (G1, G2, B3, D4, F#4, A4)
// 3. (G1, G2, B3, D4, F#4, A4, B4)
// 4. (A1, A2, C4, E4, G4)
// 5. (C1, C2, G3, E4, G4)

(
// sequence
~crdStr = [["E1", "E2", "B3", "D4", "G4"],
	["G1", "G2", "B3", "D4", "F#4", "A4"],
	["B4"],
	["A1", "A2", "C4", "E4", "G4"],
	["C1", "C2", "G3", "E4", "G4"]
];

// Map from chord names to midi notes
~noteToMidi = {
	arg noteStr;
	var notes = Dictionary[
	"C"  -> 0,
	"C#" -> 1,
	"D"  -> 2,
	"D#" -> 3,
	"E"  -> 4,
	"F"  -> 5,
	"F#" -> 6,
	"G"  -> 7,
	"G#" -> 8,
	"A"  -> 9,
	"A#" -> 10,
	"B"  -> 11];
	var octave = noteStr.last.digit;
	var degree = notes[noteStr[..noteStr.size-2].postln];
	octave*12 + degree;
};

~crdArray = ~crdStr.collect{
	arg crd;
	crd.collect{|c| ~noteToMidi.(c)};
};
)

// STEP 1: a simple synth
(
// Init synth
SynthDef(\simpSaw1, {|freq, gate=1 amp=0.1|
	var env = EnvGen.ar(Env.adsr(0.01,0.3,0.5,0.1), gate, doneAction:2);
	var snd = Saw.ar(freq!2);

	Out.ar(0, env*snd*amp);
}).add;
)

// Play chord seq
(
Pbind(
	\instrument, \simpSaw1,
	\freq, Pseq(~crdArray + 24, inf).midicps,
	\dur, 2.5*Pseq([1, 0.375, 0.625, 1, 1], 1),
	\sustain, 2.55*Pseq([1, 1, 0.625, 1, 1], 1)
).play;
)

// STEP2: add voices/detune/de-phase

(
SynthDef(\simpSaw2, {|freq, gate=1 amp=0.1|
	var adsr = EnvGen.ar(Env.adsr(0.25,0.01,0.75,0.25), gate, doneAction:2);
	var nvoices1 = 5, nvoices2 = 7;
	var detune1 = 10, detune2 = 5;

	var osc1 = {
		var m = 2**(detune1/1200).rand2;
		var n = 2**(detune1/1200).rand2;
		var saw = LFSaw.ar(m * freq/2);
		DelayC.ar(saw, 0.02, ( freq*n ).reciprocal);
	}.dup(nvoices1);

	var osc2 = {
		var m = 2**(detune2/1200).rand2;
		var n = 2**(detune2/1200).rand2;
		var saw = LFSaw.ar(m * freq);
		DelayC.ar(saw, 0.02, ( freq*n ).reciprocal);
	}.dup(nvoices2);

	Out.ar(0, Splay.ar(osc1 + osc2 * adsr)/4 * amp);
}).add;
)

// Play chord seq
(
Pbind(
	\instrument, \simpSaw2,
	\freq, Pseq(~crdArray+24, inf).midicps,
	\dur, 2.5*Pseq([1, 0.375, 0.625, 1, 1], 1),
	\sustain, 2.5*Pseq([1, 1, 0.625, 1, 1], 1)
).play;
)


// STEP3: add LFO
(
SynthDef(\simpSaw3, {|freq, gate=1 amp=0.1|
	var adsr = EnvGen.ar(Env.adsr(0.25,0.01,0.75,0.25), gate, doneAction:2);
	var nvoices1 = 5, nvoices2 = 7;
	var detune1 = 10, detune2 = 5;

	var osc1 = {
		var m = 2**(detune1/1200).rand2;
		var lfo = SinOsc.ar(3.rand).range(0,1);
		DelayC.ar(Saw.ar(m * freq/2), 0.02, freq.reciprocal.rand * lfo);
	}.dup(nvoices1);

	var osc2 = {
		var m = 2**(detune2/1200).rand2;
		var lfo = SinOsc.ar(3.rand).range(0,1);
		DelayC.ar(Saw.ar(m * freq), 0.02, freq.reciprocal.rand * lfo);
	}.dup(nvoices2);

	Out.ar(0, Splay.ar(osc1 + osc2 * adsr)/4 * amp);
}).add;
)

// Play chord seq
(
Pbind(
	\instrument, \simpSaw3,
	\freq, Pseq(~crdArray+24, inf).midicps,
	\dur, 2.5*Pseq([1, 0.375, 0.625, 1, 1], 1),
	\sustain, 2.5*Pseq([1, 1, 0.625, 1, 1], 1)
).play;
)

// STEP4: add filter
(
SynthDef(\simpSaw4, {|out=0,freq, gate=1 amp=0.1|
	var adsr = EnvGen.ar(Env.adsr(1e-8,1e-6,0.75,0.125), gate, doneAction:2);
	var nvoices1 = 5, nvoices2 = 7;
	var detune1 = 12, detune2 = 8;

	var osc1 = {
		var m = 2**(detune1/1200).rand2;
		var lfo = SinOsc.ar(3.rand).range(0,1);
		DelayC.ar(LFSaw.ar(m * freq/2), 0.02, freq.reciprocal.rand * lfo);
	}.dup(nvoices1);

	var osc2 = {
		var m = 2**(detune2/1200).rand2;
		var lfo = SinOsc.ar(3.rand).range(0,1);
		DelayC.ar(LFSaw.ar(m * freq), 0.02, freq.reciprocal.rand * lfo);
	}.dup(nvoices2);

	var snd = BLowPass4.ar(osc1, 800, 0.5) + osc2 / 4;
	Out.ar(out, Splay.ar(snd*adsr) * amp);
}).add;
)

// Play chord seq
(
Pbind(
	\instrument, \simpSaw4,
	\freq, Pseq(~crdArray+24, inf).midicps,
	\dur, 2.5*Pseq([1, 0.375, 0.625, 1, 1], 1),
	\sustain, 2.5*Pseq([1, 1, 0.625, 1, 1], 1)
).play(quant: 1);
)

// Now Let's hear each version one at a time:
(
{
	~list = [\simpSaw1, \simpSaw2, \simpSaw3, \simpSaw4];
	4.do{
		arg i;
		Pbind(
			\instrument, ~list[i],
			\freq, Pseq(~crdArray+24, inf).midicps,
			\dur, 2.5*Pseq([1, 0.375, 0.625, 1, 1], 1),
			\sustain, 2.5*Pseq([1, 1, 0.625, 1, 1], 1)
		).play(quant: 1);
		(2.5*[1, 0.375, 0.625, 1, 1].sum + 0.125).wait;
	};
}.fork;
)

///////////
// my version

(
SynthDef(\voicesaw, {|out=0,freq, gate=1 amp=0.1 caramp=0.2|
	var nvoices1 = 5, nvoices2 = 7;
	var detune1 = 12, detune2 = 8;
	var adsr = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);

	var osc1 = {
		var m = 2**Rand((detune1/ -1200), (detune1/1200));
		var n = 2**(detune1/1200).rand2;
		var lfo = SinOsc.ar(3.rand).range(0,1);
		var saw = LFSaw.ar(m * freq/2);
		DelayC.ar(saw, 0.02, ( freq * n ).reciprocal * lfo) + (saw*caramp);
	}.dup(nvoices1);

	var osc2 = {
		var m = 2**Rand((detune2/ -1200), (detune2/1200));
		var n = 2**(detune2/1200).rand2;
		var lfo = SinOsc.ar(3.rand).range(0,1);
		var saw = LFSaw.ar(m * freq);
		DelayC.ar(saw, 0.02, (freq * n).reciprocal * lfo) + ( saw*caramp );
	}.dup(nvoices2);

	var snd = BLowPass4.ar(osc1, \lpf.kr(800), 0.5) + osc2 / 4;
	Out.ar(out, Splay.ar(snd*adsr) * amp);
}).add;
)
(
Pbind(
	\instrument, \voicesaw,
	\freq, Pseq(~crdArray+24, inf).midicps,
	\dur, 2.5*Pseq([1, 0.375, 0.625, 1, 1], 1),
	\sustain, 2.5*Pseq([1, 1, 0.625, 1, 1], 1)
).play(quant: 1);
)


Pdefn(\chords, Pstep(Pseq([0,4,1,5],inf),8));
(
Pdef(\zed, 
	Pbind(
		\instrument, \voicesaw,
		\degree, Pseq([
			[0,3,7],
			[0,3,7,11],
			[0,3,7,9],
		],inf) + Pseq([
			Ptuple(Prand([0,12])!3)
		],inf),
		\mtranspose, Pdefn(\chords),
		\lpf, 4000,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(
			3.collect { arg idx;

				Pbind(
					\instrument, \voicesaw,
					\degree, Prout({ arg ev;
						var str = Pseq([
							[0,3,7],
							[0,3,7,11],
							[0,3,7,9],
						],inf) + (idx*12);
						str = str.stutter(5).asStream;
						inf.do {
							ev = str.next(ev).choose.postln.yield;
						};
					}),
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,1.1) ],
						[ Env.adsr(1.1,0.1,0.8,0.1) ],
					],inf),
					\octave, 3,
					\mtranspose, Pdefn(\chords),
					\lpf, 4000,
					\dur, Pwhite(0.1,7.4).stutter(10),
					\amp, 0.1,
				)
			};
		)
		
	])
)).play;
);
Pdef(\part).clear;


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vipere/rocksteady.flac'),
			\pos, 5.3,
			\legato, 1,
			\dur, Pseq([0.3,0.7],inf)*2,
			\gain, 1/2,
			\out, BusDef(\sendbus1, \audio),
		),
		Ppar(
			3.collect { arg idx;

				Pbind(
					\instrument, \voicesaw,
					\degree, Prout({ arg ev;
						var str = Pseq([
							[0,3,7],
							[0,3,7,11],
							[0,3,7,9],
						],inf) + (idx*12);
						str = str.stutter(5).asStream;
						inf.do {
							ev = str.next(ev).choose.postln.yield;
						};
					}),
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,1.1) ],
						[ Env.adsr(1.1,0.1,0.8,0.1) ],
					],inf),
					\octave, 3,
					\mtranspose, Pdefn(\chords),
					\lpf, 4000,
					\dur, Pwhite(0.1,7.4).stutter(10),
					\amp, 0.1,
					\out, BusDef(\sendbus1, \audio),
				)
			};
		)
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('loop/drinkmilk.flac'),
			\pos, 0,
			\legato, 1,
			\dur, Pseq([0.3,0.7],inf)*2,
			\gain, 1/2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \voicesaw,
			\note, Prand([8,11,10],inf),
			\legato, 0.3,
			\dur, Prand([1,1.5,4,3],inf),
			\octave, 6,
			\lpf, 10000,
			\amp, 0.1/2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \default,
			\note, 
			Prand([
				Pseq([0,3],21),
				Pseq([0,8],21),
			],inf),
			\legato, 0.3,
			\dur, Prand([1/16],inf),
			\octave, 6,
			\lpf, 10000,
			\amp, 0.1/2,
			\isRest, Pseq([
				Prand([
					Pseq([
						0.71
					],7),
					Pseq([
						1
					],4),
					Pseq([
						0
					],31),
					Pseq([
						0
					],11),
					Pseq([
						0
					],7),
					
				],1),
			],inf).coin.not,
			\out, BusDef(\sendbus1, \audio),
		),
		NoteTimeline(\melo).asPattern,
		Ppar(
			3.collect { arg idx;

				Pbind(
					\instrument, \voicesaw,
					\degree, Prout({ arg ev;
						var str = Pseq([
							[0,3,7],
							[0,3,7,11],
							[0,3,7,9],
						],inf) + (idx*12);
						str = str.stutter(5).asStream;
						inf.do {
							ev = str.next(ev).choose.postln.yield;
						};
					}),
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,1.1) ],
						[ Env.adsr(1.1,0.1,0.8,0.1) ],
					],inf),
					\octave, 3,
					\mtranspose, Pdefn(\chords),
					\lpf, 4000,
					\dur, Pwhite(0.1,7.4).stutter(10),
					\amp, 0.1,
					\isRest, true,
					\out, BusDef(\sendbus1, \audio),
				)
			};
		)
		
	])
)).play;
);

(
OSCdef(\test, {|msg, time, addr, recvPort| 
	//[\unmatching, msg].postln;
	~bins = msg.drop(1);

}, '/imgsnd/hist', n); // def style

OSCdef(\splitmean, {|msg, time, addr, recvPort| 
	[\unmatching, msg].postln;
	~split = msg.drop(1);
	ProtoDef(\rdn).proxy.set(\delay, ~split[0]/122455);
	ProtoDef(\rdn).proxy.set(\delay2, ~split[2]/255);
	ProtoDef(\rdn).proxy.set(\shift, ~split[1]-133/100);
	ProtoDef(\rdn).proxy.set(\shift2, ~bins[1].explin(10,100000,0.001,1)-1);

}, '/imgsnd/splitmean', n); // def style

)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \voicesaw,
			\note, Pseq([
				Pwhite(0,24),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,2.1) ],
			],inf),
			\legato, Pwhite(0.8,3),
			\dur, Pwhite(0.2,12),
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);

(
Pdef(\melo1, 
	Pbind(
		\instrument, \voicesaw,
		\adsr, Pseq([
			[ Env.adsr(0.3,0.1,0.8,1.1) ],
		],inf),
		\amp, 0.05,
		//\out, BusDef(\sendbus1, \audio),
	)
);
);
NoteTimeline(\melo, Pdef(\melo1)).edit
NoteTimeline(\melo).play;



/////////////////////////////


(
SynthDef(\gregrain, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([

				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,1,
				1,1,0,1, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \gregrain,
			\mbufnum, BufDef.mono('loop/lovin.flac'),
			\pos, ~pmodenv.(Pseq([0,4,1,10],1), 1).loop,
			\gdur, 0.1,
			\pitch_stretch, 1,
			\octave, 4,
			\note, Pseq([
				0,4,2,1,
			],inf),
			\dur, 1,
			\gain, 1,
		)
		
	])
)).play;
);
