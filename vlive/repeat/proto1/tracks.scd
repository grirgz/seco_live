
(
TrackDef(\playerwrapper, (
	label: { arg self; 
		"%: %".format(self.index, if(self.proxy.notNil, { self.proxy.label }, { "-" }))
	},

	new: { arg self, parent, index;
		self = self.copy;

		self.parentTrack = {parent};
		self.index = index;
		self.isEmpty = true;
		self;
	},

	source_: { arg self, val;
		self.proxy = PlayerWrapper(val);
		Param(self.proxy.target, \out).set(self.mixer.inbus);
		self.isEmpty = false;
	},

	source: { arg self;
		self.proxy.target;
	},

	proxy: { arg self;
		if(self[\obj_proxy].isNil) {
			self[\obj_proxy] = PlayerWrapper(nil);
		};
		self[\obj_proxy];
	},

	play: { arg self;
		var stopchild;
		if(self.isEmpty == true) {
			self.parentTrack.activeChild.stop;
			self.parentTrack.stop;
		} {
			if(self.parentTrack.activeIndex != self.index) {
				stopchild = self.parentTrack.activeChild;
			};
			self.parentTrack.activeIndex = self.index;
			if(stopchild.notNil) { stopchild.stop }; // changed message but arrive after deselect
			self.proxy.play;
			self.parentTrack.play;
			self.changed(\play, self.quant);
		}
	},

	stop: { arg self;
		self.proxy.stop;
		self.parentTrack.stop;
		self.changed(\stop, self.quant);
	},

	quant: { arg self;
		self.proxy.quant;
	},

	quant_: { arg self, val;
		self.proxy.quant = val;
	},

	isPlaying: { arg self;
		self.proxy.isPlaying and: {
			self.mixer.isNil or: { self.mixer.isPlaying }
		};
	},

	isActive: { arg self;
		self.parentTrack.activeIndex == self.index;
	},

	mixer: { arg self;
		self.parentTrack.mixer;
	},

));
TrackDef(\playertrack, (
	label: { arg self; 
		"%: %".format(self.key, if(self.proxy.notNil, { self.proxy.notNil }, { "-" }))
	},

	new: { arg self, parent, index;
		self = self.copy;

		self.selectChild(0);
		self.index = index;
		self.parentTrack = {parent};
		self;
	},

	activateChild: { arg self, idx;
		self.activeChild.play;
	},

	activeChild: { arg self;
		self.childAt(self.activeIndex);
	},

	source_: { arg self, array;
		array.collect({ arg val, idx;
			self.childAt(idx).source = val;
		})
	},

	source: { arg self;
		self.children.collect({ arg x; x.source });
	},

	play: { arg self;
		if(self.mixer.notNil) {
			self.mixer.play;
		};
		self.changed(\play, self.quant);
	},

	quant: { arg self;
		self.childAt(0).quant;
	},

	quant_: { arg self, val;
		self.children.do({ arg x; x.quant = val });
	},

	isPlaying: { arg self;
		self.activeChild.isPlaying and: {
			self.mixer.isNil or: { self.mixer.isPlaying }
		};
	},

	stop: { arg self;
		if(self.mixer.notNil) {
			//self.mixer.stop; // never stop mixers!
		};
		self.changed(\stop, self.quant);
	},


	childAt: { arg self, idx;
		var ret;
		self.children = self.children ?? { SparseArray.new };
		ret = self.children[idx] ?? { 
			self.children[idx] = TrackDef(\playerwrapper).new(self, idx);
			self.children[idx];
		};
		ret;
	},

	selectChild: { arg self, idx;
		self.selectedChild = idx; // to be deprecated, should be an object instead an index
		self.selectedIndex = idx;
		self.activeIndex = idx; // this one is the good one
		self.childProxy.source = self.childAt(idx).asPattern;
	},


	mixer: { arg self;
		if(self.mixer_obj.isNil) {
			self.mixer_obj = ~trackMixerDef.new(self.parentTrack.key+++"."+++self.index);
			self.mixer_obj.define_mixer;
			self.init_mixer_busses;
		};
		self.mixer_obj;
	},

));
TrackDef(\playergrid, (
	label: { arg self; "%".format(self.key) },

	source_: { arg self, val;
		self.children = val;
	},

	source: { arg self;
		self.children;
	},

	proxy: { arg self;
		PlayerWrapperGroup(self.children);
	},

	children: { arg self;
		self[\obj_children] ?? { 
			self[\obj_children] = SparseArray.new;
			self[\obj_children];
		};
	},

	childAt: { arg self, idx, idx2;
		var ret;
		if(idx.isSequenceableCollection) {
			idx.collect({ arg x; self.childAt(x) })
		} {
			if(idx.isKindOf(Point)) {
				idx2 = idx.y;
				idx = idx.x;
			};
			ret = self.children[idx] ?? { 
				self.children[idx] = TrackDef(\playertrack).new(self, idx);
				self.children[idx];
			};
			if(idx2.notNil) {
				ret.childAt(idx2)
			} {
				ret;
			}
		}
	},

	play: { arg self;
		self.children.do(_.play);
	},

	stop: { arg self;
		self.children.do(_.stop);
	},

	isPlaying: { arg self;
		self.children.every(_.isPlaying);
	},

	quant: { arg self;
		self.childAt(0).quant;
	},

	quant_: { arg self, val;
		// disable for the moment
		// when PlayerEvent set quant to 0 just before playing, all various quant are lost
		//self.children.do({ arg x; x.quant = val });
	},

	edit: { arg self;
		WindowDef(\playergrid).front(self);
	},

	activate: { arg self;
		~lauchpad_playergrid.new(self).activate
	},

	linePlayerAt: { arg parent, idx;
		var lineplayer = ProtoClass((
			label: { arg self;
				"line "++idx
			},
			isLinePlayer: true,
			play: { arg self;
				self.children.do({ arg x; 
					x.play;
				});
				//self.play;
			}

			stop: { arg self;
				parent.stop
			},

			isPlaying: { arg self;
				parent.isPlaying and: {
					self.children.every({ arg x; x.activeIndex == idx });
				};
			},

			children: { arg self;
				parent.children.asArray.collect({ arg x; x.childAt(idx) });
			},
		));
		lineplayer;
	},

	mixer:nil,

));

WindowDef(\mixerView_large, { arg me, track;
	var param;
	var sends = [];
	if(track.isKindOf(Volume)) {
		param = Param(track, \volume);
	} {
		param = track.mixer.asParam(\postfader);
		sends = 4.collect({ arg x; track.mixer.asParam(\send+++x) });
	};
	VLayout(
		param.asSlider.orientation_(\vertical),
		param.asTextField,
		VLayout(*
			sends.clump(2).collect { arg subsends;
				HLayout(* subsends.collect({ arg pa;
					pa.asKnob;
				}))
			}
		)
	)
});
WindowDef(\mixerView, { arg me, track;
	var param;
	var sends = [];
	if(track.isKindOf(Volume)) {
		param = Param(track, \volume);
	} {
		param = track.mixer.asParam(\postfader);
		sends = 4.collect({ arg x; track.mixer.asParam(\send+++x) });
	};
	VLayout(
		HLayout(
			VLayout (
				param.asSlider.orientation_(\vertical),
				param.asTextField,
			),
			VLayout(*
				sends.clump(2).collect { arg subsends;
					VLayout(* subsends.collect({ arg pa;
						pa.asKnob;
					}))
				}
			)
		)
	)
});
WindowDef(\playergrid, { arg me, maintrack;
	maintrack = maintrack ?? { TrackDef(\main) };

	VLayout(
		GridLayout.columns(*
			8.collect ({ arg x;
				var track = maintrack.childAt(x);
				8.collect({ arg y;
					var clip = track.childAt(y);
					PlayerWrapperSelectorView(PlayerWrapper(clip)).asView;
				})
				++ WindowDef(\mixerView).asView(track);
			}) 
			++ [
				8.collect({ arg y;
					var clip = maintrack.linePlayerAt(y);
					PlayerWrapperSelectorView(PlayerWrapper(clip)).asView;
				})
				++ WindowDef(\mixerView).asView(Server.default.volume);
			]
		),
		nil
	)
});

~lauchpad_playergrid = ProtoClass((
	new: { arg self, grid;
		self = self.deepCopy;
	
		self.grid = grid;
		self.flash_colors = self.colors.collect({ arg x; x - 0x0c });
	
		self;
	},

	colors: (
			red: 0x0f,
			red2: 0x0e,
			dimred: 0x0d,
			green: 0x3c,
			green2: 0x2c,
			dimgreen: 0x1c,
			yellow: 0x3e,
			orange: 0x2f,
			amber: 0x3f,
			off: 0,
	),

	gridsize: Point(8,8),

	ktl: { 
		MKtl(\lp, "novation-launchpad-s");
	},

	padAt: { arg self, pos;
		pos.debug("padAt");
		self.ktl.elAt(\pad, pos.x+( pos.y*self.gridsize.x ));
	},

	setColorAt: { arg self, pos, color, mode;
		[pos, color].debug("setColorAt");
		if(mode == \flash) {
			color = color - 0x0c;
		};
		self.padAt(pos).elAt(\on).value = color/127;
	},

	render_cell: { arg self, pos, isPlaying, mode;
		// playerWrapper to pad
		var color;
		var child = self.grid.childAt(pos);
		if(child.isEmpty == true) {
			color = \off
		} {
			[isPlaying, child.isPlaying].debug("render_cell: is, chiisp");
			isPlaying = isPlaying ?? { child.isPlaying };
			if(isPlaying) {
				color = \green;
			} {
				if(child.isActive) {
					color = \red;
				} {
					color = \yellow;
				}
			};
		};
		color = self.colors[color];
		self.setColorAt(pos, color, mode);
	},

	render_linebutton: { arg self, idx;
		var clip = self.grid.linePlayerAt(idx);
		if(clip.isPlaying) {
			self.ktl.elAt(\arr, idx).value = self.colors.green;
		} {
			self.ktl.elAt(\arr, idx).value = self.colors.off;
		};
	},

	render_grid: { arg self;
		self.gridsize.x.do { arg x;
			self.gridsize.y.do { arg y;
				var pos = Point(x, y);
				self.render_cell(pos);
				self.listenAt(pos);
			}
		};
		self.gridsize.y.do { arg x;
			self.render_linebutton(x)
		}
	},

	controllers: { arg self;
		var k = self.ktl.getHalo(\controllers);
		if(k.isNil) {
			k = { nil ! ( self.gridsize.y + 1 )} ! ( self.gridsize.x + 1 );
			self.ktl.addHalo(\controllers, k)
		};
		k
	},

	listenAt: { arg self, pos;
		var player = PlayerWrapper(self.grid.childAt(pos));
		if(self.controllers[pos.x][pos.y].notNil) {
			self.controllers[pos.x][pos.y].remove;
		};
		self.controllers[pos.x][pos.y] = player.makeListener({ arg me, msg, args;
			//{
			[msg, args].debug("listenat!!");
				self.render_cell(pos, msg == \play, \flash);
				player.doWithQuant {
					self.render_cell(pos);
				};
			//}.defer(1)
		});
	},

	activate: { arg self;
		self.ktl.elAt(\pad).do { arg pad, idx;
			pad.elAt(\on).action = {
				PlayerWrapper(self.grid.childAt(idx % self.gridsize.x, ( idx/self.gridsize.x ).asInteger)).togglePlay;
			};
			pad.elAt(\off).action = {
				//self.grid.childAt(idx % self.gridsize.x, ( idx/self.gridsize.x ).asInteger).stop;
			};
		};
		self.ktl.elAt(\arr).do { arg pad, idx;
			pad.action = {
				PlayerWrapper(self.grid.linePlayerAt(idx)).togglePlay;
			};
			//pad.action = {
			//	//self.grid.childAt(idx % self.gridsize.x, ( idx/self.gridsize.x ).asInteger).stop;
			//};
		};
		self.render_grid;
	},
));
);

