Veco.

Main.version
a = MIDIOut(0)
a.noteOn(0,6, 0x0f)
(
var n = 2, baseFreq = 45.midicps;
var lsin, rsin, arg1, arg2, sig;
var bus, busIndex, scale, freq, freqIndex, amp;
var responder;

scale = Scale.nikriz.ratios * baseFreq;

bus = Bus.control( s, 2 * n  );
bus.setn( { 1.0.rand2 } ! ( 2 * n ) );
busIndex = bus.index;

freq = Bus.control( s, n );
freqIndex = freq.index;

responder = OSCFunc({ | id |
	freq.setAt( id[2] , scale.choose * 1.rrand( 3 ) );
},'/tr', s.addr);

CmdPeriod.doOnce { [ bus, freq, responder ].free; };

n.do {|i|
	freq.setn( { scale.choose  * rrand( 1, 3) } ! n );
	{
		#arg1, arg2 = In.kr( 2 * i +  busIndex, 2 );

		#lsin, rsin = SinOsc.kr( [ arg1, arg2 ], { 2.0.rrand(20.0) } ! 2  * [ arg2, arg1 ] ); 

		sig = Formant.ar( 
			LFNoise0.kr( 0.05, 2.5, 7) * arg1, 
			arg2,
			500.0.rrand(700) 
		);

		ReplaceOut.kr( 2 * i  + busIndex, [ rsin, lsin ] );

		sig = Pluck.ar( 
			BrownNoise.ar(0.5), 
			sig, 
			0.025, 
			freq.kr( 1, i ).reciprocal, 
			3.7
		) * 0.6;

		amp = Line.kr( dur: rrand( 1.0, 20.0) ) * max( 0, LFNoise1.kr( 0.05, 0.6, 0.4 ) ) ;
		sig =  sig * amp;
		SendTrig.kr( amp <= 0, i, i );

		Pan2.ar( sig, 0.8.rand2 )
	}.play
}
)

(

SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, t_trig=1,
		arg1=100, arg2=200, decay=0.01, flag=0.1, pluckdecay=3.1;
	var sig;
	sig = Formant.ar( 
		LFNoise0.kr( 0.05, 2.5, 7) * arg1, 
		arg2,
		500.0.rrand(700) 
	) * Trig.kr(t_trig, decay);


	sig = Pluck.ar( 
		BrownNoise.ar(0.5), 
		sig, 
		0.025, 
		freq.reciprocal.lag(flag), 
		pluckdecay
	) * 0.6;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.4,0.1,0.8,7.1)),t_trig,doneAction:0);
	EnvGen.ar(Env.adsr(0.4,0.1,0.8,7.1),gate,doneAction:2);
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

~baseFreq = 220;
~scale = Scale.nikriz.ratios * ~baseFreq;
//~scale = Scale.dorian.ratios * ~baseFreq;
//~scale = Scale.minor.ratios * ~baseFreq;

8.do { arg nn;
	var nnn = nn+1;

Pdef(\plop+++nn, Pmono(
	//\instrument, \plop,
	\plop,
	\arg1, 100,
	\arg2, Pwhite(40,4000),
	\arg2, 3000,
	\decay, Pwhite(0.01,0.1),
	\decay, 0.01*nnn,
	\decay, 0.1/nnn,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,3.3) ],
	],inf), 
	\freq, Pwhite(100,1500),
	\freq, Prand([100,1500,200,500,100],inf) * 0.7,
	\freq, Prand([100,1500,200,500,100],inf) * 1,
	\freq, Prand([100,1000,200,500,300,1000],inf) * 1,
	\freq, Pseq([100,1500,200,500,2000,100,250],inf),
	\freq, Pseq([
		100,1500,200,500,
	],inf),
	\freq, Pseq([
		100,1500,200,500,
		100,1500,200,500,
		100,1500,200,500,
		1000,100,1000,
	],inf) * Pseq([1.7,0.2,0.7,0.5],inf) * 1.0,
	\freq, Pseq([
		90,250,470,
		110,150,270,

		90,150,270,
		110,750,270,
	],inf) * Pseq([
		3,1,4,1.5,
		6,4,0.8,1.5,
	],inf) * Pseq([1,0.8,0.5,1.2],inf).stutter(32),
	\freq, Pseq([
		//Pser([100,1000],16),
		//Pser([100,2000],16),
		//Pser([200,1000*nnn],16),
		Pser([200,100]*nnn,16),
		Pser([200,400]*nnn,16),
		Pser([20,40]*nnn,16),
		//100*nnn
	],inf),
	\freq, Pseq([
		//200*log(nnn+1)
		Pser([Pfuncn({~scale.foldAt(nn)},1)],inf) * Pseq([1,2,1/6],1).stutter(16),

		Pser([200,100]*nnn,16),
		Pser([200,400]*nnn,16),
		Pser([20,40]*nnn,16),

		Pser([log(nnn+7)*200],32),
	],inf),
	\flag, Pseq([
		Prand([

		//Pser([1,0.1,1,0.1],16),
		//Pser([1,0.1,1,0.1]/2+0.3,16),
		0.05*nnn,
		0.1,
		//0.7*nnn,
		],inf)
		//Pser([1.12],16),
		//Pser([0.08],16),

	],inf),
	\lag, Pseg(Pseq([0,0.31],inf), 8)*nn,
	\arg2, Pkey(\freq),
	\arg1, Pkey(\freq),
	\sustain, 0.4,
	\dur, Pwhite(0.1,0.4) * 0.8,
	\dur, Pseq([0.5,1,1,0.5],inf) * 0.2,
	\dur, Pseq([0.5,1,1,0.5],inf) * Pseg(Pseq([3,0.2,0.1],inf), 16),
	\amp, min(1,Pkey(\dur)*3) * 1.7
)).play;

}
)

