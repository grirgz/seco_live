
// drumkit


FileSystemProject.load("cuspn/snap_drumkit.scd");
FileSystemProject.load("radient1/drum.lib.scd");

// rdn


(
	// basic
	~transfert = { arg x, a, b, c;
		//2**(x * a);
		//x.gaussCurve(a*4, b*4, c*4)
		//a * (exp(squared(x - b) / (-2.0 * squared(c))))
		var val;
		//x = x + 0.5;
		val = x;
		val = val * a * 4;
		//val = val + b;

		val = val * 2 - 1;
		val = val**3;
		val = ( val*c ) + ( ( val**3 ) * (1-c) );
		//[val, ( val-0.5 ).softclip(0,1)+0.5].debug("bb,aa");
		val = val + (b*2-1);
		val = val.softclip;
		val = val +1 / 2 - 0.0625;
		//val = (x**3);
		//val = ( x*a*4 )**(3) + 0.5;
		//val.softclip(0,1);
		val
	};
	RandDelayNetwork(\multifb, {
		var block, algo;
		block = [
			\delay!16,
			\shift!2,
			\shift2!2,
			\dist!2,
			\fbnode!2,
			\fbnode2!2,
			\pan,
		].flatten.choose;
		algo = [
			\par, \seq
		].wchoose([0.1,0.9].normalizeSum);
		switch(algo,
			\par, {
				\par -> [2,4].choose.collect({
					\seq -> [ block, \end ]
				})
			},
			\seq, {
				\seq -> ([block] ++ (\end ! [1,2].choose))
			},
		)
	},
	IdentityDictionary.newFrom([
		\fbnode, { arg si, env;
			if(env.fbnode.isNil) {
				// in
				env.fbnode = FbNode(2);
				env.fbnode * \fb1.kr(0) + si;
			} {
				// out
				env.fbnode.write(Limiter.ar(si));
				env.fbnode = nil;
				si;
			};
		},
		\fbnode2, { arg si, env;
			if(env.fbnode.isNil) {
				// in
				env.fbnode = FbNode(2);
				env.fbnode * \fb2.kr(0) + si;
			} {
				// out
				env.fbnode.write(Limiter.ar(si));
				env.fbnode = nil;
				si;
			};
		},
		\pan, { arg si;
			Pan2.ar(si, rrand(-1,1)*0.1, 1).mean;
		},
		\delay, { arg si;
			var delay = [\delay, \delay2].choose.kr;
			DelayL.ar(si, 0.8, ~transfert.(rrand(0.01,0.8), \deltran1.kr, \deltran2.kr, \deltran3.kr) * [1, 1+0.01.rand] * delay) + si;
		},
		\shift, { arg si;
			FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
		},
		\shift2, { arg si;
			FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
		},
		\dist, { arg si;
			(si * 10.rand * \distamp.kr).tanh / 2;
		},
		\end, { arg si;
			//[
			//	{
			//		"endamp1".debug;
			//		si * \endamp1.kr(1)
			//	},
			//	{
			//		"endamp2".debug;
			//		si * \endamp2.kr(1)
			//	},
			//].choose.value;
			si;
		}
	]));

);

////////////////////////////// presets

//RandDelayNetwork('multifb').make('fx1', "6-B9AC-JLSM");

