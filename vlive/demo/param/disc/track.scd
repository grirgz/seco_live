
(
SynthDef(\fitu, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig = SinOsc.ar(freq * [1,1.01] * env1);
	sig = sig + LFSaw.ar(freq);
	sig = sig.wrap2( SinOsc.kr(1/3, 2 * pi.rand).range(0.5,2) );
	sig = RLPF.ar(sig, \lpf.kr(4170) * ( 2-env1 ), \rq.kr(0.8));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * SinOsc.kr(2).range(0,1);
	sig = Splay.ar(sig, 0.1, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\fitu, Pbind(
	\instrument, \fitu,
	\degree, Pseq([0,Pwhite(0,12,1), \r,\r,\r,\r,\r,\r],inf).stutter(2),
	\sustain, 1.7,
	\dur, 1/8,
	\amp, 0.1/4,
	\out, BusDef(\fx3),
)).play;
);

(
Pdef(\fitu2, Pbind(
	\instrument, \fitu,
	\degree, Pseq([0,Pwhite(0,12,1), \r,\r,\r,\r,\r,\r],inf).stutter(2),
	\lpf, Pseq([2100,Pwhite(700,2000,1)],inf),
	\degree, Pseq([
		Pser([
			0
		],16),
		Pser([
			3
		],16),
		
	],inf),
	\isRest, Pseq([
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 0,0,0,0,
	],inf).coin.not,
	\octave, 3,
	\sustain, 0.04,
	\dur, 1/8,
	\amp, 0.1/2,
	\out, BusDef(\fx3),
)).play;
);



(
//	TrackDef(\yo).init = {

		Ndef(\tape).set(\inbus, BusDef(\fx3));
		Ndef(\tape).put(0, {
			InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
		});
		Ndef(\tape).put(50, \filter -> { arg in, amp=1;
			var bufnum = LocalBuf(s.sampleRate * 4,2);
			var bufgate, stuttrig, choosetrig, recordtrig;
			var attack=0.01, decay=0.01, stutter;
			var rate = 1;
			var env;
			var sig1;
			var sig = in;
			var sig2;
			sig = ( sig * \famp.kr(1));


			bufnum.clear;
			
			bufgate = Duty.kr(1/8*~t, 0, Dseq([
				1,0,1,0,
			],inf));
			choosetrig = bufgate > 0;
			stutter = DC.kr(1/4);
			stutter = Duty.kr(1, 0, Dseq(1/[
				//1,2,4,8,
				16,32,65,64,
			],inf));
			stuttrig = TDuty.ar(stutter, choosetrig + Changed.kr(stutter), 1);
			recordtrig = Trig1.kr(choosetrig, 0.01);
			env = EnvGen.ar(Env([0,1,1,0],[attack, stutter-attack-decay, decay]), stuttrig);
			
			RecordBuf.ar(sig, bufnum, 0, 1, 0, run:bufgate > 0,loop:0,trigger: 1,doneAction:0, recLevel:1, preLevel:0.8);
			sig1 = PlayBuf.ar(2, bufnum, rate:rate, trigger:1,startPos:0, loop:1);
			sig1 = sig1 * 1.2;

			//sig = SelectX.ar( bufgate.lag(0.01), [sig, sig1]);
			sig = sig1;
			sig1 = BPF.ar(sig, SinOsc.kr(1/8).exprange(62, 12000), 0.8);
			sig2 = BPF.ar(sig, SinOsc.kr(1/9).exprange(62,12021), 0.3);
			sig = sig1 + sig2;

			sig = in + sig;
			sig;
		}).play;
//	}
)

Pdef(\fitu).play
Pdef(\fitu).stop
Pdef(\fitu2).play;
Pdef(\fitu2).stop;

TrackGroupDef(\xi, [Pdef(\fitu), Pdef(\fitu2)], TrackGroupType_Player.new);
TrackGroupDef(\xi, [TrackType_Player(Pdef(\fitu)), Pdef(\fitu2)], TrackGroupType_Player.new);
TrackGroupDef(\xi, [PlayerWrapper(Pdef(\fitu)), PlayerWrapper(Ndef(\plop))]);
TrackGroupDef(\xi).edit
TrackGroupDef(\xi).mixer
TrackGroupDef(\xi).grid
TrackGroupDef(\xi).timeline
TrackDef(\yo).edit
TrackDef(\yo).grid
TrackDef(\yo).mixer
TrackDef(\yo).timeline

TrackDef(\yo)[0] = {
	Pbind(
		\instrument, \default,
		\freq, 200,
		\dur, 1,
		\amp, 0.1
	);
}


TrackDef(\yo)[0] = \off -> {
	Pbind(
		\instrument, \default,
		\freq, 200,
		\dur, 1,
		\amp, 0.1
	);
}

TrackDef(\yo)[0] = Codefile(\yep); // exec yep.scd in current project dir
TrackDef(\yo)[0] = Codefile('proj1.yep'); // exec yep.scd in proj1 project dir
TrackDef(\yo).project = Project(\cur); // exec yep.scd in current project dir

Project(\cur).open;
Project.current

TrackDef

ProjectDef(\cur).starter = { arg proj;
	
};

ProjectType(\cur).starter = { arg proj;
	proj.starter;
	proj.
	
}

TrackType(\pat).starter = { arg track;
	track.starter;

};

Pbindef(\fifu2, \octave, 3)

(
TrackGroupDef(\my)[0].source = { arg track;
	Track_Pdef(track);
	
	SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
		var sig, sig1, sig2, sig3;
		sig = SinOsc.ar(freq);
		sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
		sig = Splay.ar(sig, spread, amp, pan);
		Out.ar(out, sig);
	}).add;
	
	track.pdef_init.(Pbind(
		\instrument, ~name,
		\degree, Pseq([0],inf),
		\isRest, track.isrest,
		\dur, 1/4,
		\amp, 0.1 * Pkey(\amp),
	));
};
)