// END

MKtl(\lp).elAt(\bt)

~trackTimeline.new(TrackDef(\main)).edit
(
	// ======== init tracks

TrackDef(\main).clear;
TrackDef(\main, TrackDef(\playergrid));
TrackDef(\main).childAt(0,0).source = Pdef(\kick);
TrackDef(\main).childAt(1,0).source = Pdef(\snare);
TrackDef(\main).childAt(2,0).source = Pdef(\hat);
TrackDef(\main).childAt(3,0).source = Pdef(\lide);
TrackDef(\main).childAt(4,0).source = Pdef(\hydro);
TrackDef(\main).childAt(4,1).source = Pdef('hydro.1');
TrackDef(\main).childAt(4,2).source = Pdef('hydro.2');
TrackDef(\main).childAt((0..4)).collect(_.quant_(8));
TrackDef(\main).activate;

)
TrackDef(\main).childAt((0..4))


TrackDef(\main).children
TrackDef(\main).childAt(0,1).source = nil
TrackDef(\main).childAt(0,1).mixer.sendParam(1)

Param(TrackDef(\main).childAt(0,0).proxy.target , \out).get
TrackDef(\main).childAt(0,0).mixer.inbus
TrackDef(\main).childAt(0,0).mixer.isPlaying
TrackDef(\main).childAt(0,0).mixer.outbus
TrackDef(\main).childAt(0,0).mixer.proxy.edit
TrackDef(\main).childAt(0,0).mixer.define_mixer
TrackDef(\main).childAt(0,0).mixer.proxy.stop
TrackDef(\main).childAt(0,0).mixer.play
TrackDef(\main).childAt(0,0).mixer.proxy.clear

