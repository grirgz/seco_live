
FileSystemProject.load("algokit/kits/PatKitDef_drumwork.scd");
FileSystemProject.load("algokit/kits/PatKitDef_kitsec.scd");
PatKitDef(\sample1).edit
PatKitDef(\kitsec).edit
PatKitDef(\drumwork).edit
WindowDef(\multipatkitdef).front
WindowDef(\multipatkitdef_menu).front

(
WindowDef(\test,  {
	WindowDef(\samplekit).asView(PatKitDef(\kitsec))
}).front;
)

(
WindowDef(\multipatkitdef_menu, { arg def, gridlist;
	var gridstack = StackLayout.new;
	var selectmenu;
	var scroller;
	if( gridlist.isNil ) {
		gridlist = List.new;
		PatKitDef.all.do { arg x;
			gridlist.add(x) // take only values
		}
	};
	selectmenu = PopUpMenu.new.items_(gridlist.collect(_.key)).action_({ arg view;
		gridstack.index = view.value;
		"hey!".debug(view.value);
	});
	gridlist.do { arg grid;
		gridstack.add(WindowDef(\samplekit).asView(grid));
	};
	//scroller = ScrollView.new.canvas_(View.new.layout_( VLayout(
	//	selectmenu,
	//	gridstack
	//).margins_(0).spacing_(0)));
	scroller = ScrollView.new.canvas_(View.new.layout_(  gridstack));
	scroller.hasBorder = false;
	VLayout (
		selectmenu,
		scroller
	);
}).front;
)

ProtoDef(\rdn).edit
ProtoDef(\rdn2).edit
(
	~master.();

	Pdef(\part,
		Ppar([

			Pmono(\distordn,
				\inbus, BusDef(\fx1, \audio),
				'wet10', 1.0,
				'mix', 0.52100840336134,
				'gain', 0.2454369503751,
				'fb', Pseq([
					0,0,0,0.0100,
					
				],inf),
				'delay', Pseq([
					Pser([
						0.000010394574653723,
					],7),
					0.2,
				],inf),
				'delay3', Pseq([
					Pser([
						0.000010394574653723,
					],7),
					0.2,
				],inf),
				'delay2', Pseq([
					1,1,1,100,
					
				],inf).stutter(1) * 0.00001,
				\dur, 1,
				'distamp', 0.42682721311638,
				'distamp2', 10.0,
				'distamp3', 8.9904517086311,
				'shift', -5.0,
				'shift2', -1.1344537815126,
				'shift3', -2.4789915966387,
				'shiftmix', 0.15966386554622,
				'pitchlag', 1.0,
				'pitchmix', 0.0,
				'prelpf', 17000,
				'prehpf', 17,
				'lpf', 17000,
				'hpf', 17,
				'stereo', 0.0,
				'brffac', 0.60195390291997,
				'brfrqfac', 0.37940593233798,
				'fbdistamp', 0.47619047619048,
				'fbdistmix', 0.91176470588235,
				'postlpf', 17000,
				'posthpf', 17,
				'wetamp', 0.18504562572587,
				'indelay', 0.04,
				'wet20', 1.0,
				'mamp', 1/4,
			),
			Pbind(\out, BusDef(\fx1))<>
			Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('fix4/kick1.flac'),
					\isRest, Pseq([
						1,0,1,0, 0,0,1,1,
						0,0,1,1, 0,0,0,0,
						1,0,1,0, 0,0,1,1,
						0,0,1,0, 0,1,0,0,

						1,1,0,1, 0,1,0,1,
						0,0,1,1, 0,0,0,1,
						0,0,0,1, 0,0,0,1,
						0,0,0,1, 0,0,0,1,
					],inf).coin.not,
					\sustain, 0.2,
					\pos, 0.04,
					\dur, 1/8,
					\gain, 0.7,
				),
				Pbind(
					\instrument, \snaretuned,
					\isRest, Pseq([

						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,

						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,0,0, 1,0,0,0,

					],inf).coin.not,
					\sustain, 0.1/2,
					\dur, 1/8,
					\amp, 0.1/2,
				),
				Pbind(
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.1/8,
					\dur, 1/8,
					\amp, 0.04,
				),
				Pbind(
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.1/8,
					\dur, 1/8,
					\amp, 0.02,
				),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,0,1,0, 0,0,1,0, 1,0,0,0, 1,0,1,0,
						0,1,1,0, 1,1,1,0, 1,0,0,0, 1,0,1,1,
						1,0,1,1, 1,0,1,0, 1,0,0,1, 1,0,1,0,
						0,1,1,0, 1,1,1,0, 1,0,1,0, 1,0,1,1,

						0,1,1,0, 1,1,1,0, 1,0,0,0, 1,0,1,1,
						1,0,1,1, 1,0,1,0, 1,0,0,1, 1,0,1,0,
						1,0,1,0, 1,0,1,1, 1,0,1,0, 1,0,1,1, 
						1,0,1,0, 1,0,1,1, 1,0,1,0, 1,0,1,1,
					],inf).coin.not,
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.05,Pser([
							0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.04,
						],15),
						0.05,Pser([
							0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
							0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
						],15),

					],inf),
					\dur, 1/16,
					\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.02,
				),

			]),
		]),
	).play;
)