log(2)

MIDIClient.init
MIDIClient.restart
MIDIClient.sources
NdefGui
VecoLib.load_lib
Veco.force_init

//load the Synth

(
k = ControlSpec(5, -128, \lin);
e = ControlSpec(0.01, 0.5, \exp);
p = ControlSpec(65536, 0.25, \exp);
c = ControlSpec(-23, 0, \lin);
h = ControlSpec(1/2, 2/1, \exp);

SynthDef(\Motorklang, {arg speed=0.0, time=0.0, rpm=0.0, t_tr=1;
	var sig, speedch, rpmch;
		speedch = EnvGen.kr(Env([0, speed], [time]), t_tr);
		rpmch = EnvGen.kr(Env([0, h.map(rpm/6000);], [time]), t_tr);
		sig = Mix.fill(8, {arg i;
			var freq, aspeed, env, curve1, curve2, phase;
			curve1 = k.map(speedch).max(1);
			aspeed = p.map(speedch/75) * curve1;
			env = e.map(speedch/75);
			curve2 = c.map(speedch/75);
			freq = 300 + (i/4);
			phase = i/8;
			Mix.fill(32, {arg i;
				var freqsq;
				freqsq = ((((i+1)*freq).cpsmidi*rpmch) - (freq.cpsmidi*rpmch-freq.cpsmidi)).midicps.min(22050);
				SinOsc.ar(freqsq, 0, 0.1/(i+1))
				*
				EnvGen.ar(Env.perc(env, 1-env, 1, curve2),
					Impulse.ar(freq*(1+i)/aspeed, phase), timeScale: 1/(freq*(1+i)/aspeed));
				});
			});
		Out.ar(0, Mix.new(sig) ! 2);
	}).load(s);
)

//Test it
(
x = Synth(\Motorklang);
x.set(\speed, 40, \rpm, 3000, \time, 0, \t_tr, 1);
)
x.free

//A simple interface to check the sound limits of the engine

(
x = Synth.newPaused(\Motorklang);
w = Window.new("Motor", Rect(150, 266, 950, 300)).front;
q = StaticText(w, Rect(835, 20, 100, 100));
y = StaticText(w, Rect(838, 140, 100, 100));
q.string = "km/h";
y.string = "rpm";
c = NumberBox(w, Rect(830, 90, 40, 20));
n = NumberBox(w, Rect(830, 210, 40, 20));
b = ControlSpec(0, 75, \linear, 0.1);
m = ControlSpec(0, 6000, \linear, 1);
a = Slider(w, Rect(50, 75, 700, 50)).value_(0).action_({
		x.run.set(\speed, b.map(a.value), \t_tr, 1);
		c.string_(b.map(a.value).asString)});
d = Slider(w, Rect(50, 200, 700, 50)).value_(0).action_({
		x.run.set(\rpm, m.map(d.value), \t_tr, 1);
		n.string_(m.map(d.value).asString)});
c.value = 0;
n.value = 0;
)