TrackGroupDef(\my)[0][0].source = { arg clip;
	Pdef(clip.name +++ \pre, Pbind(
		\freq, 100,
	));
}

TrackGroupDef(\my)[0] = TrackType(\pdef, { arg track;
	track.putAll(0, 8.collect({ arg x; 
		Pdef(track.name).set(\freq, x*100);
	}))
});
(
TrackGroupDef(\my)[0][0].source = {
	Ndef(~name, {

	})
}
)

TrackGroupDef(\my).clear
TrackGroupDef(\my, [Pdef(\plop)])
TrackGroupDef(\my).at(0).source
TrackGroupDef(\my).at(0).play
TrackGroupDef(\my).at(0).stop
TrackGroupDef(\my)[0].play
TrackGroupDef(\my)[0].stop
TrackGroupDef(\my)[0]
TrackGroupDef(\my).source.atClip(0)
TrackGroupDef(\my).source.atClip
TrackGroupDef(\my).source[\atClip]
TrackGroupDef(\my).source
TrackGroupDef(\my).source.list
TrackGroupDef(\my).source
TrackGroupDef(\my).at(1).source
TrackGroupDef(\my).list[0]
TrackGroupDef(\my).list[0]
TrackGroupDef(\my).sdfdsf
TrackGroupDef(\my).clear
TrackGroupDef.all[\my] = nil

TrackGroupDef(\my)[0].label

PlayerWrapper(TrackGroupDef(\my)[0]).asView.list
PlayerWrapper(TrackGroupDef(\my)[0]).play
PlayerWrapper(TrackGroupDef(\my)[0]).togglePlay
PlayerWrapper(TrackGroupDef(\my)[0]).wrapper
TrackGroupDef(\my)[0].play
TrackGroupDef(\my)[0].isPlaying
TrackGroupDef(\my)[0].player.isPlaying

