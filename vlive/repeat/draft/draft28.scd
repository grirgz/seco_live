0b1b
// http://wiki.bash-hackers.org/scripting/terminalcodes
0x1b.asAscii
"%[10;10H===========================".format(0x1b.asAscii).postln

(
ProtoDef(\term, (
	colors: IdentityDictionary.newFrom([
		\black,
		\red,
		\green,
		\yellow,
		\blue,
		\magenta,
		\cyan,
		\white,
		\default,
	].collect({ arg k, idx; [ k, ( idx+30 ) ] }).flatten),

	attributes: IdentityDictionary.newFrom( [
		\reset,
		\bold,
		\dim,
		\standout,
		\underscore,
		\blink,
		\reverse,
		\hidden,
	].collect({ arg k, idx; [ k, idx ] }).flatten),

	moveTo: { arg self, x, y;
		"%[%;%H".format(0x1b.asAscii, y, x).post
	},

	foreground_: { arg self, color;
		"%[%m".format(0x1b.asAscii, self.colors[color]).post
	},

	background_: { arg self, color;
		"%[%m".format(0x1b.asAscii, self.colors[color]+10).post
	},

	attribute_: { arg self, attr;
		attr = attr ? \reset;
		"%[%m".format(0x1b.asAscii, self.attributes[attr]).post
	},

	clearScreen: {
		"%[2Jm".format(0x1b.asAscii).post
	}

));
)