(

// a slightly modified version of the excellent example patch by James Harkins.

// I added some grid lines for the samples, an adjustable sampling rate, and changed some colors.

// Jascha Narveson



var screen = Window.screenBounds,

	height = (screen.height - 120).asInteger,

	width = (screen.width - 120).asInteger,

win = Window(\aliasing, Rect.aboutPoint(screen.center, width / 2, height / 2 + 60)).background_(Color.white),

	sinPts = 400, sampPts = 20, sr,

	freq = 1, fsl,

	sinColor = Color.red, sampColor = Color.blue, lineColor = Color.grey;



win.drawHook = {

	var pt;

	pt = Point(0, height/2);

	Pen.color_(sampColor)

		.moveTo(pt);

	(1..sampPts).do { |x|

		Pen.moveTo(pt);

		pt = Point(x * (width / sampPts), sin(x * freq / sampPts * 2pi).linlin(-1, 1, height, 0));

		Pen.lineTo(pt).stroke

			.fillRect(Rect.aboutPoint(pt, 3, 3));

	};



	Pen.color_(sinColor)

		.moveTo(Point(0, height/2));

	(1..sinPts).do { |x|

		Pen.lineTo(Point(

			x * (width / sinPts),

			sin(x * freq / sinPts * 2pi).linlin(-1, 1, height, 0)

		));

	};



	Pen.stroke;



	Pen.color_(lineColor);

	(1..sinPts).do({|x|

		var xpos = x * (width / sampPts);

		Pen.moveTo(Point(xpos, 0));

		Pen.lineTo(Point(xpos, height));

		Pen.stroke;

	});



};



fsl = EZSlider(

	win,

	Rect(5, height + 10, width-10, 20),

	"freq of input wave (red):",

	ControlSpec(1, 40, 'lin', 0, 20),

	{|slider| freq = slider.value; win.refresh },

	1,

	labelWidth: 200,

	initAction: true

);



sr = EZSlider(

	win,

	Rect(5, height + 30, width-10, 20),

	"samp rate (output wave in blue):",

	ControlSpec(1, 44, 'lin', 1, 20),

	{|slider| sampPts = slider.value; win.refresh },

	1,

	labelWidth: 200,

	initAction: true

);

win.front;

)
(
var screen = Window.screenBounds,
	height = (screen.height * 0.8).asInteger,
	width = (screen.width * 0.8).asInteger,
	win = Window(\aliasing, Rect.aboutPoint(screen.center, width / 2, height / 2 + 20)),
	sinPts = 400, sampPts = 20,
	freq = 1, fsl,
	sinColor = Color.red, sampColor = Color.black;

win.drawHook = {
	var pt;
	pt = Point(0, height/2);
	Pen.color_(sampColor)
		.moveTo(pt);
	(1..sampPts).do { |x|
		Pen.moveTo(pt);
		pt = Point(x * (width / sampPts), sin(x * freq / sampPts * 2pi).linlin(-1, 1, height, 0));
		Pen.lineTo(pt).stroke
			.fillRect(Rect.aboutPoint(pt, 3, 3));		
	};

	Pen.color_(sinColor)
		.moveTo(Point(0, height/2));
	(1..sinPts).do { |x|
		Pen.lineTo(Point(
			x * (width / sinPts),
			sin(x * freq / sinPts * 2pi).linlin(-1, 1, height, 0)
		));
	};
	Pen.stroke;
};

fsl = EZSlider(win, Rect(5, height+10, width-10, 20), "freq:", [1, 20], { |view| freq = view.value; win.refresh }, 1, initAction: true);

win.front;
)


MIDIIn.connectAll;
MIDIOut.connectAll;
MIDIClient.sources;
MIDIIn.findPort ("Launchpad")
~launchpad_device_id = MIDIIn.findPort ("Launchpad S-Launchpad S MIDI 1", "Launchpad S-Launchpad S MIDI 1").uid
~icon_device_id = MIDIIn.findPort ("iCON iControls V2.00-iCON iControls V2.00 MIDI 1", "iCON iControls V2.00-iCON iControls V2.00 MIDI 1").uid
MIDIClient.destinations;
~launchpad_in_device_endpoint = MIDIEndPoint("Launchpad S-Launchpad S MIDI 1", "Launchpad S-Launchpad S MIDI 1")
MIDIOut(0).connect( MIDIClient.destinations.detectIndex { arg x; x.device == "Launchpad S-Launchpad S MIDI 1" } ) // good

VecoLib.load_lib
Veco.force_init



MIDIClient.list
MIDIIn.connect(0, ~launchpad_device_id)
MIDIIn.connect(0, ~icon_device_id)
MIDIOut.connect(~launchpad_in_device_id, 0)
MIDIIn.connect( ~launchpad_in_device_id, 0)
MIDIOut(0).connect(), MIDIClient.destinations.detect { arg x; x.device == "Launchpad S-Launchpad S MIDI 1" }.uid ).connect
MIDIOut(0, 10).connect
MIDIOut.newByName("Launchpad S-Launchpad S MIDI 1", "Launchpad S-Launchpad S MIDI 1").connect(2)
MIDIOut(0,~launchpad_in_device_endpoint.uid)
MIDIClient.destinations.detect { arg x; x.device == "Launchpad S-Launchpad S MIDI 1" }.uid