(
WindowLayout({
	var clipView;
	VLayout (
		VLayout (*
			3.collect { arg idx;
				var p = PlayerWrapper(TrackGroupDef(\my)[idx]);
				var pv = PlayerWrapperView(p);
				var view;
				pv.label = "";
		
				view = View.new.layout_(HLayout (
					pv.view.button.maxWidth_(30),
					StaticText.new.string_("track "++idx++" - "++p.label),
				).margins_(0)).background_(ParamView.color_ligth).maxSize_(200@30).mouseDownAction_({ 
					arg xview, x, y, modifiers, buttonNumber, clickCount;
					[xview, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
					view.background_(ParamView.color_dark);
					clipView.removeAll;
					clipView.layout = p.target.player.target.asParamGroup.asView;

				})
			}
		),
		clipView = View.new,
		//nil
	)
})
)

	ParamProto.init(true);
(
	ParamProto.init;
	~track_player_view = (
		new: { arg self, track;
			self = self.deepCopy;
			
			self.track = track;
		
			self;
		},

		asView: { arg self;
			var view;
			var p = PlayerWrapper(self.track);
			var pv = PlayerWrapperView(p);
			pv.label = "";
			view = View.new.layout_(HLayout (
				pv.view.button.maxWidth_(30),
				StaticText.new.string_(p.label).onChange(p, \changed, {
					view.string_(p.label)
				}),
			).margins_(0)).background_(ParamView.color_ligth).maxSize_(200@30).mouseDownAction_({ 
				arg xview, x, y, modifiers, buttonNumber, clickCount;
				[xview, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
				self.select_hook;
			});
			self.view = view;
			view.addUniqueMethod(\selected, { arg x; self.selected });
			view.addUniqueMethod(\selected_, { arg x; self.selected = x });
			view
		},

		selected: { arg self;
			self.pr_selected;
		},

		selected_: { arg self, val;
			self.pr_selected = val;
			if(val == true) {
				self.view.background_(ParamView.color_dark)
			} {
				self.view.background_(ParamView.color_ligth)
			}
		},


		select_hook: { arg self;
			self.view.background_(ParamView.color_dark);
		},

	);

	~trackgroup_view = { arg trackgroup;
		WindowLayout({

			GridLayout.rows(
				*trackgroup.collect { arg track;
					track.debug("track");
					[
						~track_player_view.new(track).asView,
					] ++ 
					track.collect { arg clip;
						clip.debug("clip");
						~track_player_view.new(clip).asView;
					}
				}
			)
		})
	};

	~player_grid_view = { arg trackgroup, size = (8@8);
		WindowLayout({

			var grid;
			var listview, clipview;
			var selector;
			var selector_views = List.new;
			var select_item_action, track_to_key;
			var listviewdict;
			var selected_track;
			var trackstream = Routine({
				trackgroup.do { arg track;
					track.yield;
				};
				inf.do { nil.yield }
			}).asStream;

			listviewdict = Dictionary.new;

			track_to_key = { arg track;
				[track.label.asSymbol];
			};
			select_item_action = { arg track;
				selected_track = track;
				if(track.isNil) {
					listview.currentItem = nil;
				} {
					listview.currentItem = listviewdict[track_to_key.(track)];
				}
			};

			selector = ~view_selector.new(size.x*size.y);
			selector.select_action = { arg self, view;
				"select_action".debug("!!!");
				view.selected = true;
			};
			selector.deselect_action = { arg self, view;
				"deselect_action".debug("!!!");
				view.selected = false;
			};

			grid = GridLayout.rows(
				*size.y.collect { arg i;
					size.x.collect { arg j;
						var tpv;
						var tpvv;
						var track;
						track = trackstream.next;
						tpv = PlayerWrapperSelectorView(track);
						
						tpv.selectAction = { arg self;
							clipview.removeAll;
							if(track.notNil) {
								clipview.layout = track.asView;
							};
							selector.select_item(i*size.x + j);
							select_item_action.(track);
						};
						tpvv = tpv.asView;
						tpvv.debug("TPVV");
						selector_views.add(tpvv);
						tpvv;
					}
				}
			);
			selector.views = selector_views;

			listview = TreeView.new;
			listview.maxWidth = 300;
			Pdef.all.keys.do { arg lab;
				var key = [lab];
				listviewdict[key] = listview.addItem(key);
			};
			listview.beginDragAction = { arg x, y;
				"plop"
			};
			listview.itemPressedAction = { arg ... args;
				//self.selected_track.source = 
				args.debug("onItemPressedAction");
				selected_track.source = Pdef(args[0].currentItem.strings[0]);
			};

			clipview = View.new;

			HLayout(
				listview,
				VLayout(
					grid,
					clipview,
				)
			)
		})
	};

	~player_grid_view.(TrackGroupDef(\my));
)
(
WindowLayout({
	TrackGroupDef(\my)[0].player.asView
})
)

WindowLayout({ ~vv = PlayerWrapperSelectorView(PlayerWrapper(Pdef(\plop))); ~v = ~vv.asView })
~v.selected = true
~v.selected = \bla
~v.selected
~vv.selected = true
~vv.selected 
~v

PlayerWrapper(nil)
TrackGroupDef(\my)[0].label
TrackGroupDef(\my)[0].wrapper.label("ya")
TrackGroupDef(\my)[0].wrapper.player
TrackGroupDef(\my)[0].wrapper.source
TrackGroupDef(\my)[0].source
TrackGroupDef(\my)[0].player.target
TrackGroupDef(\my)[0].player.label
TrackGroupDef(\my)[0].player
TrackGroupDef(\my)[0].source.source.source
TrackGroupDef(\my)[0].isPlaying
TrackGroupDef(\my)[0].wrapper.isPlaying
TrackGroupDef(\my)[0].play
TrackGroupDef(\my)[0].stop
TrackGroupDef(\my).source = 3
TrackGroupDef(\my).source
TrackGroupDef(\my).wrapper.perform(\source)

TrackGroupDef(\my).clear
TrackGroupDef(\my, [Pdef(\plop), Pdef(\tifu), Pdef(\yapi)])
TrackGroupDef(\my)[0].play
TrackGroupDef(\my)[0].label
TrackGroupDef(\my)[1].play
TrackGroupDef(\my)[0].stop
TrackGroupDef(\my)[0]
TrackGroupDef(\my)[0].label
TrackGroupDef(\my)[0].parent

(
	Pdef(\plop, Pbind(
		\instrument, \default,
		\degree, Pseq([0, Pwhite(0,12,1)],inf),
		\dur, 1/4,
		\amp, 0.4
	));
	Pdef(\plop).addHalo(\instrument, \default);
~cliptype_pat = ProtoClass((
	new: { arg self, parent;
		self = self.deepCopy;
	
		self.myparent = { parent };
		
	
		self;
	},

	play: { arg self;
		if(self.source.notNil) {
			self.source.play;
		}
	},
	
));

~tracktype_pdef = ProtoClass((
	new: { arg self, prefix;
		self = self.deepCopy;
	
		
		self.prefix = prefix;
		self.list = SparseArray.new;
		self.proxy = EventPatternProxy.new;
		self.selected = 0;
	
		self;
	},

	destructor: {},

	initialize: { arg self, inst;
		inst.list = SparseArray.new;
	},

	atClip: { arg self, idx;
		if(self.list[idx].isNil) {
			self.list[idx] = ~cliptype_pat.new;
		};
		self.list[idx]
	},

	play: { arg self;
		if(self.list.size > 0) {
			self.list[self.selected].play;
		}
	},

	stop: { arg self;
		if(self.list.size > 0) {
			self.list[self.selected].stop;
		}
	},

	putClip: { arg self, idx, clip;
		if(self.list[idx].isNil) {
			self.list[idx] = ~cliptype_pat.new;
		};
		self.list[idx].source = clip;
	},
));

~tracktype_base = ProtoClass((
	label: { arg self;
		""
	},

	asPlayerView: { arg self;
		//VLayout

		
	},

	collectClip: { arg self, fun;
		self.list.collect(fun);
	},

	doClip: { arg self, fun;
		self.list.do(fun);
	},

));

~trackGroupType_PlayerWrapper = ProtoClass((
	protoclass: \trackGroupType_PlayerWrapper,

	new: { arg self, plist;
		self = self.deepCopy;
	
		self.parent = ~tracktype_base;
		self.parent.debug("parent of trackGroupType_PlayerWrapper");
		self.list = SparseArray.new;
		self.source = plist;
	
		self;
	},

	source_: { arg self, src;
		src.do { arg x, idx; 
			self.putClip(idx, x)
		};
	},

	source: { arg self;
		self.list;
	},

	newClip: { arg self;
		TrackDef.newInstance(~trackType_PlayerWrapper.new);
	},

	atClip: { arg self, idx;
		idx.debug("atClip: fuck");
		if(self.list[idx].isNil) {
			idx.debug("atClip: fuck nil");
			self.list[idx] = self.newClip;
		};
		self.list[idx]
	},

	play: { arg self;
		self.list.do{ arg x; x.play  };
	},

	stop: { arg self;
		self.list.do{ arg x; x.stop  };
	},

	isPlaying: { arg self;
		self.list.any{ arg x; x.isPlaying  };
	},

	putClip: { arg self, idx, clip;
		if(self.list[idx].isNil) {
			self.list[idx] = self.newClip;
		};
		self.list[idx].source = clip;
	},

	destructor: {},
));

~trackType_PlayerWrapper = ProtoClass((
	parent: ~tracktype_base,
	protoclass: \trackType_PlayerWrapper,
	new: { arg self, player;
		self = self.deepCopy;
	
		
		self.parent = ~tracktype_base;
		self.parent.debug("parent of trackType_PlayerWrapper");
		self.list = SparseArray.new;
		self.player = PlayerWrapper(nil);
		self.source = nil;
		self.selected = 0;
	
		self;
	},

	destructor: {},

	newClip: { arg self;
		//TrackDef.newInstance(~trackType_PlayerWrapper.new);
		~cliptype_pat.new;
	},

	initialize: { arg self, inst;
		inst.list = SparseArray.new;
	},

	source_: { arg self, src;
		self.player.target = src;
		//self.player = PlayerWrapper(src);
	},

	source: { arg self, src;
		if(self.player.notNil) {
			self.player.target;
		} {
			nil;
		}
	},

	atClip: { arg self, idx;
		idx.debug("atClip: fuck");
		if(self.list[idx].isNil) {
			idx.debug("atClip: fuck nil");
			self.list[idx] = self.newClip;
		};
		self.list[idx]
	},

	play: { arg self;
		self.player.play;
	},

	stop: { arg self;
		self.player.stop;
	},

	label: { arg self, key;
		self.player.label
	},

	isPlaying: { arg self;
		self.player.isPlaying;
	},

	putClip: { arg self, idx, clip;
		if(self.list[idx].isNil) {
			self.list[idx] = self.newClip;
		};
		self.list[idx].source = clip;
	},

	asView: { arg self;
		VLayout(Button.new);
	},

));
TrackGroupDef(\my, [Pdef(\plop), Pdef(\tifu), Pdef(\yapi)]);


)
~tracktype.bla
~tracktype_pdef.new(\gabu)
TrackDef.new(\yo, ~tracktype_pdef.new(\gabu))
TrackDef(\yo, \bla)
TrackDef(\yo).at(0)
TrackDef(\yo)[0].source
TrackDef(\yo)[0]
TrackDef(\yo)[0].source = Pdef(\plop)
TrackDef(\yo).source.list[0]
TrackDef.all
TrackDef(\yo).clear
TrackDef(\yo).play
TrackDef(\yo).stop

Pdef(\plop).play
(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0, Pwhite(0,12,1)],inf),
	\dur, 1/4,
	\amp, 0.1
)).play;
);

(
~e = (
	bla:4
);
~e.[\bla_].(~e, 4)
)
