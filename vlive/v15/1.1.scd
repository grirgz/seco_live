(
Ndef(~name, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2;
	mod1 = \mod1.kr(1);
	mod2 = \mod2.kr(40);
	//mod2 = XLine.kr(8000,1,10);
	//mod2 = XLine.kr(40,5000,10);
	sig = SinOsc.ar(LFNoise1.kr([1,2,3,4,5,6] * mod1).range(50,mod2));
	sig = sig.sum;
	sig = sig / 2;
	sig = Pan2.ar(sig, pan, amp);
}).play;

//Ndef(~name+++\mod1, {  XLine.kr(Ndef(~name+++\mod1).kr,100,10)});
//Ndef(~name+++\mod2, { XLine.kr(Ndef(~name+++\mod2).kr,10000,10) });
Ndef(~name).map(\mod1, Ndef(~name+++\mod1));
Ndef(~name).map(\mod2, Ndef(~name+++\mod2));
~morph_to.(\mod2, { arg from;  {XLine.kr(from.value,500,10)}});
~morph_to.(\mod1, { arg from;  {XLine.kr(from.value,9,10)}});
//Ndef(~name+++\mod2, { XLine.kr(8000,1,10) });
);
// END
Ndef(\plop).stop
play{mean({|i|99**(-1-LFSaw.kr(i+1/180,1))*SinOsc.ar(i+1*55)}!48)!2}

(
~morph_to = { arg key, gen;
	Ndef(~name+++key, gen.value({Ndef(~name+++key).kr}));
}
)


1.asChar
1.asDigit.class
$1.class


"azer".asList.do { arg x; x.class.postln }

(
	//var keys = 4.collect { arg i; (i+1).asDigit }; // with a loop (start with $1)
	//var keys = [$1, $2, $3, $4, $a, $z]; // since keyboard shortcuts could be not digits
	var keys = "1234az".asList; // shorter

	var rkeys = IdentityDictionary.new;

	// make a dictionary for fast lookup
	keys.do { arg key, idx; 
		rkeys[key] = idx; 
	};

	w = Window.new("test", Rect(0,0,350, 120));
	v = CompositeView(w, Rect(0,0,350, 120)).background_(Color.black);
	b = keys.collect{|key, i| 
		Button(v, Rect(20, 20+(i*40), 100, 30))
			.states_([
				["State One", Color.black, Color.red],
				["State Two", Color.white, Color.black],
			])
	};
	v.keyDownAction = {arg view,char,modifiers,unicode,keycode;
		var idx;
		
		[char,modifiers,unicode,keycode].postln;
		idx = rkeys[char]; // get the button idx from the char
		if(idx.notNil) {
			b[idx].valueAction = 1 - b[idx].value; // toggle value;
		}

	};
	w.front;
)

(
	// with Qt Layouts


	//var keys = 4.collect { arg i; (i+1).asDigit }; // with a loop (start with $1)
	//var keys = [$1, $2, $3, $4, $a, $z]; // since keyboard shortcuts could be not digits
	var keys = "1234az".asList; // shorter

	var rkeys = IdentityDictionary.new;

	// make a dictionary for fast lookup
	keys.do { arg key, idx; 
		rkeys[key] = idx; 
	};

	w = Window.new("test", Rect(0,0,350, 120));
	v = VLayout.new;
	b = keys.collect{|key, i| 
		var but;
		but = Button.new
			.states_([
				["State One", Color.black, Color.red],
				["State Two", Color.white, Color.black],
			]);
		v.add(but);
		but;
	};
	w.layout = v;
	w.view.keyDownAction = {arg view,char,modifiers,unicode,keycode;
		var idx;
		
		[char,modifiers,unicode,keycode].postln;
		idx = rkeys[char]; // get the button idx from the char
		if(idx.notNil) {
			b[idx].valueAction = 1 - b[idx].value; // toggle value;
		}

	};
	w.front;
)


a = (0, pi/10 .. 5pi).collect{|val| val.sin};
a.asciiPlot;


Array.fill(500, {  1.0.rand  }).plot("Sequence of 500x 1.0.rand");

Array.fill(1500, {  1.0.linrand  }).plot("Sequence of 500x 1.0.linrand");

Array.fill(1500, {  1.0.sum3rand  }).plot("Sequence of 500x 1.0.sum3rand");
Array.fill(50, {  1.0.exprand(2)  }).plot("Sequence of 500x 1.0.sum3rand");



(
var randomNumbers, histogram, maxValue = 500, numVals = 10000, numBins = 500;

randomNumbers = Array.fill(numVals, { maxValue.rand; });
histogram = randomNumbers.histo(numBins, 0, maxValue);
histogram.plot("histogram for rand 0 - " ++ maxValue);
)



(
var randomNumbers, histogram, maxValue = 500.0, numVals = 10000, numBins = 500;

randomNumbers = Array.fill(numVals, { exprand(1,maxValue); });
histogram = randomNumbers.histo(numBins, 0, maxValue);
histogram.plot("histogram for linrand 0 - " ++ maxValue);
)



(
var randomNumbers, histogram, minValue = 5.0, maxValue = 500, numVals = 10000, numBins = 500;

randomNumbers = Array.fill(numVals, { exprand(minValue, maxValue); });
histogram = randomNumbers.histo(numBins, minValue, maxValue);
histogram.plot("histogram for exprand: " ++ minValue ++ " to " ++ maxValue);
)



(
{
    var a;
    a = [
            SinOsc.ar,
            Saw.ar,
            Pulse.ar
        ];
    TWChoose.ar(Dust.ar(MouseX.kr(1, 1000, 1)), a, [0.09, 0.05, 0.05].normalizeSum) * 0.2 ! 2

}.play;
)



(
var randomNumbers, histogram, distribution, randomTable, randTableSize=200;
var minValue = -250, maxValue = 250, numVals = 10000, numBins = 500;

// create some random distribution with values between 0 and 1
distribution = Array.fill(randTableSize,
    { arg i; (i/ randTableSize * 35).sin.max(0) * (i / randTableSize) }
);

// render a randomTable
randomTable = distribution.asRandomTable;
randomTable.class.postln;

// get random numbers, scale them

randomNumbers = Array.fill(numVals, { randomTable.tableRand * (maxValue - minValue) + minValue; });
histogram = randomNumbers.histo(numBins, minValue, maxValue);


histogram.plot("this is the histogram we got");
distribution.plot("this was the histogram we wanted");
)
