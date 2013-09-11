(

Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0.3,0.4)  });
Ndef(~name+++\lfo2, { SinOsc.kr([0.1,0.01,0.15]).range(0.8,1.09).sum/3;  });
Pdef(~name +++ \pre, Pbind(
	//\pitch_stretch, Pseq([0.4,0.3]+0.5,inf).stutter(3),
	//\pitch_stretch, Ndef(~name+++\lfo2),
	\pitch_stretch, Pseq([3.9,4.1,2.1]/5,inf).stutter(3),
	\pitch_stretch, 0.80,
	\pitch_stretch, 0.98,
	\pitch_stretch, 1,
	\time_stretch, Pseq([0.03,8.03],inf).stutter(3),
	\time_stretch, Pseq([0.03],inf).stutter(3),
	\time_stretch, Pseq([1.00],inf).stutter(3),
	\time_stretch, 1,
	\time_stretch, Sdef(~name, \time_stretch),
	\pitch_stretch, Sdef(~name, \pitch_stretch),
	\randrate, 0,
	\randframes, 0,
	//\out, BusDef(~name+++\fx),
	//\pos, Ndef(~name+++\lfo1),
	\pos, 0.20 + Pseq([0,0.01,0.2,0.1, 0.25,0.15,0.21,0.3],inf) + Pseq([0.12,0],inf).stutter(8),
	\pos, Pseq([0,0.3,0.32,0.12]+0.23,inf),
	\pos, Pseq([0,0.3783,0.5632,0.1812]+0.23,inf) + Pwhite(0,0.3).stutter(16),
	\pos, Prout { arg ev;
		var tab = [0,0.3783,0.5632,0.1812];
		tab = { 0.5.rand } ! 8;
		inf.do {
			var idx;
			idx = tab.size.rand;
			tab[idx] = (tab[idx] + rrand(-0.1,0.1)).clip(0,1);
			tab.debug("tab");
			Pseq(tab,2).embedInStream;
		};
	},
	\pos, Prout { arg ev;
		var tab2;
		var tab = [0,0.3783,0.5632,0.1812];
		tab = { 0.5.rand } ! 8;
		tab2 = tab.copy;
		inf.do {
			var idx;
			idx = tab.size.rand;
			tab[idx] = (tab[idx] + rrand(-0.1,0.1)).clip(0,1);
			idx = tab.size.rand;
			tab2[idx] = (tab2[idx] + rrand(-0.1,0.1)).clip(0,1);
			//tab.debug("tab");
			Pseq(tab,1).embedInStream;
			Pseq(tab2,1).embedInStream;
		};
	},
	//\pos, Sdef(~name, \pos),
	\adsr, Pseq([
		[ Env.adsr(0.0001,0.1,0.8,0.3) ],
		//[ Env.adsr(0.0001,0.1,0.8,0.03) ],
		[ Env.adsr(0.0001,0.1,0.8,0.03) ],
		[ Env.adsr(0.3,0.3,0.4,0.1) ],
	],inf),
	\legato, 1.0,
	\dur, 1/8,
	\amp, 0.111,
	\freq, 100,
));
);

// END

Sdef.edit(~name, \time_stretch);
Sdef.edit(~name, \pitch_stretch);
Sdef.edit(~name, \pos);