1
kkkjkk

(

q = q ? ();


q.numChans = 2; 


// add a sound source

ProxyChain.add(

\dust, \mix -> { |dens=20, dustdec=0.02, dustfreq= 600| 

Ringz.ar(Dust.ar(dens).lag(0.0001), dustfreq, dustdec)  ! 2

}

);


// an association with \filter becomes a filter,

// and creates a wet/dry balance on the output.

// several funcs can be added as key1, func1, key2, type -> func2, etc.

ProxyChain.add(	

\ringmod, \filter -> { |in, randrate=5| 

//in.asArray[0] // force mono inputs
in

* SinOsc.ar(LFNoise0.kr([randrate, randrate]).exprange(300, 3000)).sum 

}, 

\dist, \filter -> { |in, drive=10, amp=0.2| 
	//(in.asArray[0]
	(in
	* drive).clip2(0.5) * amp }

);

// an association with \filterIn also becomes a filter,

// but creates the wet/dry balance control on the filter input, 

// on on the output like \filter. this can be useful for delays, reverbs etc.

ProxyChain.add(

\riseComb5, \filterIn -> { arg in, delay = 0.023, dlDrift = 0.02, spread=0.5, mypan=0, 

decayRise=0.5, decayFall=100;

var delayscales = 2 ** ((0 .. q.numChans - 1) * 2 / (q.numChans - 1) - 1 * spread); 

var dels = delayscales.scramble.collect { |dscale| 

var timedrift = LFDNoise3.kr(0.3, dlDrift, 1) * dscale;

var ampcomp = (20 * decayRise).dbamp * (decayFall ** -0.25);

var combs; 

in = in.asArray[0] * ampcomp.lag(0.2);

combs = (decayFall * [ 1, decayRise]).collect { |decay| 

CombL.ar(in, 1, delay * dscale, decay * delay) 

};

combs[0] - combs[1];	// combs come in slowly, like formlet. 

};

Splay.ar(dels, 1,1,mypan);

}, 

\ampFin, \filter -> { |in, drive=1, ampLimit=1, lAmp=1| 

Limiter.ar(in * drive, ampLimit) * lAmp;

}

);


// add specs for the controls used (for NodeProxyEditor).

Spec.add(\dens, [0.1, 1000, \exp]);

Spec.add(\dustamp, [0, 1, \amp]);

Spec.add(\dustdec, [0.0001, 0.1, \exp]); 

Spec.add(\dustfreq, \freq); 


Spec.add(\dt, [0.001, 0.2, \exp]); 

Spec.add(\dc, [0.01, 100, \exp]); 


Spec.add(\drive, [1, 100, \exp]); 


Spec.add(\spread, [0, 1, \amp]); 

Spec.add(\decayRise, [0, 0.9, \amp]); 

Spec.add(\decayFall, [1, 1000, \exp]); 

Spec.add(\dlDrift, [0, 0.1, \amp]); 
Spec.add(\mypan, \bipolar.asSpec); 


s.boot;

)

// the functions can be sources (func, \mix -> func) 

// or	 filters (\filter -> func, \filterIn -> func)

(

	c = ProxyChain(\alpha2, [\dust, \ringmod, \dist, \riseComb5, \test]);

	c.play;// play the proxy

	g = c.gui(22);		// make a gui for it with 12 slots - see ProxyChainGui


)

ProxyChain(\alpha2).proxy.set(\delay, 1)


// these methods are passed through to the proxy:

c.play;

c.stop;

c.playN;

c.end(2);



*from(proxy, slotNames)make a proxychain from an existing N	odeProxy or Ndef.

Ndef(\bla).ar(2);

ProxyChain.from(Ndef(\bla), [\dust, \ringmod, \dist, \riseComb5, \test]);

ProxyChain(\bla).play;

ProxyChain(\bla).add(\dust);


ProxyChain.all;


add(key, wet)add a sou	nd or filter function, wet is dry/wet balance


c.add(\dust, 0.123);

c.add(\dust, 0.2);

c.add(\ringmod, 0.5);

c.add(\dist, 1);



// the automatically generated mix/wet balance names are

// "mix" for sources and "wet" for filters, with an added 

// index of 10, 20, 30, etc. 


ProxyChain(\xyz, [

	\dust, // the first node is a source, so "mix", and here: "mix10",

	\ringmod, // filters become "wet", so here, "wet20"

	\dist// and "wet30";


]);