W
PlayerWrapper(Pdef(\kick)).outBus
PlayerWrapper(Pdef(\kick)).doWithQuant{ "hello".postln }
PlayerWrapper(Pdef(\kick)).play
TrackDef(\main).childAt(0,0).stop
TrackDef(\main).childAt(0,0).play
TrackDef(\main).childAt(0).play
TrackDef(\main).childAt(0,0).proxy.play
TrackDef(\main).edit
TrackDef(\main).activate
TrackDef(\main).linePlayerAt(0).isPlaying
TrackDef(\main).linePlayerAt(0).play
TrackDef(\main).linePlayerAt(1).play
TrackDef(\main).linePlayerAt(0).stop

0.dbamp


(
~lauchpad_playergrid.new(TrackDef(\main)).activate
)
MKtl(\lp).postElements
MKtl(\lp).elAt(\pad, 0, \on).value = 0.2
TrackDef(\main).childAt(0).quant = 4

ProjectDef()

FileSystemResolver.new.paths_(["/home"]).resolve("ggz")

FileSystemProject.paths = ["/home/ggz/code/sc/seco/vlive", "/home/ggz/code/sc/seco/vlive/repeat"];
FileSystemProject.addPath(["/home/ggz/code/sc/seco/vlive", "/home/ggz/code/sc/seco/vlive/repeat"]);
FileSystemProject.load("proto1/perc.scd")
FileSystemProject.load("lib/tracks.scd")
FileSystemProject.cwd = "proto1";
FileSystemProject.load("perc.scd")
FileSystemProject(\proto1)
FileSystemProject(\proto1).path
FileSystemProject(\proto1).open
FileSystemProject(\proto1).open
FileSystemProject(\proto1, TrackDef(\basicproject))
ThisProject.defaultQuant = 2;
ThisProject.tempo = 2;
	// run init.scd, protect from recursive call
	// set cwd

