
// l'objectif est de simuler deux plaques dont l'une a une tache d'encre, en pressant les plaques plusieurs fois l'une contre l'autre et en decalant a chaque fois, on crée une serie de taches.
// l'encre est modelisée par un nuage de notes ou x,y=temps,freq
// idée: modeliser l'encre par un samplea (fft ?)
(
SynthDef(\cloudgrain, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = FMGrain.ar(1, \gdur.kr(0.1), freq, \modfreq.kr(200), \fmindex.kr(1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\cloudgrain, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
~cloud = [
	[0,200],
	[1,500],
	[2.3,240],
];
)

(
	~cloud = {
		(
			abstime: rrand(0.0,1.0),
			freq: exprand(300,1000.0),
			amp: rrand(0.01,1),
		)
	}.dup(200)
)
~cloud

(
	~surface1 = List.new;
	~surface2 = List.new;
	~surface1.addAll(~cloud);
)

(
	~paste_cloud = { arg cloud, shift_freq=0, shift_time=0;
		var newcloud = List.new;
		cloud.do { arg item, idx;
			var newitem = item.copy;
			var pasteratio = rrand(0.0,1);
			newitem.amp = item.amp * pasteratio;
			item.amp = item.amp * (1-pasteratio);
			newitem.freq = item.freq + shift_freq;
			newitem.abstime = item.abstime + shift_time;
			newcloud.add(newitem);
		};
		newcloud;
	};
	~paste_cloud_inplace = { arg cloud, shift_freq=0, shift_time=0;
		var newcloud = List.new;
		cloud.do { arg item, idx;
			var newitem = item.copy;
			var pasteratio = rrand(0.0,1);
			newitem.amp = item.amp * pasteratio;
			item.amp = item.amp * (1-pasteratio);
			newitem.freq = item.freq + shift_freq;
			newitem.abstime = item.abstime + shift_time;
			newcloud.add(newitem);
		};
		newcloud.addAll(cloud);
		newcloud;
	};
	~press_surfaces_oneway = { arg surface1, surface2, shift_freq, shift_time;
		var newcloud = ~paste_cloud.(surface1, shift_freq, shift_time);
		surface2.addAll(newcloud);
	};
	~press_surfaces = { arg surface1, surface2, shift_freq, shift_time;
		var newcloud = ~paste_cloud.(surface1, shift_freq, shift_time);
		surface2.addAll(newcloud);
	};
	~paste_process = { arg incloud;
		var cloud = incloud.copy;
		4.do { arg shift_freq;
			shift_freq = shift_freq + 1 * 200;
			3.do { arg shift_time;
				shift_time = shift_time + 1 * 4;
				~press_surfaces.(~surface1, ~surface2, shift_freq, shift_time);
			}
		};
	}
)

~cloud2 = 
~paste_process.(~cloud);
~cloud2.size
~surface2.size
3*4*200

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
			var data = topEnvironment[\cloud2];
			data = data.sort({ arg a, b;
				a.abstime < b.abstime;
			});
			data.collect { arg val;
				val.abstime;
			}.differentiate.do { arg val, idx;
				data[idx].reltime = val;
			};

			data.do { arg item;
				sp.par(Pbind(
					\instrument, \cloudgrain,
					\freq, item.freq,
					\dur, Pn(0.1,1),
					\amp, item.amp*5,
				));
				sp.wait(item.reltime);
			}
		}).trace,
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \cloudgrain,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);