(
	~rdnpresets = ();

	~rdnpresets.init = {
		RandDelayNetwork('multifb').make('simple', "6-B9AC-JLSM");
		RandDelayNetwork('multifb').make('hard', "6-EK13-63Q7");
		RandDelayNetwork('multifb').make('dnb', "6-1N2R-2AEQ");
	};
	~rdnpresets.init;

	~rdnpresets.set_main_fx = { arg self, name;
		Ndef(\fx1, { Ndef.ar(name) * \mamp.kr(1) });
		if(self.oldname.notNil and: { name != self.oldname }) {
			Ndef(self.oldname).end(4,true);
		};
		self.oldname = name;
		{
			[name, self.oldname].debug("fronting the editor");
			WindowDef(\fxview).front(name);
		}.defer;
		nil;
	};

	~rdnpresets.simple = {

		//RandDelayNetwork('multifb').make('fx1', "6-B9AC-JLSM");
		~rdnpresets.set_main_fx(\simple);
		Ndef('simple').put(100, \pset -> Pbind(
			'wet10', 0.53333333333333,
			'fb', 0.00047974276314289,
			'delay', 0.0001,
			'delay2', 0.00012271252398512,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.13572088082975,
			'pitchlag', 1.0,
			'pitchmix', 0.64444444444444,
			'prelpf', 20000.0,
			'prehpf', 20.0,
			'lpf', 20000.0,
			'hpf', 20.0,
			'deltran1', 1.0444444444444,
			'deltran2', 0.044444444444444,
			'deltran3', -0.71111111111111,
			'endamp2', 17.506786696025,
			'fb1', 0.0,
			'endamp1', 1.6475489724421,
			'fbdistamp', 1.6558680225505,
			'fbdistmix', 0.92222222222222,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.35634235507941,
			'wet20', 1.0,
			'mamp', 1,
			'fb2', -0.066666666666667,
		).keep(1));
	};

	~rdnpresets.vieuxsimple = {
		RandDelayNetwork('multifb').make('fx1', "6-2BII-7GP");
		Ndef('fx1').put(100, \pset -> Pbind(
			'wet10', 0.53333333333333,
			'fb', 0.00047974276314289,
			'delay', 0.0001,
			'delay2', 0.00012271252398512,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.13572088082975,
			'pitchlag', 1.0,
			'pitchmix', 0.64444444444444,
			'prelpf', 20000.0,
			'prehpf', 20.0,
			'lpf', 20000.0,
			'hpf', 20.0,
			'deltran1', 1.0444444444444,
			'deltran2', 0.044444444444444,
			'deltran3', -0.71111111111111,
			'fb2', -0.066666666666667,
			'endamp2', 17.506786696025,
			'endamp1', 1.6475489724421,
			'fb1', 0.0,
			'fbdistamp', 1.6558680225505,
			'fbdistmix', 0.92222222222222,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.35634235507941,
			'wet20', 1.0,
			'mamp', 1,
		).keep(1));
	};
	~rdnpresets.hard = {

		//RandDelayNetwork('multifb').make('fx1', "6-EK13-63Q7");
		~rdnpresets.set_main_fx(\hard);
		Ndef('hard').put(100, \pset -> Pbind(
			'wet10', 0.53333333333333,
			'fb', 0.0010245393454616,
			'delay', 0.015058363542798,
			'delay2', 0.00015848931924611,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.11115047846092,
			'pitchlag', 1.0,
			'pitchmix', 0.75555555555556,
			'prelpf', 20000.0,
			'prehpf', 20.0,
			'lpf', 20000.0,
			'hpf', 20.0,
			'deltran1', 2.1011594451399,
			'deltran2', 0.70413552467493,
			'deltran3', 1.597424754017,
			'endamp1', 1.6475489724421,
			'endamp2', 0.87533933480125,
			'fb2', 0.076725227304337,
			'fbdistamp', 3.2542477092585,
			'fbdistmix', 0.92222222222222,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.35634235507941,
			'wet20', 1.0,
			'mamp', 1,
			'fb1', 0.13333333333333,
		).keep(1));
	};
	~rdnpresets.hard_soft = {

		//RandDelayNetwork('multifb').make('fx1', "6-EK13-63Q7");
		~rdnpresets.set_main_fx(\hard);
		Ndef('hard').put(100, \pset -> Pbind(
			'wet10', 0.53333333333333,
			'fb', 0.0010245393454616,
			'delay', 0.00019448624389374,
			'delay2', 0.019448624389374,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.037056722455349,
			'pitchlag', 1.0,
			'pitchmix', 0.75555555555556,
			'prelpf', 20000.0,
			'prehpf', 20.0,
			'lpf', 20000.0,
			'hpf', 20.0,
			'deltran1', 2.1011594451399,
			'deltran2', 0.70413552467493,
			'deltran3', 1.597424754017,
			'endamp1', 1.6475489724421,
			'endamp2', 0.87533933480125,
			'fb2', 0.076725227304337,
			'fbdistamp', 3.2542477092585,
			'fbdistmix', 0.92222222222222,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.35634235507941,
			'wet20', 1.0,
			'mamp', 1,
			'fb1', 0.13333333333333,
		).keep(1));
	};
	~rdnpresets.dnb = {
		//RandDelayNetwork('multifb').make('fx1', "6-1N2R-2AEQ");
		~rdnpresets.set_main_fx(\dnb);
		Ndef('dnb').put(100, \pset -> Pbind(
			'wet10', 0.53333333333333,
			'fb', 0.00019301194235932,
			'delay', 0.00022675431258708,
			'delay2', 0.00015058363542798,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.32247776814069,
			'pitchlag', 1.0,
			'pitchmix', 0.64444444444444,
			'prelpf', 20000.0,
			'prehpf', 20.0,
			'lpf', 20000.0,
			'hpf', 20.0,
			'fb2', -0.18708600231317,
			'deltran1', 3.0302173958684,
			'deltran2', 0.044444444444444,
			'deltran3', 0.26545884312927,
			'fbdistamp', 1.6558680225505,
			'fbdistmix', 0.92222222222222,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.35634235507941,
			'wet20', 1.0,
			'mamp', 1,
			'endamp2', 17.506786696025,
			'endamp1', 1.6475489724421,
			'fb1', 0.0,
		).keep(1));
	};
);

/////////////////////////////// gui

(

		WindowDef(\fxview, { arg def, ndefname=\fx1;
			var mainview = View.new;
			var scroll = ScrollView.new.canvas_(mainview).hasHorizontalScroller_(false).hasBorder_(false);
			def.window.alwaysOnTop = true;
			mainview.layout = 
				VLayout(
					*Ndef(ndefname).asParamGroup.collect({ arg p;
						HLayout(
							p.asStaticTextLabel.fixedWidth_(80).maxHeight_(10).font_(Font.default.size_(11)),
							p.asSlider.fixedWidth_(260).orientation_(\horizontal).maxHeight_(20),
							p.asTextField.fixedWidth_(80).maxHeight_(20).font_(Font.default.size_(11)),
						).spacing_(0).margins_(0)
					}) ++ [nil]
				).spacing_(0).margins_(0);
			VLayout(
				PlayerWrapper(Ndef(ndefname)).asView,
				scroll,
			);

		});
);