[ 0 m	sgr0	Reset all attributes
[ 1 m	bold	Set "bright" attribute
[ 2 m	dim	Set "dim" attribute
[ 3 m	smso	Set "standout" attribute
[ 4 m	set smul unset rmul :?:	Set "underscore" (underlined text) attribute
[ 5 m	blink	Set "blink" attribute
[ 7 m	rev	Set "reverse" attribute
[ 8 m	invis	Set "hidden" attribute


ProtoDef(\term).colors
(
	Tdef(\colorme, {
		ProtoDef(\term).clearScreen;
		500.do {

			ProtoDef(\term).moveTo(rrand(1,30), rrand(1,70));
			ProtoDef(\term).background_(ProtoDef(\term).colors.keys.choose);
			["x", "|","-", "/"].choose.post;
			0.01.wait;
		}

	}).play;
)

(
	Tdef(\colorme, {
		14.do {
			fork {
				var px = rrand(1,40), py = rrand(1,90);
				var col = ProtoDef(\term).colors.keys.choose;
				var fcol = ProtoDef(\term).colors.keys.choose;
				var ch = ["x", "|","-", "/"].choose;
				ProtoDef(\term).clearScreen;
				500.do {
					px = px+[1,0,-1].choose;
					py = py+[1,0,-1].choose;
				
					ProtoDef(\term).moveTo(px, py);
					ProtoDef(\term).background_(col);
					ProtoDef(\term).foreground_(fcol);
					ch.post;
					0.1.wait;
				}
			}
		}

	}).play;
)

(
	Tdef(\colorme, {
		14.do {
			fork {
				var px = rrand(1,40), py = rrand(1,90);
				var col = ProtoDef(\term).colors.keys.choose;
				var fcol = ProtoDef(\term).colors.keys.choose;
				var ch = ["x", "|","-", "/"].choose;
				var pat = Prand([1,0,-1],inf).stutter(Pwhite(1,8));
				var pxstr = pat.asStream;
				var pystr = pat.asStream;
				ProtoDef(\term).clearScreen;
				500.do {
					px = px+pxstr.next;
					py = py+pystr.next;
				
					ProtoDef(\term).moveTo(px, py);
					ProtoDef(\term).background_(col);
					ProtoDef(\term).foreground_(fcol);
					ch.post;
					0.1.wait;
				}
			}
		}

	}).play;
)

(
	// downfall
	Tdef(\colorme, {
		14.do {
			fork {
				var px = rrand(1,40), py = rrand(1,90);
				var col = ProtoDef(\term).colors.keys.choose;
				var fcol = ProtoDef(\term).colors.keys.choose;
				var ch = ["x", "|","-", "/"].choose;
				var pat = Prand([1,0,-1],inf).stutter(Pwhite(1,8));
				var pxstr = pat.asStream;
				var pystr = pat.asStream;
				var file = File("~/code/sc/seco/vlive/rise11/*".pathMatch.choose, "r");
				ProtoDef(\term).clearScreen;
				500.do {
					px = px+pxstr.next;
					py = py+pystr.next;
				
					ProtoDef(\term).moveTo(px, py);
					ProtoDef(\term).background_(col);
					ProtoDef(\term).foreground_(fcol);
					file.readUpTo($\n).postln;
					0.1.wait;
				}
			}
		}

	}).play;
)

(
	Tdef(\colorme, {
		14.do {
			fork {
				var px , py = rrand(1,30);
				var col = ProtoDef(\term).colors.keys.choose;
				var fcol = ProtoDef(\term).colors.keys.choose;
				var ch = ["x", "|","-", "/"].choose;
				var pat = Prand([1,0,-1],inf).stutter(Pwhite(1,8));
				var pxstr = pat.asStream;
				var pystr = pat.asStream;
				var file = File("~/code/sc/seco/vlive/rise11/*".pathMatch.choose, "r");
				var attr;
				px = [1,30,40].choose;
				ProtoDef(\term).clearScreen;
				ProtoDef(\term).background_(\default);
				attr = [\bold, \underscore, \bright, \standout, \blink, \reverse].choose;
				attr = \reset;
				500.do {
					var txt;
				

					10.do {
						py = ( py+1 mod: 40 ).next;
						ProtoDef(\term).moveTo(px, py);
						//ProtoDef(\term).background_(col);
						ProtoDef(\term).attribute_(attr);
						if(0.2.coin) {
							ProtoDef(\term).foreground_(fcol);
						};

						txt = file.readUpTo($\n);
						if(txt.notNil) {
							txt.keep(10).post;
						} {
							file.reset;
						};
					};
					(1/8).wait;
				}
			}
		}

	}).play;
)


			ProtoDef(\term).colors.keys
(
	Tdef(\colorme, {
		var waitstr = PdurStutter(Pseq([1/2,1/4,1/3,1/8],inf), 1/2).asStream;
		waitstr = Pwhite(0.1,0.5).asStream;
		waitstr = Prand(1/(1..8),inf).asStream;
		4.do {
			fork {
				var px , py = rrand(1,30);
				var col = ProtoDef(\term).colors.keys.choose;
				var fcol = ProtoDef(\term).colors.keys.choose;
				var ch = ["x", "|","-", "/"].choose;
				var pat = Prand([1,0,-1],inf).stutter(Pwhite(1,8));
				var pxstr = pat.asStream;
				var pystr = pat.asStream;
				var file = File("~/code/sc/seco/vlive/repeat/capsule/*".pathMatch.choose, "r");
				var attr;
				var txt1, txt2;
				var waittime;
				px = rrand(1,40);
				py = rrand(1,40);
				ProtoDef(\term).clearScreen;
				ProtoDef(\term).background_(\default);
				attr = [\bold, \underscore, \bright, \standout, \blink, \reverse].choose;
				attr = \reset;
				50.do {
					var txt;
				
					txt = file.readUpTo($\n);
					if(txt.notNil) {
						txt1 = txt.keep(20).post;
					} {
						file.reset;
						txt1 = "END";
					};
				
					waittime = waitstr.next;
					200.do { arg blink;
						var lpy = py;
						ProtoDef(\term).moveTo(px, lpy);
						ProtoDef(\term).background_(col);
						ProtoDef(\term).attribute_(attr);
						ProtoDef(\term).foreground_(fcol);
						4.do {
							lpy = lpy+1;
							ProtoDef(\term).moveTo(px, lpy);
							if(blink%2==0) {
								txt1.post;
							} {
								txt1.size.do { "  ".post };
							};
						};
						//( 1/8 ).wait;
						waittime.wait;
					};
				}
			}
		}
	}).play;
)


(
	Tdef(\colorme, {
		var waitstr = PdurStutter(Pseq([1/2,1/4,1/3,1/8],inf), 1/2).asStream;
		waitstr = Pwhite(0.1,0.5).asStream;
		waitstr = Prand(1/(1..8),inf).asStream;

		Tdef(\colorme1, {
			var px , py = rrand(1,30);
			var col = ProtoDef(\term).colors.keys.choose;
			var fcol = ProtoDef(\term).colors.keys.choose;
			var ch = ["x", "|","-", "/"].choose;
			var pat = Prand([1,0,-1],inf).stutter(Pwhite(1,8));
			var pxstr = pat.asStream;
			var pystr = pat.asStream;
			var file = File("~/code/sc/seco/vlive/repeat/capsule/*".pathMatch.choose, "r");
			var attr;
			var txt1, txt2;
			var waittime;
			px = rrand(1,40);
			py = rrand(1,40);
			ProtoDef(\term).clearScreen;
			ProtoDef(\term).background_(\default);
			attr = [\bold, \underscore, \bright, \standout, \blink, \reverse].choose;
			attr = \reset;
			5000.do {
				var txt;

				txt = file.readUpTo($\n);
				if(txt.notNil) {
					txt1 = txt.keep(80).post;
				} {
					file.reset;
					txt1 = "END";
				};

				waittime = waitstr.next;
				8.do { arg blink;
					var lpy = py;
					var lpx = px;
					ProtoDef(\term).moveTo(px, lpy);
					ProtoDef(\term).background_(col);
					ProtoDef(\term).attribute_(attr);
					ProtoDef(\term).foreground_(fcol);
					14.do {
						lpy = lpy+1;
						lpx = lpx+rrand(1,7) % rrand(4,30);
						ProtoDef(\term).moveTo(lpx, lpy);
						if(blink%2==0) {
							txt1.post;
						} {
							txt1.size.do { "  ".post };
						};
					};
					//( 1/8 ).wait;
					waittime.wait;
				};
			}
		}).play;

		Tdef(\colorme2, {
			var px , py = rrand(1,30);
			var col = ProtoDef(\term).colors.keys.choose;
			var fcol = ProtoDef(\term).colors.keys.choose;
			var ch = ["x", "|","-", "/"].choose;
			var pat = Prand([1,0,-1],inf).stutter(Pwhite(1,8));
			var pxstr = pat.asStream;
			var pystr = pat.asStream;
			var file = File("~/code/sc/seco/vlive/repeat/capsule/*".pathMatch.choose, "r");
			var attr;
			var txt1, txt2;
			var waittime;
			px = rrand(1,40);
			py = rrand(1,40);
			ProtoDef(\term).clearScreen;
			ProtoDef(\term).background_(\default);
			attr = [\bold, \underscore, \bright, \standout, \blink, \reverse].choose;
			attr = \reset;
			50.do {
				var txt;

				txt = file.readUpTo($\n);
				if(txt.notNil) {
					txt1 = txt.keep(20).post;
				} {
					file.reset;
					txt1 = "END";
				};

				waittime = waitstr.next;
				200.do { arg blink;
					var lpy = py;
					4.do {
						ProtoDef(\term).moveTo(px, lpy);
						ProtoDef(\term).background_(col);
						ProtoDef(\term).attribute_(attr);
						ProtoDef(\term).foreground_(fcol);
						lpy = lpy+1;
						if(blink%2==0) {
							txt1.post;
						} {
							txt1.size.do { "  ".post };
						};
						waittime.wait;
					};
					//( 1/8 ).wait;
				};
			}
		}).play;

		Tdef(\colorme3, {
			var px , py = rrand(1,30);
			var col = ProtoDef(\term).colors.keys.choose;
			var fcol = ProtoDef(\term).colors.keys.choose;
			var ch = ["x", "|","-", "/"].choose;
			var pat = Prand([1,0,-1],inf).stutter(Pwhite(1,8));
			var pxstr = pat.asStream;
			var pystr = pat.asStream;
			var file = File("~/code/sc/seco/vlive/repeat/capsule/*".pathMatch.choose, "r");
			var attr;
			var txt1, txt2;
			var waittime;
			px = rrand(1,40);
			py = rrand(1,40);
			ProtoDef(\term).clearScreen;
			ProtoDef(\term).background_(\default);
			attr = [\bold, \underscore, \bright, \standout, \blink, \reverse].choose;
			attr = \reset;
			50.do {
				var txt;
					var lpy = py;

				txt = file.readUpTo($\n);
				if(txt.notNil) {
					txt1 = txt.keep(20).post;
				} {
					file.reset;
					txt1 = "END";
				};

				waittime = waitstr.next;
				20.do { arg blink;
						lpy = lpy+1;
						ProtoDef(\term).moveTo(px, lpy);
						ProtoDef(\term).background_(col);
						ProtoDef(\term).attribute_(attr);
						ProtoDef(\term).foreground_(fcol);
						txt1.post;
						waittime.wait;
					//( 1/8 ).wait;
				};
			}
		}).play;
	}).play;
)




(
Pdefn(\gfx1, Prout({ arg ev;
	var px , py;
	var ch = ["x", "|","-", "/"].choose;
	var pat = Prand([1,0,-1],inf).stutter(Pwhite(1,8));
	var pxstr = pat.asStream;
	var pystr = pat.asStream;
	var file = File("~/code/sc/seco/vlive/repeat/capsule/*".pathMatch.choose, "r");
	var attr;
	var txt1, txt2;
	var waittime;
	3000.do {
		var col = ProtoDef(\term).colors.keys.choose;
		var fcol = ProtoDef(\term).colors.keys.choose;
		px = rrand(1,40);
		py = rrand(1,40);
		20.do { arg blink;
			if(ev[\isRest] != true) {

				5.do {
				ProtoDef(\term).moveTo(px, py);
				ProtoDef(\term).background_(\default);
				ProtoDef(\term).attribute_(\reset);
				ProtoDef(\term).foreground_(\green);
					//"OOOOOOOOOOOOOOOOOO".post;
					rrand(0.000000001,1).post;
				py=py+1 % 70;
				};
			};
			ev = 1.yield;
			//( 1/8 ).wait;
		};
	};
	ev;

}));
Pdefn(\gfx2, Prout({ arg ev;
	var px , py;
	var col = ProtoDef(\term).colors.keys.choose;
	var fcol = ProtoDef(\term).colors.keys.choose;
	var ch = ["x", "|","-", "/"].choose;
	var pat = Prand([1,0,-1],inf).stutter(Pwhite(1,8));
	var pxstr = pat.asStream;
	var pystr = pat.asStream;
	var file = File("~/code/sc/seco/vlive/repeat/capsule/*".pathMatch.choose, "r");
	var attr;
	var txt1, txt2;
	var waittime;
	3000.do {
		px = rrand(1,80);
		py = rrand(1,40);
		120.do { arg blink;
			if(ev[\isRest] != true) {

				ProtoDef(\term).background_(\default);
				ProtoDef(\term).attribute_(\reset);
				ProtoDef(\term).foreground_(\white);
					ch = [
						"~", "X","0_0 ",
						"Pdef({[#]})", ".","x(px:z=41{[12,32]})",
					].choose;
				30.do {
					ProtoDef(\term).moveTo(rrand(1,80), rrand(1,80));
					8.collect(ch).join.keep(20).post;
				};
				py=py+1 % 40;
			};
			ev = 1.yield;
			//( 1/8 ).wait;
		};
	};
	ev;

}));
Pdefn(\gfx3, Prout({ arg ev;
	var px , py;
	var col = ProtoDef(\term).colors.keys.choose;
	var fcol = ProtoDef(\term).colors.keys.choose;
	var ch = ["x", "|","-", "/"].choose;
	var pat = Prand([1,0,-1],inf).stutter(Pwhite(1,8));
	var pxstr = pat.asStream;
	var pystr = pat.asStream;
	var file = File("~/code/sc/seco/vlive/repeat/capsule/*".pathMatch.choose, "r");
	var attr;
	var txt1, txt2;
	var waittime;
	3000.do {
		px = rrand(1,80);
		py = rrand(1,40);
		12.do { arg blink;
			if(ev[\isRest] != true) {
				var lpy= py;

					ProtoDef(\term).background_(\white);
					ProtoDef(\term).attribute_(attr);
					ProtoDef(\term).foreground_(\black);
				20.do {
					ProtoDef(\term).moveTo(px, lpy);
					lpy=lpy+1 % 80;
					["0", "1"].choose.post;
					10.do {" ".post;};
				};
				px = px+10%80;
			};
			ev = 1.yield;
			//( 1/8 ).wait;
		};
	};
	ev;

}));
Pdefn(\gfxwritenum, Prout({ arg ev;
	var px , py;
	var col = ProtoDef(\term).colors.keys.choose;
	var fcol = ProtoDef(\term).colors.keys.choose;
	var ch = ["x", "|","-", "/"].choose;
	var pat = Prand([1,0,-1],inf).stutter(Pwhite(1,8));
	var pxstr = pat.asStream;
	var pystr = pat.asStream;
	var file = File("~/code/sc/seco/vlive/repeat/capsule/*".pathMatch.choose, "r");
	var attr;
	var txt1, txt2;
	var waittime;
	30.do {
		px = 1;
		py = 1;
		1000.do { arg num;

			ProtoDef(\term).background_(\red);
			ProtoDef(\term).attribute_(\bold);
			ProtoDef(\term).foreground_(\white);
			ProtoDef(\term).moveTo(px, ( num/20 ).floor);
			num.post;
			ev = 1.yield;
			px = px+4 %80;
		};
	};
	ev;

}));

// TO use:
//ions: cabac=1 ref=1 deblock=1:0:0 analyse=0x3:0x3 me=dia subme=1 psy=1
//psy_rd=1,00:0,00 mixed_ref=0 me_range=16 chroma_me=1 trellis=0 8x8d ct=1 cqm=0
//deadzone=21,11 fast_pskip=1 chroma_qp_offset=0 threads=4 lookahead_threads=1
//sliced_threads=0 nr=0 decimate=1 interlaced=0 blur ay_compat=0
//constrained_intra=0 bframes=3 b_pyramid=2 b_adapt=1 b_bias=0 direct=1 weightb=1
//open_gop=0 weightp=1 keyint=250 keyint_min=25  scenecut=40 intra_refresh=0
//rc=crf mbtree=0 crf=23,0 qcomp=0,60 qpmin=0 qpmax=69 qpstep=4 ip_ratio=1,40
//pb_ratio=1,30 aq=1:1,00   

//[libx264 @ 0x9b49340]
//[libx264 @ 0x9b49340]
//[libx264 @ 0x9b49340]
//[libx264 @ 0x9b49340]


	ProtoDef(\term).clearScreen;
)



(
	ProtoDef(\term).clearScreen;
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ptpar([
			0, Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,1,0,1,
					1,0,1,1, 0,1,1,0,
				],inf).coin.not,
				\gfx, Pdefn(\gfx1),
				\amp, 0.1,
			),
			8, PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,1,0,1,
				],inf).coin.not,
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/8,
				\gfx, Pdefn(\gfx2),
			)),
			4, Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0, 1,0,
					1,0, 1,0,
					1,1, 0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/16,
				\amp, 0.01 * Pseq([1,0.7],inf),
				\gfx, Pdefn(\gfx3),
			),
			0, Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,0,0,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.4,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
				//\gfx, Pdefn(\gfx3),
				\gfx, Pdefn(\gfxwritenum),
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.5344889782792,
			'fb', 0.0000099467303085,
			'delay', 0.000600001231 * Pseq([
				1,1,1,1,
				1,1, 1,10000,
				1,1,1,20,
				2,2,100,20,
			],inf).stutter(1),
			'delay2', 0.000030543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 47.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 44.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			\addAction, \addToTail,
			'mamp', 1,
			\dur, 1/4,
		),
		
	])
)).play;
)
