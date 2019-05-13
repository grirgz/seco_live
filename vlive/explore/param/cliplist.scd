
// add a left pane to ClipTimeline to
//	- list current used clips
//	- list added clips
//	- can add clip

(
	ParamProto.init;
ProtoClassDef(\cliplist, (
	parent: ~clipEditor,
	new: { arg self, timeline;
		self = self.deepCopy;
	
		self.init_default_clip_factories;
		self.clipList = List.new;
		self.timeline = timeline;
		self.defineEventFactory;
		self.gatherClips;
		if(self.clipList.size > 0) {
			self.setBrushToClipId(self.clipList.first)
		};
		
		self;
	},

	eventToClipId: { arg self, ev;
		var clipkey;
		ev.debug("eventToClipId: ev");
		if([\rest, \start,\end].includes(ev.type)) {
			nil
		} {
			clipkey	= self.event_to_clipFactory_key(ev); 
			clipkey.debug("clipkey");
			if(clipkey.notNil) {
				[clipkey, self.clipFactories[clipkey].getName(ev)].debug("clipId")
			} {
				Log(\Param).debug("eventToClipId: no clipkey %, ev:%", clipkey, ev);
				nil;
			};
		}
	},

	clipIdToEvent: { arg self, clipId;
		var clipkey = clipId.first;
		var inskey = clipId.last;
		var ev = ();
		var clipfac;
		[clipId, self.clipFactories[clipkey], ev].debug("clipIdToEvent");
		self.clipFactories[clipkey].redefineClip(inskey, ev);
		[ev].debug("clipIdToEvent ev");
		ev
	},

	addClipIdToClipList: { arg self, clipId;
		if(clipId.notNil) {
			if(self.clipList.includesEqual(clipId).not) {
				self.clipList.add(clipId);
				if(self.clipList.size == 1) {
					self.setBrushToClipId(self.clipList.first)
				};
			} {
				Log(\Param).debug("already added");
			}
		} {
			Log(\Param).debug("addClipIdToClipList: no clipId %", clipId);
		};
		self.changed(\clipList);
	},

	clipIdToFactory: { arg self, clipId;
		if(clipId.notNil) {
			var fac = self.clipFactories[clipId.first];
			if(fac.notNil) {
				fac;
			} {
				Log(\Param).debug("addClipIdToClipList: no clipId %", clipId);
				nil;
			}
		} {
			Log(\Param).debug("clipIdToFactory: no clipId %", clipId);
			nil;
		};
	},

	clipIdToTarget: { arg self, clipId;
		var fac = self.clipIdToFactory(clipId);
		fac.className.new(clipId.last);
	},

	addToClipList: { arg self, val;
		var clipId = self.eventToClipId(val);
		self.addClipIdToClipList(clipId);
	},

	gatherClips: { arg self;
		"gat".debug;
		self.timeline.eventList.do { arg clip;
			self.addToClipList(clip)
		}
	},
	
	edit: { arg self;
		WindowDef(\ClipList).front(self);
	},

	clipIdLabel: { arg self, clipId;
		if(clipId.isNil) {
			"nil"
		} {
			"% (%)".format(PlayerWrapper(self.clipIdToTarget(clipId)).label, clipId.first);
		}
	},

	setBrushToClipId: { arg self, clipId;
		self.brushClipId = clipId;
		self.changed(\brushClipId);
	},

	defineEventFactory: { arg self;
		self.timeline.eventFactory = { 
			{ arg pos, nodesize;
				var ev = (absTime: pos.x, midinote: pos.y, legato:1, sustain: nodesize).debug("ev add ###");
				var clipev;
				Log(\Param).debug("ev fac: brush:%, clipev:%", self.brushClipId, clipev);
				if(self.brushClipId.isNil) {
					Log(\Param).debug("No brush selected");
				} {
					clipev = self.clipIdToEvent(self.brushClipId);
					ev.putAll(clipev);
				};
				Log(\Param).debug("ev fac: brush:%, clipev:%", self.brushClipId, clipev);
				ev;
			}
		};
		self.timeline.changed(\eventFactory);
		
	},
));

WindowDef(\newClip, { arg def, model, fac;
	var namefield = TextField.new;
	VLayout (
		HLayout(
			StaticText.new.string_("name:"),
			namefield,
		),
		ListView.new.items_(fac.keylist ++ [""]).action_({ arg view;
			namefield.string = view.items[view.value];
		}),
		HLayout(
			BasicButton.new.string_("Cancel").action_({ arg view;
				def.closeWindow;
			}),
			BasicButton.new.string_("OK").action_({ arg view;
				var name = namefield.string;
				if(name.notNil and: {name.trim != ""}) {
					var inst = fac.className.new(name.asSymbol);
					model.addClipIdToClipList([fac.key, inst.key]);
					def.closeWindow;
				} {
					"no name".debug;
				}
			}),
		)
	)
});

WindowDef(\ClipList, { arg def, model;
	VLayout (
		HLayout (
			BasicButton.new.string_("Add").action_({ arg view;
				var menu = MenuSpec(
					[
						"clipTimeline", 
						"noteTimeline",
					]
				);
				model.gatherClips;
				ContextMenuWindow(menu.labelList.asArray).front(view, view.bounds.rightBottom.x, view.bounds.rightBottom.y).action_({ arg me, idx;
					var key = menu.labelList[idx].value.asSymbol;
					model.clipFactories_keys.debug("keys");
					if( model.clipFactories_keys.includes(key)) {
						WindowDef(\newClip).front(model,model.clipFactories[key])
					} {
						key.debug("no name");
					}
				})
			}),
			//BasicButton.new.string_("open clip timeline").action_({
				//model.timeline.edit
				
			//})
		),
		ListView.new.action_({arg view;
			Log(\Param).debug("action! %", view.value);
			model.setBrushToClipId(model.clipList[view.value]);
		}).enterKeyAction_({arg view;
			Log(\Param).debug("action! %", view.value);
			model.setBrushToClipId(model.clipList[view.value]);
		}).followChange(model, \clipList, { arg view;
			view.items_(model.clipList.collect({ arg clipId;
				model.clipIdLabel(clipId)
			}))
		}),
		HLayout (
			StaticText.new.followChange(model, \brushClipId, { arg view;
				var clipId = model.brushClipId;
				view.string_(
					model.clipIdLabel(clipId)
				)
			}),
			BasicButton.new.string_("Edit").action_({
				model.clipIdToTarget(model.brushClipId).edit;
			})
		)
	)
});
~clipTimelinePanelView.makeLeftPaneLayout = { arg self;
	self.leftPaneView = View.new.layout_(WindowDef(\ClipList).asView(ProtoClassDef(\cliplist).new(self.timeline_model))).maxWidth_(200);
	self.leftPaneView;
};
~clipTimelinePanelView.makeLeftPaneToggle = { arg self;
	BasicButton.new.string_("<")
		.fixedWidth_(20)
		.action_({ arg me;
			if(self.leftPaneView.visible) {
				me.string = "<";
				self.leftPaneView.visible = false;
			} {
				me.string = "^";
				self.leftPaneView.visible = true;
			}
		})
	;
};
)
ProtoClassDef(\cliplist).new(ClipTimeline(\hey)).edit;
ProtoInst(\cliplist, ClipTimeline(\hey)).edit