c.proxy.fadeTime = 	2;

c.add(\riseComb5, 0.2);// \filterIn not show correctly in NodeProx	yEditor yet.


// add a local version of a source -

// this overrides the global version of \dust.

(

	c.add(\dust, nil, \mix -> { |dens=20, dustdec=0.02, dustfreq= 600| 
	
	Ringz.ar(Dust.ar(dens).lag(0.0001), dustfreq * [0.62, 1, 1.62], dustdec).mean 

});


)

c.sources.postcs;

c.sources.put(\dust, nil);// back to global dust

c.add(\dust);

c.sources.postcs;


remove(ke	y)remove a sound or filter function.

c.remove(\dist);// nodemap remo		ves settings as well, so ...

c.remove(\ringmod);

c.remove(\riseComb5);// sometimes misses current value - why?


c.slotNames;// all slotnames t		hat are available, in the order they are in;

c.slotsInUse;// which on	es are playing now?


c.remove(\dust);



gui(name, buttonList, nSliders)

make a ProxyChainGui window for controlling the slots, and possible additional functions.


// by default, buttonList nil is replaced with control buttons for all slots.

c.gui(20);


// if specified, can be friendlier

(

	g = c.gui(20,
	
	[ 
	
	[ \generators, 	\label  ],  // a label only

[ \dust, \slotCtl, 0.25  ], // a control for a slot, starting level


[ '1 > 1', \label  ],  

[ \ringmod, \slotCtl  ], // 0 - dry  by default

[ \dist, \slotCtl, 1  ], // 1 - all wet


[ '1 > 5', \label  ],  

[ \riseComb5, \slotCtl  ], 

[  ],

// extras:

// e.g. an editor with more space for controls

[\phatEdit, \extra, { c.makeEdit('Test', 40)  } ],

// or maybe bigger buttons play, end buttons

[\play, \extra, { c.playN  } ], 	

[\end, \extra, { c.end(2, true)  } ],

]

)


)






60/4.0
(

	Spec.add(\dens, [1, 1000, \exp]);

	Spec.add(\ring, [0.0001, 100, \exp]);


	a = Ndef(\a, { |freq=300, dens=10, ring = 0.03, amp= 0.25| 
	
	Ringz.ar(Dust.ar(dens ! 2, (1/dens.max(1)).sqrt * amp), (freq * [1.01, 0.99]).lag(0.2), ring) 

}).play;


// make a preset for Ndef(\a)

// - stored by the Ndef's name in NdefPreset.all

z = NdefPreset(Ndef(\a));


w = Window("NdefPreset test", Rect(200, 200, 420, 250)).front;

w.addFlowLayout;

// a gui for the NdefPreset

g = ProxyPresetGui(z, parent: w);

// and one for the Ndef

b = NdefGui(a, 8, parent: w);


)

//create buffer. I want the equation z = 2*(((x/100)**2) + ((abs(sin(10*y))/50)**(1/3)))-1
//over a 100 by 50 area

//2d to 1d conversion follows index= y*rowlength+ x
(
var width= 100; //= num cols
var height=50; //=num rows, though indexing bottom to top; i.e., standard Cartesian co-ordinates

a=Array.fill(width*height,{arg i; 
var xnow, ynow, x, y; 

xnow= i%width;
ynow= (i-xnow).div(width);

x=xnow/width;
y=ynow/height;

2*(((x)**2) + ((abs(sin(10*y)))**(1/3)))-1

});


b.sendCollection(a, 1);
)
b=Buffer.sendCollection(s, a, 1);


//test scanning; you can't move fast enough... scan controls should also be audio rate!
{WaveTerrain.ar(b.bufnum,MouseX.kr(0.0,1.0), MouseY.kr(0.0,1.0),100,50) ! 2}.play

(
Ndef(\wt, {
	WaveTerrain.ar(b.bufnum,LFSaw.ar(MouseX.kr(0.0,200.0)).abs, SinOsc.ar(MouseY.kr(0.0,100.0)).abs,100,50) ! 2
}).play

)

(
Ndef(\wt, {
	var mod;
	var sig;
	var pos1;
	pos1 = MouseY.kr(1,120);
	mod = SinOsc.ar(LFSaw.kr(2+LFNoise0.kr(10).range(0,10)).range(10,pos1)).range(0,1);
	sig = WaveTerrain.ar(b.bufnum, mod, SinOsc.ar(mod.range(0,10)),100,50) ! 2;
	sig = RLPF.ar(sig, MouseX.kr(10,10000, \exponential), 0.3);
}).play

)

