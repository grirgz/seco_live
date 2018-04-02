
// musique deja faite hautement parametrable

Muz(\bla).play;
Muz(\bla).;
- jouer section1
- couper les bass
- appliquer un filtre
- buildup1*

ce qu'il faut, c'est un langage ou on peut dire concisement "coupe la basse" puis "remet la basse et coupe les hat et snare" puis "monte progressivement le lead puis met d'un coup le hat et le snare et la section hi"
"met le delay de toutes les tracks a 0.04"
"met ces 3 tracks dans ces 2 effets"

bass cut
bass put & hat cut & snare cut
lead rise > (hat put & hi put)

Pdef(\bass).stop
Pdef(\bass).play; Pdef(\hat).play; Pdef(\snare).play;
Pdef(\leado)
Muz(\lead).rise
~lead.rise.then({ ~hat.play; ~snae.play });
~at.last(4) { ~snare.fill }

// problems:
// - hard to sequence Pdef and Pbindef because of quant


(
	FileSystemProject.load("capsule/protolive.scd");
	///////////////////////////////////////////////////////////
	// sound
	///////////////////////////////////////////////////////////

	//TrackTemplateDef(\patmixer,(
			// TODO
	//))

	TrackDef(\pbass, (
		parent: TrackTemplateDef(\protopat),
		new: { arg self;
			Pdef(\pbass,
				Pbind(
					\instrument, \basicbass,
					\note, Pstep(Pseq([
						0,0,0,1,
					],inf),1),
					\octave, 3,
					\legato, Pseq([
						3,0,0,0, 2,0,2,0,
						0,0,1,0, 2,0,2,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					//\lag, 0.04,
					\amp, 0.1,
				),
			);
			self;
		},

		endstuck: { arg self;
			Pbindef(\pbass, 
				\legato, Pseq([
					8,0,0,0, 0,0,0,0,
				],inf),
			);
			self;
		},
	));
	~bass = TrackDef(\pbass).new;

	TrackDef(\pkick, (
		parent: TrackTemplateDef(\protopat),
		new: { arg self;
			Pdef(self.key,
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([

						1,0,0,0, 0,0,0,0,
						1,0,1,0, 0,0,0,0,
						1,1,0,0, 0,0,1,0,
						1,0,1,0, 0,0,0,0,

						1,0,0,0, 0,0,0,0,
						1,0,1,0, 0,0,0,0,
						1,0,1,0, 0,1,0,0,
						1,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1,
				),
			);
			self;
		},

		fill: { arg self;
				Pbindef(self.key, 
					\isRest, Pseq([
						1,0,0,1, 0,0,1,0,
						1,0,1,0, 1,1,0,1,
					],1).coin.not,
				);
				self.promiseAtQuant(2);
				self.then {
					self.new;
				};
				self;
		},
	));
	~kick = TrackDef(\pkick).new;

	TrackDef(\psnare, (
		parent: TrackTemplateDef(\protopat),
		new: { arg self;
			Pdef(self.key,
				PatKitDef(\ksh2b).asPattern(
					Pdef(self.key+++\inner, Pbind(
						\kitIndex, 5,
						\isRest, Pseq([
							0,0,0,0, 1,0,0,0,
						],inf).coin.not,
						\sustain, 0.1,
						\gain, 0.2,
						\dur, 1/8,
					))
				),
			);
			self;
		},

		fill: { arg self;
				Pbindef(self.key+++\inner, 
					\isRest, Pseq([
						1,1,0,1, 1,0,0,1,
						0,1,0,1, 1,0,1,1,
					],1).coin.not,
				);
				self.promiseAtQuant(2);
				self.then {
					self.new;
				};
				self;
		},
	));
	~snare = TrackDef(\psnare).new;

	TrackDef(\phat, (
		parent: TrackTemplateDef(\protopat),
		new: { arg self;
			Pdef(self.key,
				Pbind(),
			);
			self.base;
			self;
		},

		base: { arg self;
			Pbindef(self.key,
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			);
			self;
		},

		fill: { arg self;
				Pbindef(self.key, 
					\isRest, Pseq([
						1,1,0,1, 1,0,0,1,
						0,1,0,1, 1,0,1,1,
					],2).coin.not,
					\dur, 1/16,
				);
				self.promiseAtQuant(2);
				self.then {
					self.base;
				};
				self;
		},
	));
	~hat = TrackDef(\phat).new;

	~drums = TrackDef(\pdrums, (
		parent: TrackTemplateDef(\protopat),
		play: { arg self;
			self.itemDo(_.play);
			self.promiseAtQuant;
			self;
		},
		stop: { arg self;
			self.itemDo(_.stop);
			self.promiseAtQuant;
			self;
		},

		itemDo: { arg self, fun;
			[
				~kick,
				~snare,
				~hat,
			].do(fun)
		},
	));

	TrackDef(\pfxclean1, (
		parent: TrackDef(\protopat),
		inbus: {
			BusDef(\sendbus1, \audio, 2)
		},

		new: { arg self;
			Pdef(self.key,
				Pmono(\rdncleandist_fulllight)
				<>
				Pdef(self.key+++\inner,
				Pbind( 
					\inbus, self.inbus,
					\addAction, \addToTail,
					'wet10', 1.0,
					'mix', 0.15714285714286,
					'gain', 0.7344889782792,
					'fb', 0.0002099467303085,
					'delay', 0.000600001231 * Pseq([
						1,
					],inf).stutter(1),
					'delay2', 0.210000543560101,
					'distamp', 1.361836201538,
					'prelpf', 19900,
					'prehpf', 17,
					'lpf', 19900,
					'hpf', 17,
					'fbdistamp', 4.5388371966577,
					'fbdistmix', 0.98176470588235,
					'postlpf', 19900,
					'posthpf', 17,
					\bpmix, 0,
					'wetamp', 0.20503372119697,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,
					\dur, 1,
				)),
			);
			self;
		},

		rise: { arg self;
				Pbindef(self.key+++\inner, 
					\delay, ~pmodenv.(Pseq([0.00061,0.02,0.1],inf), 1),
				);
				self.promiseAtQuant(2);
				self.then {
					self.new;
				};
				self;
		},
	));
	~fxclean1 = TrackDef(\pfxclean1).new;

	~at = TrackDef(\scheduler, (
		parent: ProtoDef(\protopat),
	));
	//~at.beatsPerBar = 8;
)
ProtoDef(\psnare).clear
~bass.play;
~bass.endstuck;
~bass.new;
~bass.key
~bass.stop
~bass.play; ~kick.play;
~kick.play;
~kick.fill
~kick.new
~bass.stop; ~kick.fill.then({ ~bass.play });
~snare.play;
~snare.fill.then({ ~bass.play }); ~kick.fill;
~snare.fill.then({ ~bass.play }); ~kick.stop; ~bass.stop
~snare.fill;
~snare.new
~hat.play
~hat.new;
~hat.fill
~hat.send(~fxclean1)
~hat.send(0)
~fxclean1.play
~fxclean1.rise
~hat.play;
~at.last({ ~snare.play;~snare.fill;~bass.stop }).then({ ~bass.play; })
~at.last({ ~bass.stop; ~snare.stop; ~kick.stop; ~fxclean1.rise }).then({ ~bass.play; ~drums.play })
~at.last({~hat.play.fill}).then({ ~bass.play })
~at.last({ ~hat.stop; ~kick.stop; ~snare.fill; }).then({~drums.play; ~bass.endstuck.wait(4).then({ ~bass.new }) })

~at.start({ ~snare.play; ~kick.play.wait(4).then({ ~hat.play }) })
~kick.play;
~kick.proxy.muted
Pdef
EventPatternProxy
~kick.clear

~hat.play.wait(4, _.stop)