ClipTimeline(\hey).edit
ClipTimeline(\hey).clear
ClipTimeline(\hey).eventList.reorder
ClipTimeline(\hey).eventList[1][\label].asCompileString
ClipTimeline(\hey).presetCompileString.editorInsert
(
ClipTimeline('hey').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 1.5, \label: 'start', \playDur: 1.5, \relDur: 1.5, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 1.5, \dur: 0.625, \label: "fuck", \legato: 1, \midinote: 0.0, \playDur: 0.625, \relDur: 0.625, \sustain: 2.125, \timeline: { NoteTimeline('ho') }, \type: 'pattern', )),
	PatternEvent((\absTime: 2.125, \dur: 1.25, \legato: 1, \midinote: 3.0, \playDur: 1.25, \relDur: 1.25, \sustain: 0.75, \timeline: { NoteTimeline('ho') }, \type: 'pattern', )),
	PatternEvent((\absTime: 3.375, \dur: 1.375, \label: "hello", \legato: 1, \midinote: 1.0, \playDur: 1.375, \relDur: 1.375, \sustain: 2.25, \timeline: { NoteTimeline('ho') }, \type: 'pattern', )),
	PatternEvent((\absTime: 4.75, \dur: 3.25, \legato: 1, \midinote: 2.0, \playDur: 3.25, \relDur: 3.25, \sustain: 1.625, \timeline: { NoteTimeline('ho') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

(
ClipTimeline('hey').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 3.375, \label: 'start', \playDur: 3.375, \relDur: 3.375, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 3.375, \dur: 1.375, \legato: 1, \midinote: 1.0, \playDur: 1.375, \relDur: 1.375, \sustain: 2.25, \timeline: { NoteTimeline('ho') }, \type: 'pattern', )),
	PatternEvent((\absTime: 4.75, \dur: 3.25, \legato: 1, \midinote: 2.0, \playDur: 3.25, \relDur: 3.25, \sustain: 1.625, \timeline: { NoteTimeline('ho') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

PatternEvent.redefine(())[\label]

(
ClipTimeline(\hey).eventFactory = {{ arg pos, nodesize;
	(absTime: pos.x, midinote: pos.y, legato:1, label:"hhh", sustain: 1).debug("ev add ###");
}};
)
ClipTimeline(\hey).presetCompileString.editorInsert
(
ClipTimeline('hey').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 1.0, \label: 'start', \playDur: 1.0, \relDur: 1.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 1.0, \dur: 2.375, \legato: 1, \midinote: 2.0, \playDur: 2.375, \relDur: 2.375, \sustain: 1.875, \timeline: { NoteTimeline('ho') }, \type: 'pattern', )),
	PatternEvent((\absTime: 3.375, \dur: 0.125, \legato: 1, \midinote: 1.0, \playDur: 0.125, \relDur: 0.125, \sustain: 2.25, \timeline: { NoteTimeline('ho') }, \type: 'pattern', )),
	(\absTime: 3.5, \dur: 4.5, \midinote: 3.0, \playDur: 4.5, \relDur: 4.5, \sustain: 1.0, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

(
ClipTimeline('hey').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 1.0, \label: 'start', \playDur: 1.0, \relDur: 1.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 1.0, \dur: 2.375, \legato: 1, \midinote: 2.0, \playDur: 2.375, \relDur: 2.375, \sustain: 1.875, \timeline: { NoteTimeline('ho') }, \type: 'pattern', )),
	PatternEvent((\absTime: 3.375, \dur: 4.625, \legato: 1, \midinote: 1.0, \playDur: 4.625, \relDur: 4.625, \sustain: 2.25, \timeline: { NoteTimeline('ho') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


NoteTimeline(\ho).edit
NoteTimeline(\ristourne).edit
NoteTimeline(\ho).presetCompileString.editorInsert
(
NoteTimeline('ho').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.25, \midinote: 110.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 0.25, \dur: 0.25, \midinote: 102.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.5, \dur: 0.875, \midinote: 88.0, \playDur: 0.875, \relDur: 0.875, \sustain: 0.1, ),
	(\absTime: 1.375, \dur: 0.875, \midinote: 82.0, \playDur: 0.875, \relDur: 0.875, \sustain: 0.1, ),
	(\absTime: 2.25, \dur: 1.125, \midinote: 69.0, \playDur: 1.125, \relDur: 1.125, \sustain: 0.1, ),
	(\absTime: 3.375, \dur: 0.0, \midinote: 97.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 3.375, \dur: 0.75, \midinote: 63.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.1, ),
	(\absTime: 4.125, \dur: 0.125, \midinote: 27.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 4.25, \dur: 0.25, \midinote: 23.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 4.5, \dur: 0.75, \midinote: 58.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.1, ),
	(\absTime: 5.25, \dur: 0.75, \midinote: 71.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.375, ),
	(\absTime: 6.0, \dur: 0.75, \midinote: 91.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.1, ),
	(\absTime: 6.75, \dur: 0.875, \midinote: 102.0, \playDur: 0.875, \relDur: 0.875, \sustain: 0.1, ),
	(\absTime: 7.625, \dur: 0.375, \midinote: 72.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


////////////////

~clipEditor_FAKE = (
	new: { arg self, model, parent;
		self = self.deepCopy;
	
		self.model = model;
		self.parent_model = {parent};
		//self.makeWindow;
		
		self.init_default_clip_factories;
	
		self;
	},

	init_default_clip_factories: { arg self;
		var tl;
		self.clipFactories = ();

		self.clipFactories.ndef = (
			key: 'ndef',
			label: { arg self; self.key.asString },
			keylist: {
				if(Ndef.all[\localhost].notNil) {
					Ndef.all[\localhost].envir.keys.asArray.sort;
				} {
					[];
				}
			},

			getName: { arg self, ev;
				ev.receiver.value.key;
			},

			editSelected: { arg self, model;
				var player = model.receiver.value;
				if(player.class == PlayerWrapper) {
					player = player.target;
				};
				if(player.getHalo(\edit).notNil) {
					player.getHalo(\edit).value;
				} {
					player.edit;
				}
			},

			redefineClip: { arg me, curname, model;
				PlayerEvent.redefine(model);
				model[\receiver] = PlayerWrapper(Ndef(curname));
				//model.changed(\refresh);
				self.parent_model.changed(\refresh);
			},


		);

		self.clipFactories.pdef = (
			key: 'pdef',
			label: { arg self; self.key.asString },
			keylist: {
				Pdef.all.keys.asArray.sort; 
			},

			getTarget: { arg self, ev;
				// depends pattern event, player event
				if(ev.pattern.isKindOf(Pdef)) {
					// pattern type
					ev.pattern;
				} {
					// player type
					var tar = ev.receiver.value;
					tar.key; // PlayerWrapper has key wrapper
					if(tar.isKindOf(PlayerWrapper)) {
						tar = tar.target;
					};
					if(tar.isKindOf(Pdef)) {
						tar;
					} {
						Log(\Param).error("clipFactories.pdef: ERROR: getTarget: don't know what type!!!");
						nil;
					}; 
				}
				
			},

			getName: { arg self, ev;
				self.getTarget(ev).key;
			},

			editSelected: { arg self, model;
				var player;
				//player = model.receiver.value;
				//player.asParamGroup.debug("Edit: pattern");
				//if(player.class == PlayerWrapper) {
				//	player = player.target;
				//};
				//player.debug("clipeditor: player");
				//player.getHalo(\edit).debug("clipeditor: player, edit");
				player = self.getTarget(model);
				if(player.isKindOf(Pdef)) {
					if(player.getHalo(\edit).notNil) {
						//player.getHalo(\edit).debug("clipeditor: player, halo edit");
						player.getHalo(\edit).value;
					} {
						//player.getHalo(\edit).debug("clipeditor: normal edit");
						player.asParamGroup.edit;
					}
				} {
					"clipFactories.pdef: ERROR: edit: don't know what type!!!".debug;
				}
			},

			redefineClip: { arg me, curname, model;
				PatternEvent.redefine(model);
				model[\pattern] = Pdef(curname);
				//model.changed(\refresh);
				self.parent_model.changed(\refresh);
			},
		);

		self.clipFactories.trackdef = (
			key: 'trackdef',
			label: { arg self; self.key.asString },
			keylist: {
				TrackDef.all.keys.asArray.sort; 
			},

			getName: { arg self, ev;
				ev.receiver.value.key;
			},

			editSelected: { arg self, model;
				var player = model.receiver.value;
				if(player.class == PlayerWrapper) {
					player = player.target;
				};
				if(player.getHalo(\edit).notNil) {
					player.getHalo(\edit).value;
				} {
					if(player[\edit].notNil) {
						player.edit;
					} {
						player.editor.front;
					}
				}
			},

			redefineClip: { arg me, curname, model;
				PlayerEvent.redefine(model);
				model[\receiver] = "{ PlayerWrapper(TrackDef(%)) }".format(curname).interpret;
				//model.changed(\refresh);
				self.parent_model.changed(\refresh);
			},

		);

		// generic timeline factory
		tl = (
			key: 'generictimeline',
			label: { arg self; self.key.asString },

			className: {
				~noteTimeline
			},

			keylist: { arg self;
				self.className.all.keys.asArray.sort;
			},

			getName: { arg self, model;
				model.timeline.key;
			},

			editSelected: { arg self, model;
				model.timeline.edit;
			},

			redefineClip: { arg me, curname, model;
				var tlobj;
				//"redefineClip1".debug;
				PatternEvent.redefine(model);
				//"redefineClip2".debug;

				tlobj = ( "{ " ++ me.className.new(curname).refCompileString ++ " }" ).interpret;
				model[\timeline] = tlobj;
				//model[\timeline] = { 
				//	me.keys.debug("redefineClip3:me.new!!!!!");
				//	me.className.new(curname)
				//};
				//"redefineClip3".debug;
				//model.changed(\refresh);
				self.parent_model.changed(\refresh);
				//"redefineClip4".debug;
			},
		);
		self.clipFactories_timeline_parent = tl;

		[\noteTimeline, \clipTimeline, \envTimeline, \modStepTimeline, \kitTimeline].do { arg key;
			self.clipFactories[key] = (
				key: key,
				parent: tl,
				className: "{ topEnvironment[%] }".format(key.asCompileString).interpret,
			);
		};

		self.clipFactories.sampleTimeline = (
			key: 'sampleTimeline',
			parent: tl,
			className: { SampleTimeline.proto },
		);

		self.clipFactories_keys = self.clipFactories.keys.asArray.sort;
		
	},

	event_to_clipFactory_key: { arg self, model;
		var clipkey;

		// 'Pdef',
		// 'Ndef',
		// 'ClipTimeline',
		// 'SampleTimeline',
		// 'NoteTimeline',
		// 'EnvTimeline',
		// 'ModStepTimeline',
		// 'Tracks',

		switch(model.type, 
			\pattern, {
				if(model.timeline.notNil) {
					if(self.clipFactories_keys.includes(model.timeline.eventType)) {
						clipkey = model.timeline.eventType
					};
					//switch(model.timeline.eventType,
						//\envTimeline, {
							//clipkey = 'envTimeline'
						//},
						//\clipTimeline, {
							//clipkey = 'clipTimeline'
						//},
						//\sampleTimeline, {
							//clipkey = 'sampleTimeline'
						//},
						//\noteTimeline, {
							//clipkey = 'noteTimeline'
						//},
						//\kitTimeline, {
							//clipkey = 'kitTimeline'
						//},
						//\modStepTimeline, {
							//clipkey = 'modStepTimeline'
						//},
					//)
				} {
					//var tar = model.receiver.value;
					//if(tar.isKindOf(PlayerWrapper)) {
					//	tar = tar.target;
					//};
					var tar = model.pattern;
					if(tar.isKindOf(Pdef)) {
						clipkey = 'pdef'
					} {
						//model.debug("event_to_clipFactory_key: pattern: unknown");
					}
				}
			},
			\player, {
				var branch = { arg obj;
					switch( obj.class,
						PlayerWrapper, {
							branch.(obj.target)
						},
						Ndef, {
							'ndef'
						},
						Pdef, {
							'pdef'
						},
						TrackDef, {
							'trackdef'
						},
						{
							//model.debug("event_to_clipFactory_key: player: unknown");
						}
					);
				};
				clipkey = branch.(model[\receiver].value);
			},
			{
				//model.debug("event_to_clipFactory_key: unknown");
				nil
			}
		);
		//clipkey.debug("event_to_clipFactory_key: result");
		clipkey;
	},

	clearEditor: { arg self;
		// when no event selected

		self.type_popup.items = [""];
		self.name_popup.items = [""];
		self.startOffsetField.mapParam(nil);
		self.sustainField.mapParam(nil);
	},

	makeUpdater: { arg self;
		self.controller.remove;
		self.controller = SimpleController(self.model).put(\refresh, {
			var ev = self.model;
			[self.type_popup, ev].debug("entering clipEditor updater");
			if(self.type_popup.isNil or: {self.type_popup.isClosed}) {
				self.controller.remove;
			} {
				var clipkey;
				var clipfac;
				self.refreshPopups;
				clipkey = self.event_to_clipFactory_key(ev);
				clipkey.debug("makeUpdater: clipkey");
				self.startOffsetField.mapParam(Param(self.model, Pembed.startOffsetKey, ControlSpec(0,100,\lin)));
				self.sustainField.mapParam(Param(self.model, Pembed.sustainKey));
				if(clipkey.notNil) {
					clipkey.debug("makeUpdater: clipkey not nil");
					clipfac = self.clipFactories[clipkey];
					self.type_popup.value = self.clipFactories_keys.detectIndex({ arg x; x == clipkey });
					self.name_popup.items = clipfac.keylist;
					self.name_popup.value = self.name_popup.items.detectIndex({ arg x; 
						x == clipfac.getName(ev)
					});

					// FIXME: should use parent_model startOffsetKey to be flexible
				} {
					// selected event not recognized

					self.type_popup.value = nil;
					self.name_popup.value = nil;
				}
			}
		});
	},

	refreshPopups: { arg self;
		var name_popup = self.name_popup;
		self.type_popup.items = self.clipFactories_keys.collect({ arg x; self.clipFactories[x].label });
		self.type_popup.action = {
			name_popup.items = self.clipFactories[ self.clipFactories_keys[self.type_popup.value] ].keylist;
		};
		self.type_popup.valueAction = 0;
	},

	edit_selected: { arg self, model;
		var clipkey, clipfac;
		model = model ? self.model;
		//[model.type, model].debug("Edit: type");
		clipkey = self.event_to_clipFactory_key(model);
		clipfac = self.clipFactories[clipkey];
		clipfac.editSelected(model);
	},

	makeLayout: { arg self;
		var layout;
		var header;
		var editor;
		var type_popup, name_popup;
		var model = self.model;
		//"clipEditor.makeLayout: init".debug;
		type_popup = PopUpMenu.new;
		name_popup = PopUpMenu.new;
		self.name_popup = name_popup;
		self.type_popup = type_popup;
		name_popup.allowsReselection = true;
		//"clipEditor.makeLayout: part 1".debug;
		//type_popup.allowsReselection = true; // lose selection
		//name_popup.items = type_popup.items[type_popup.value].asClass.all.keys.asArray;
		name_popup.action = {
			var curname = name_popup.items[name_popup.value];
			var model = self.model;
			self.clipFactories[self.clipFactories_keys[type_popup.value]].redefineClip(curname, model);
		};

		self.refreshPopups;
		//"clipEditor.makeLayout: part 2".debug;
		self.startOffsetField = TextField.new.fixedWidth_(60);
		self.sustainField = TextField.new.fixedWidth_(60);

		header = HLayout(
			[type_popup, stretch:2],
			[name_popup, stretch:2],
			XSimpleButton.new.label_("Edit").action_({
				self.edit_selected;
			}),
			[HLayout(
				StaticText.new.string_("offset:"),
				self.startOffsetField,
			), stretch:0],
			[HLayout(
				StaticText.new.string_("sustain:"),
				self.sustainField,
			), stretch:0],

		);
		layout = VLayout(
			header,
			editor,
		);

		//"clipEditor.makeLayout: part 3".debug;
		self.layout = layout;
		self.layout;
	},

	makeWindow: { arg self;
		var window = Window.new;
		var layout;
		layout = self.makeLayout;
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;

		self.makeUpdater;
		self.model.changed(\refresh);
	},

);