(
Ndef(\wt, {
	var mod;
	var sig;
	var pos1;
	pos1 = MouseY.kr(1,120);
	mod = SinOsc.ar(LFSaw.kr(2+LFNoise0.kr(10).range(0,10)).range(10,pos1)).range(0,1);
	sig = WaveTerrain.ar(b.bufnum, mod, SinOsc.ar(mod.range(0,10)),100,50) ! 2;
	sig = RLPF.ar(sig, MouseX.kr(10,10000, \exponential), 0.3);
}).play

)


(
Ndef(\wt, {
	var mod;
	var sig;
	var pos1;
	var chain;
	pos1 = MouseY.kr(1,120);
	pos1 = 100;
	mod = SinOsc.ar(LFSaw.kr(2+LFNoise0.kr(10).range(0,10)).range(10,pos1)).range(0,1);
	sig = WaveTerrain.ar(b.bufnum, mod, SinOsc.ar(mod.range(0,10)),100,50);
	sig = RLPF.ar(sig, MouseX.kr(10,10000, \exponential), 0.3);

	    chain = FFT(LocalBuf(2048), sig);
	    chain = PV_MagFreeze(chain, MouseY.kr > 0.5 );
		//chain = PV_BinScramble(chain, MouseX.kr , 0.1, MouseY.kr > 0.5 );

		sig = 0.8 * IFFT(chain);


		sig = Squiz.ar(sig, MouseX.kr(1, 10, 1), zcperchunk: MouseY.kr(1, 10), mul:0.1);

		sig = sig ! 2;
		sig;
}).play

)


{var n= 1024; WaveletDaub.ar(Saw.ar(MouseY.kr(50,10000, 'exponential'),0.5), n, MouseX.kr(0,n)) ! 2}.play

BufDef(\moeten, "voices/02_moeten.flac");
(
	Ndef(\rah, {var n= 1024; 
		var sig;
		var chain;
		var posy = MouseX.kr(0.1,2);

		//sig = PlayBuf.ar(2, BufDef(\moeten), 1, loop:1);
		sig = PlayBuf.ar(2, BufDef(\moeten), MouseX.kr(0.01,3), loop:1);
		//sig = PlayBuf.ar(2, BufDef(\moeten),  SinOsc.kr(10*posy).range(0.1,2.7), loop:1);
		//sig = SinOsc.ar(200);
		//sig = WaveletDaub.ar(sig, n, MouseX.kr(0,n));
		chain = FFT(LocalBuf(2048), sig);
		//chain = PV_PhaseShift(chain, MouseX.kr(0,360));
	    chain = PV_MagFreeze(chain, MouseY.kr > 0.5 );
		//chain = PV_MagBelow(chain, MouseX.kr(0,60));
		//chain = PV_MagAbove(chain, MouseX.kr(0,60));
		//chain = PV_BinScramble(chain, MouseX.kr , 0.1, MouseY.kr > 0.5 );

		//chain = PV_PhaseShift(chain, LFNoise2.kr(1, 180, 180));
		sig = IFFT(chain);

		sig ! 2;
	}).play
)

(
	//trig with MouseY
	SynthDef("help-magFreeze2", { arg out=0, soundBufnum=2;
	    var in, chain;
	    in = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
	    chain = FFT(LocalBuf(2048), in);
	    chain = PV_MagFreeze(chain, MouseY.kr > 0.5 );
	    Out.ar(out, 0.1 * IFFT(chain).dup);
	}).play(s,[\soundBufnum, b]);

)


//LFNoise adds some drift to explore the landscape more
{WaveTerrain.ar(b.bufnum,SinOsc.ar(MouseX.kr(1,200,'exponential')).abs + LFNoise2.ar(2),SinOsc.ar(MouseY.kr(1,300,'exponential'),pi*0.5).abs,100,50) ! 2}.play





//change surface equation
(
var width= 100; //= num cols
var height=50; //=num rows, though indexing bottom to top; i.e., standard Cartesian co-ordinates

a=Array.fill(width*height,{arg i; 
var xnow, ynow, x, y; 

xnow= i%width;
ynow= (i-xnow).div(width);

x=xnow/width;
y=ynow/height;

(((cos(5*x+1.7))**3) - ((abs(sin(23*y)))**(1/3)))

});

b.sendCollection(a);
)





//change surface equation
(
var width= 100; //= num cols
var height=50; //=num rows, though indexing bottom to top; i.e., standard Cartesian co-ordinates

a=Array.fill(width*height,{arg i; 
var xnow, ynow, x, y; 

xnow= i%width;
ynow= (i-xnow).div(width);

x=xnow/width;
y=ynow/height;

(((1.3*(cos(rrand(1,2)*x+1.7))**2) - ((abs(sin(rrand(1.2,4.9)*y)))**(1/2)))).max(-1.0).min(1.0)

});

b.sendCollection(a);
)


