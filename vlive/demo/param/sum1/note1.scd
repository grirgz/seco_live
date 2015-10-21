
///////////////////// preset + noteTimeline

(
ParamProto.init(true);

	SynthDef(\rlpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = LFSaw.ar(freq);
		sig = RLPF.ar(sig, \lpf.kr(4100), \rq.kr(0.5));
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;

~presetEvent = PresetEvent.new;
~presetEvent[\instrument] = \rlpf;
~presetEvent[\dur] = 1/4;

~nt = ~noteTimeline.new(\yepy, Param(~presetEvent, \midinote));
//~nt.asView
//~noteTimelinePanelView.newView(~nt).makeLayout
~nt.composeParamPattern = false;

Pdef(\main,
	~nt.xasPattern.loop 
	//<> Prout({ arg ev; ev[\freq] = Event.default[\freq]; ev })
	//<> Prout({ arg ev; ev })
	<> Pn(~presetEvent).collect({ arg ev; ev[\freq] = Event.default[\freq]; ev })
);

WindowLayout({

	VLayout (
		PlayerWrapper(Pdef(\main)).asView,
		~presetEvent.asView,
		~noteTimelinePanelView.newView(~nt).make_header_(nil).makeLayout,
		nil,
	)
});



)

		~noteTimelinePanelView.newView(~nt).makeLayout;
~nt.xasPattern.asStream.nextN(10,Event.default)
~nt.xasPattern.asStream
~nt.eventlist
~nt.param.target
~nt.param.wrapper


//////////////////////////// tracklist: preset + noteTimeline 



(
//"~/code/sc/seco/vlive/demo/param/lib/timeline.scd".standardizePath.load;
Spec.add(\gate, XGateSpec());
Spec.add(\out, XBusSpec(\audio));
	SynthDef(\rlpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = LFSaw.ar(freq);
		sig = RLPF.ar(sig, \lpf.kr(4100), \rq.kr(0.5));
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;

	SynthDef(\pulserlpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = LFPulse.ar(freq);
		sig = RLPF.ar(sig, \lpf.kr(4100), \rq.kr(0.5));
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;

	~note_track = (
		new: { arg self, name, instr;
			self = self.deepCopy;
		
			
			self.instr = instr;
			self.presetEvent = PresetEvent.new;
			self.presetEvent[\instrument] = instr;
			self.noteTimeline = ~noteTimeline.new(name, Param(self.presetEvent, \midinote));
			self.noteTimeline.composeParamPattern = false;
			self.playerProxy = EventPatternProxy.new;
			self.playerProxy.source = self.as_pattern;
		
			self;
		},

		as_pattern: { arg self;
			(Plazy({ self.noteTimeline.xasPattern })  <> Plazy({ self.presetEvent }).loop).loop;
		},

		makeLayout: { arg self;
			VLayout(
				PlayerWrapper(self.playerProxy).label_("yep").asView,
				ParamGroupLayout.two_panes(self.presetEvent.asParamGroup, \property),
				~stepEventView.new(self.stepEvent, self.presetEvent.asParamGroup).makeLayout,
			)
		},

		makeWindow: { arg self;
			var window = Window.new;
			var layout;
			layout = self.makeLayout;
			window.layout = layout;
			//window.alwaysOnTop = true;
			window.front;
			
		},

	);

	~track_creator_dialog = (
		new: { arg self, instr_list, action;
			self = self.deepCopy;
		
			self.instr_list = instr_list;	
			self.action = {action};
		
			self;
		},

		makeLayout: { arg self;
			var popupmenu;
			VLayout(
				popupmenu = PopUpMenu.new.items_(self.instr_list).action_({

				}),
				HLayout(
					XSimpleButton.new.label_("OK").action_({
						self.action.(popupmenu.items[popupmenu.value].asSymbol);
						self.window.close;
					}),
					XSimpleButton.new.label_("Cancel").action_({
						self.window.close;
					})
				),
				nil,
			)
		},

		makeWindow: { arg self;
			var window = Window.new;
			var layout;
			self.window = window;
			layout = self.makeLayout;
			window.layout = layout;
			//window.alwaysOnTop = true;
			window.front;
		},

	);

	~multitrack = (
		new: { arg self, instr_list;
			self = self.deepCopy;
		
			self.tracks = List.new;
			self.instr_list = instr_list;
			self.playerProxy = EventPatternProxy.new;
			self.playerProxy.source = self.xasPattern;
		
			self;
		},

		xasPattern: { arg self;
			Plazy({
				if(self.tracks.size > 0) {
					Ppar(
						self.tracks.collect({ arg track; track.as_pattern });
					)
				} {
					Event.silent(1)
				}
			}).loop
		},

		add_track: { arg self, instr;
			self.tracks.add(
				~note_track.new(\track+++self.tracks.size, instr)
			)
		},

		update_tracks_view: { arg self;
			self.tracks_view.removeAll;
			self.tracks_view.layout = GridLayout.rows(
				* self.tracks.collect({ arg track;
					[
						VLayout (
							XSimpleButton.new.label_(track.instr).action_({
								WindowLayout({
									VLayout (
										ParamGroupLayout.two_panes(track.presetEvent.asParamGroup.select(
											{ arg x; x.type != \other }
										), \property),
										nil
									)
								})
							}),
							Param(track.presetEvent, \amp).asSlider.orientation_(\horizontal),
							nil,
						),
						~noteTimelinePanelView.newView(track.noteTimeline).make_header_(nil).makeLayout,
					]
				})
			);
			self.tracks_view.layout.setColumnStretch(0,0);
			self.tracks_view.layout.setColumnStretch(1,1);
		},

		makeLayout: { arg self;
			var header;
			self.tracks_view = View.new;
			header = HLayout(
				PlayerWrapper(self.playerProxy).asView,
				XSimpleButton.new.label_("+").action_({
					~track_creator_dialog.new(self.instr_list, { arg instr;
						self.add_track(instr);
						self.update_tracks_view;
					}).makeWindow;
				})
			);
			self.layout = VLayout(
				header,
				self.tracks_view,
			);
			self.update_tracks_view;

			self.layout;
		},

		makeWindow: { arg self;
			var window = Window.new;
			var layout;
			layout = self.makeLayout;
			window.layout = layout;
			//window.alwaysOnTop = true;
			window.front;
		},
	);

	~mt = ~multitrack.new([\rlpf, \pulserlpf]);
	~mt.makeWindow;
)


////////////////////////////////////////



(
	~vertical_sequencer = (
		new: { arg self;
			self = self.deepCopy;
		
			
		
			self;
		},

		add_track: { arg self, instr;
			self.preset_list.add_track(instr);
			self.stepseq_list.add_track(instr);
		},

		makeLayout: { arg self;
			GridLayout.columns(
				[
					self.preset_list.makeLayoutList,
					self.stepseq_list.makeLayoutList,
				]
			)
		},

		xasPattern: { arg self;
			Ppar(
				~pchain_column.(
					self.preset_list.asPatternList,
					self.stepseq_list.asPatternList,
				)
			)
		},
	)
)

~drumrack.new(\yep)

~drumrack.new(\yep).add_stage(~stepseq.new(\seq))

~preset_list.new(\yep).chain( ~stepseq.new(\seq) )

~pchain.new(\chain, [
	~preset_list.new(\preset),
	~stepseq_list.new(\seq),
])


// needs
- library of instr
- parallel instr with shared score
- can add arbitrary stage



// parts
- pattern <>
- gui HLayout


PchainExpand(
	[
		PresetEvent.new <> CurvePreset,
		PresetEvent.new <> CurvePreset,
	],
	StepEvent.new,
)

s == Server.default


// thougts
- je ne devrais pas essayer de faire trop generique et trop reutilisable, le code est deja assez concis comme ca, je devrais plutot essayer d'ecrire mes propres interfaces sans essayer d'avoir la possibilité d'ajouter des stages au runtime, ca a l'air genial mais ca complique pas mal alors que c'est plutot l'incertitude qui reigne quand a la forme reelle et la forme finale que ca va avoir
* donc faut que j'ecrive ma class de stepseq+drumrack et que je fasse de la zic!!


