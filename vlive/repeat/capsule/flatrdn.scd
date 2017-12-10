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

////////////////////////


(
SynthDef(\delbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = LFSaw.ar(freq);
	sig1 = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig2 = RLPF.ar(sig, \lpfr2.kr(1.1) * freq, \rq2.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1, sig2]);

	thisThread.randSeed = 123133;
	
	sig1 = sig + Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.7) * 100 ) + sig;
		isig = [

			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01) * \delay1.kr) + sig;
				};
				isig;
				isig = ( isig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
			}.value(isig),
			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01)*\delay2.kr) + sig;
				};
				isig;
				isig = ( isig*\distamp2.kr(10) ).tanh * \distpostamp2.kr(1/2);
			}.value(isig),
		].mean;
		isig = [

			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01)*\delay3.kr) + sig;
				};
				isig;
			}.value(isig),
			{ arg isig;
				4.do {
					isig = DelayC.ar(isig, 1,rrand(0.1,0.01)*\delay4.kr) + sig;
				};
				isig;
			}.value(isig),
		].mean;
	
		isig = Limiter.ar(isig);
		isig;
	};
	sig = SelectX.ar(\delmix.kr(0.5), [sig, sig1]);

	sig = sig * \gain.kr(1);

	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

Pdef(\reter).clear
(
Pdef(\reter, 
	Ppar([
		Pbind(
			\instrument, \delbass,
			\note, Pseq([
				0,1,1,1,
			],inf),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,

			'lpfr', 0.77601093560068,
			'rq', 0.069397810604479,
			'lpfr2', 2.0548273159042,
			'rq2', 0.17652800371952,
			'lpmix', 0.85921569567667,
			'fb', 0.009756305902278,
			'delay1', 0.0012003147810941,
			'distamp', 4.7688547724285,
			'distpostamp', 9.6597787422967,
			'delay2', 0.019532098181673,
			'distamp2', 1.1762092256774,
			'distpostamp2', 166.9754399721,
			'delay3', 0.00053317803124595,
			'delay4', 0.030830941282943,
			'delmix', 1.4710510771126,
			'gain', 0.32039742573121,
			'adsr', [ Env([ 0.0, 0.97959184646606, 1.0, 0.0 ], [ 0.10999999940395, 0.25059666607289, 0.20262526598068 ], [ -4.0, -4.0, -4.0 ], 2.0)],
			\delay3, ~pmodenv.(Pseq([1,2,1,4]/10,inf), 4),
		),
				Pbind(
					\instrument, \phyhat3,
					\isRest, Pseq([
						1,1,1, 1,1,1, 1,0,1, 1,0,1,
						1,0,1, 1,1,1, 1,0,1, 1,1,1,
						1,0,1, 1,0,0, 1,0,1, 1,0,1,
						1,0,1, 1,1,1, 1,0,1, 1,1,1,

						1,1,1, 1,1,1, 1,0,1, 1,0,1,
						1,0,1, 1,1,1, 1,0,1, 1,1,1,
						1,0,1, 1,0,0, 1,0,1, 1,0,1,
						1,0,1, 1,1,1, 1,0,1, 1,1,1,

						1,1,1, 1,1,1, 1,0,1, 1,0,1,
						1,1,1, 1,1,1, 1,0,1, 1,0,1,
						1,0,1, 1,1,1, 1,0,1, 1,1,1,
						1,1,1, 1,1,1, 1,0,1, 1,1,1,

						1,0,1, 1,1,1, 1,0,1, 1,1,1,
						1,0,1, 1,0,0, 1,0,1, 1,0,1,
						1,0,1, 1,0,0, 1,0,1, 1,0,1,
						1,1,1, 1,1,1, 1,0,1, 1,1,1,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.05,0.1,0.8,0.02) ],
					],inf),
					\sustain, Pseq([0.08,0.02],inf),
					\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
					\pan, Pseq([0.2,0.1,0,-0.1],inf),
					\fac1, Pseq([
						0.2,0.01,0.12,
						0.01,0.01,0.01,
					],inf),
					\dur, 1/12,
					//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
					\pan, 0,
					\amp, 0.0132,
				),
				Pbind(
					\instrument, \snapkick,
					\isRest, Pseq([
						1,0,0, 0,0,1,  0,0,0, 0,0,0,
						1,0,0, 0,1,0,  0,0,0, 1,0,0,
						1,0,0, 0,0,1,  0,0,0, 0,0,1,
						1,0,0, 0,1,0,  0,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.01,
					\dur, 1/12,
					\amp, 0.1,
				),
				Pbind(
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  1,0,0, 0,0,0,
					],inf).coin.not,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind(
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.07) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 1,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 1,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,1, 1,0,0,  0,0,0, 0,0,1,

						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
						1,0,0, 1,0,1,  0,0,0, 0,0,1,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/3,
				),
				Pbind(
					\instrument, \snapclap,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.1/1,
					\dur, 1/8,
					\amp, 0.28,
					\isRest, true,
				),

	])
).play;
);