s.quit

{ Formlet.ar(Impulse.ar(20, 0.5), 1000, 0.01, 0.1) }.play;

{ Formlet.ar(Blip.ar(XLine.kr(10,400,8), 1000, 0.1), 1000, 0.01, 0.1) ! 2 }.play;

(
// modulating formant frequency
{
    var in;
    in = Blip.ar(SinOsc.kr(5,0,20,300), 1000, 0.1);
    Formlet.ar(in, XLine.kr(1500,700,8), 0.005, 0.04) ! 2;
}.play;
)

(
// mouse control of frequency and decay time.
{
    var in;
    in = Blip.ar(SinOsc.kr(5,0,20,300), 1000, 0.1) ! 2;
    Formlet.ar(in,
        MouseY.kr(700,2000,1),
        0.005, MouseX.kr(0.01,0.2,1));
}.play;
)

(
// mouse control of frequency and decay time.
{
    var freq;
    freq = Formlet.kr(
        Dust.kr(10 ! 2),
        MouseY.kr(7,200,1),
        0.005, MouseX.kr(0.1,2,1)
    );
    SinOsc.ar(freq * 200 + [500, 600] - 100) * 0.2 ! 2
}.play;
)

(
SynthDef(\fatsaw,
	{
		arg freq=440, amp=0.3, fat=0.0033, ffreq=2000, atk=0.001, dec=0.3, sus=0.5, rls=0.1,gate=1;

		var f1,f2,f3,f4,synth;

		f1=freq-(freq*fat);
		f2=freq-(freq*fat/2);
		f3=freq+(freq*fat/2);
		f4=freq+(freq*fat);

		synth = LFSaw.ar([f1,f2,f3,f4],[0,0.001,0.002,0.004,0.008]);
		synth = synth * EnvGen.kr(Env([0,1,sus,0],[atk,dec,rls],'lin',2),gate,doneAction:0);
		synth=Splay.ar(synth,0.7);
		synth=RLPF.ar(synth,ffreq*Linen.kr(gate,0.1,0.4,0.2,0),0.4);
		Out.ar(0,synth*amp);
},[0.1,0.3,4,2]).add;
)
(
TempoClock.default = TempoClock.new(2);
fork{

	z = Synth(\fatsaw,[\gate,0,\ffreq,500,\fat,0.5]);

	a=Pseq([0,7,12,5],inf).asStream; // musical degrees
	c = Pseq([40,38,45,47],inf).asStream; // root midi notes
	e = Pseq([0.825,0.375,0.25,0.25],inf).asStream; // note durations
	f = Pseq([1000,1500,2000,2500],inf).asStream; // filter freq value

	0.1.wait;
	z.set(\gate,1);

	//set first root note
	d = c.next;

	8.do{

		// move filter freq once every 4 notes
		z.set(\ffreq, f.next);
		4.do {
			z.set(\gate,1);
			z.set(\freq,(a.next + d).midicps);
			x=[0.451,0.45,0.449].choose;
			x.wait;
			z.set(\gate,0);

			e.next.wait;
		};

		d = c.next;
	};
	2.wait;
	z.free;
};
)



/* 140103_1504 (pluck piece)



by Nathan Thomas

http://www.afternoondust.co.uk



This piece uses code from Bruno Ruviaro (pluck pattern), published on SCCode.org: 

http://sccode.org/1-4Vn



Don't forget to update the path to the audio sample on line 26.



Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License:

http://creativecommons.org/licenses/by-nc-sa/3.0/



*/



(

Server.default = s = Server.internal;

s.options.memSize = 655360;

s.options.sampleRate = 96000.000;

s.options.blockSize = 128;

)



s.boot;



c = Buffer.read(s, "insert/path/to/file/here/leaves_twigs_decode_004_edit.wav");