(

	SynthDef(\distordn, { arg out=0, gate=1;
		var sig;
		var si, env = ();
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

		thisThread.randSeed = 740492;

		sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
		si = sig;
		sig = { arg si, env;
			si = (si * 10.rand * \distamp.kr).tanh / 2;
			si = SelectX.ar(\shiftmix.kr, [
				si,
				FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2,
			]);
			si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
			si = BRF.ar(si, exprand(100,10000)* \brffac.kr(1), ( 0.5.rand * \brfrqfac.kr(1) ) + 0.01) + ( si / 4 );
			si = BRF.ar(si, exprand(100,10000)* \brffac.kr(1), ( 0.5.rand * \brfrqfac.kr(1) ) + 0.01) + ( si / 4 );
			si = (si * 10.rand * \distamp3.kr).tanh / 2;
			si = [
				{ arg si, env;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
					si = (si * 10.rand * \distamp.kr).tanh / 2;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
					si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
				}.value(si, env);

			].mean;
			si = SelectX.ar(\shiftmix.kr, [
				si,
				FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift3.kr) + si / 1.2,
			]);
			si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
			si = (si * 10.rand * \distamp.kr).tanh / 2;
		}.value(si, env);

		sig = Limiter.ar(sig);
		LocalOut.ar(sig);

		//sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
		//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
		//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
		//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
		sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
		sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
		sig = sig * \gain.kr(1);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
		Out.ar(out, sig);

	}).add;


	Pbind(
		'wet10', 1.0,
		'mix', 0.52100840336134,
		'gain', 2.4454369503751,
		'fb', 0.0001,
		'delay', 0.00010394574653723,
		'delay2', 0.080828221925227,
		'delay3', 0.0001,
		'distamp', 0.42682721311638,
		'distamp2', 100.0,
		'distamp3', 8.9904517086311,
		'shift', -5.0,
		'shift2', -1.1344537815126,
		'shift3', -2.4789915966387,
		'shiftmix', 0.15966386554622,
		'pitchlag', 1.0,
		'pitchmix', 0.0,
		'prelpf', 17000,
		'prehpf', 17,
		'lpf', 17000,
		'hpf', 17,
		'stereo', 0.0,
		'brffac', 0.60195390291997,
		'brfrqfac', 0.37940593233798,
		'fbdistamp', 0.47619047619048,
		'fbdistmix', 0.91176470588235,
		'postlpf', 17000,
		'posthpf', 17,
		'wetamp', 0.18504562572587,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
	)


);
