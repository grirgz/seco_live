// an Editor is not a gui, it is a holder of a value
(
	n = NumberEditor(2.3,[0,10]);
	n.value = 5.6;
	n.asCompileString.postln;
	5.6

)

// its gui is separate
(
	//note that the .gui message returns a NumberEditorGui
	n = NumberEditor(440.0,\freq).gui;
	n.dump;

)

(
	// so make sure you get the NumberEditor
	n=NumberEditor(440.0,\freq);
	n.gui;
	n.dump;

)


// controlling the display size in various ways
(
	Sheet({ arg f;
		f.startRow;
		NumberEditor(440.0,\freq).gui(f); // default
		f.startRow;
		NumberEditor(440.0,\freq).smallGui(f); // smallGui never has slider
		f.startRow;
		NumberEditor(440.0,\freq).gui(f,nil, false); //use gui,nil bounds, slider: false
		f.startRow;
		NumberEditor(440.0,\freq).gui(f,nil, true,false); //use gui,nil bounds, box: false
	
		f.startRow;
		NumberEditor(440.0,\freq).gui(f,60@10,true); // slider 60 by 10
		f.startRow;
		NumberEditor(440.0,\freq).gui(f, 200@40, true); // slider+box 200 by 40
		// it considers 200@40 big enough to do its default size
	
	
		f.startRow;
		NumberEditor(440.0,\freq).smallGui(f);
		NumberEditor(440.0,\freq).smallGui(f);
		NumberEditor(440.0,\freq).smallGui(f);
		NumberEditor(440.0,\freq).smallGui(f);
	
		f.startRow;
		NumberEditor(440.0,\freq).gui(f,20@100,true);	// verticle, with slider
		NumberEditor(440.0,\freq).gui(f,20@100,true);	// verticle, with slider
	})

)

(
	Instr(\monosynth,{ arg gate=0.0,freq=440.0,ffreq=500,rq=0.1,width=0.3;    var amp;    amp = Latch.kr(gate,gate);
    RLPF.ar(        Pulse.ar(freq,width),        ffreq,        rq )
    * EnvGen.kr(Env.adsr,gate,amp)
});
Patch(\monosynth,[    MIDIGatePlayer.new,    MIDIFreqPlayer.new ]).gui

)




// BSpline
(
	b = BSpline([ [ 0, 2.275 ], [ 1, 1 ], [ 2.5102880658436, 3.1 ], [ 4, 4 ] ], 2.0, false);
b.gui(nil,1000@300);
)
({    PinkNoise.ar * SplineGen(b).kr(doneAction:2)}.play)


// Linear(
b = LinearSpline( Array.fill(60,{ arg i; [ i,1.0.rand ] }) );
b.gui(nil,1200@300);

)
({    PinkNoise.ar * SplineGen(b).kr(doneAction:2)}.play)

(
	y = BSpline([ [0,0],[1,1],[2,-1]  ], 2.0,true);
y.gui;

{    SplineOsc(y,0,true).ar(200) * 0.2 }.play

)