(

   SynthDef("playamp", { arg krBus;

       var sig, amp, trig, thresh;

       thresh = MouseX.kr((-15),(-60));

       sig = PlayBuf.ar(2,c,0.99,loop:inf);

       amp = Amplitude.kr(sig).ampdb;

       trig = amp >= thresh;

       Out.kr(krBus,trig);

    }).add;



   SynthDef("plucking", {arg amp = 1, freq = 440, decay = 5, coef = 0.1, krBus, outBus=0;

        var env, snd;

        env = EnvGen.kr(Env.linen(0, decay, 0), doneAction: 2);

        snd = Pluck.ar(

            in: Mix.new([WhiteNoise.ar(amp), SinOsc.ar(freq,0,amp)]),

            trig: Gate.ar(Impulse.ar(1),In.kr(krBus,1)),

            maxdelaytime: 0.1,

            delaytime: freq.reciprocal,

            decaytime: decay,

            coef: coef,

            mul: amp);

            Out.ar(outBus, [snd, snd]);

    }).add;



    SynthDef("playbuf", { arg outBus=0;

        var play;

        play = PlayBuf.ar(2,c,loop:inf);

        Out.ar(outBus,play);

    }).add;



    SynthDef("bass", {arg amp = 1, freq = 220, decay = 1, outBus=0;

        var env, snd, pan, env2, splay, phase;

        env = EnvGen.kr(Env.linen(1, decay, 1,1), doneAction: 2);

        phase = Array.fill(4, { do({ [0, 0.5, 0.7, 1].choose }) });

        snd = SinOsc.ar([freq, freq + phase],[0,phase],amp/4).sum * env;

        splay = Splay.ar(snd,0.4);

        Out.ar(outBus, splay);

    }).add;

)



z = Synth(\bass);



// Groups



(

    ~sources = Group.new;

    ~control = Group.after(~sources);

    ~bus1 = Bus.control(s,1);

    ~bus2 = Bus.audio(s,2);

)





x = Synth(\playamp,[\krBus,~bus1],~control); y = Synth(\playbuf);



// Pluck

(

    var dur;

    dur = Prand([0.2, 0.4, 0.8], inf);



    a = Pbind(

        \instrument, "plucking",

        \krBus, ~bus1,

        \scale, Scale.dorian,

        \degree, Prand([8, 17, 9, 7, 15, 12, 13, 1, 5, 14], inf),

        \coef, dur,

        \dur, dur,

        \amp, Pwhite(0.3, 0.6),

        \decay, 3

   ).play;

)



// bass



(

    b = Task({

    var delta, dur, note; 

    dur = Prand([10, 15], inf).asStream;

    note = Pwrand([145, 290], [0.8,0.2], inf).asStream;



    while {

            delta = dur.next;

            delta.notNil

        } {

            Synth(\bass,[freq: note.next,decay:4]);

            delta.yield;

        }

    }).play(quant:TempoClock.default.beats+1.0);

)





a.stop;

b.stop;

x.free;

y.free;

~sources.free;~effects.free;~bus1.free;



s.boot



//////////////////
// Ducking example
///////////////////

// Compander with
// low threshold (like 0.01)
// slopeBelow: leave at 1 (default)
// slopeAbove: small value (means input signal will be attenuated a LOT when control kicks in)
// clampTime and releaseTime: small (e.g., 0.1)
// but release time can be a bit more


/////////////////////////
// Kick and Low Synth Bass
/////////////////////////

(
Ndef(\plop,{
    var in, snd, control ;
    in = LPF.ar(Saw.ar(90*[0.990,1,1.0001]), 5500);
    control = Ringz.ar(
        in: LPF.ar(
            in: Impulse.ar(MouseY.kr(0,8).round(1)),
            freq: 30),
        freq: 30,
        decaytime: 0.15,
        mul: 7).tanh.sin*2;
    snd = Compander.ar(
        in: in,
        control: control,
        //thresh: 0.01,
        thresh: MouseX.kr(0.001,0.3),
        slopeBelow: 1,
        slopeAbove: 0.1,
        clampTime: 0.01,
        // longer release
        relaxTime: 0.1
    );
    Splay.ar([snd, control, snd])
}).play;
)



(

SynthDef(\aSynth, { |rel = 0, choose = 0, amp = 0|

    var klank, env;



    klank = Klank.ar(`[choose ! 12, {Rand(0.128, 0.7)} ! 12], BrownNoise.ar(0.7));

    env   = EnvGen.kr(Env.perc(0.01, rel), doneAction: 2);

    Out.ar(0, klank * env.dup * amp);

}).add;

)



(

{

    42.do{

        x = [70, 90, 120].choose;

        y = rrand(0.01, 5);

        // attack

        Synth(\aSynth, [\rel, y, \choose, x, \amp, 128e-6]);

        // resonance

        Synth(\aSynth, [\rel, 1, \choose, x, \amp, 128e-5]);

        y.wait;

    }

}.fork;

)


(
	w = Window("test", Rect(800, 200, 200, 100));
	w.layout = HLayout(
		        //n = NumberBox.new.fixedWidth_(60),
		        n = NumberBox.new::,
				        l = Slider.new.orientation_(\horizontal)

	);
	w.front;

)

// This gets the *appearance* I want.
n.fixedHeight = l.bounds.height;

