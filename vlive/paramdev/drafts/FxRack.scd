
// have a pile a fx that can be reordered
// run with Pmono and GroupDef

(
	FileSystemProject.loadOnce("cavern/ifxsimple.scd");
	FileSystemProject.loadOnce("paramdev/drafts/FormEntryMod.scd"); 
	FileSystemProject.loadOnce("paramdev/drafts/SynthDefPreset.scd"); 

	ProtoTemplateDef(\InsertFxItem, (
		new: { arg self, parent, idx, proxy;
			self = ProtoClass((parent: self));

			self.index = idx; // only to distinguish Pdef but not index of fxList
			self.parentRack = parent;
			if(proxy.isKindOf(Symbol)) {
				var name = self.groupDefName;
				self.label = "% %".format(proxy, idx);
				self.proxySynthDef = proxy;
				self.proxy = Pdef(name,
					Pmono(proxy,
						\out, Pfunc({ self.parentRack.inBus }),
						\group, GroupDef.pattern(name, self.parentRack.groupDefPattern, \addToTail),
					),
				);
			} {
				self.proxy = proxy;
			};
		
			
		
			self;
		},

		groupDefName: { arg self;
			"%_fx_%".format(self.parentRack.rackKey, self.index).asSymbol;
		},

		presetCompileString: { arg self, idx, refCompileString;
			var ref = "%.fxList[%].proxy".format(refCompileString ?? { self.parentRack.refCompileString }, idx);
			self.proxy.asParamGroup.getSetCompileString(ref);
		},

		asParamGroup: { arg self;
			self.proxy.asParamGroup;
		},

		refCompileString: { arg self;
			var idx = self.parentRack.fxList.indexOf(self);
			"%.childAt(%)".format(self.parentRack.refCompileString, idx);
		},

		asPattern: { arg self;
			self.proxy
		},

	));

	ProtoTemplateDef(\InsertFxRack, (

		addFx: { arg self, proxy;
			var wrapper;
			self.fxNextIndex = ( self.fxNextIndex ? -1 ) + 1;
			wrapper = ProtoTemplateDef(\InsertFxItem).new(self, self.fxNextIndex, proxy);
			self.fxList = self.fxList.add(wrapper);
			self.updateProxy;
			self.changed(\fxList);
		},

		synthDefNameStack: { arg self;
			self.fxList.collect { arg item, idx;
				item.proxySynthDef
			} ?? { [] };
		},

		synthDefNameStack_: { arg self, list;
			self.fxList = List.new;
			if(list.isKindOf(Number)) {
				"%.synthDefNameStack_: type not supported: %".format(self.refCompileString, list.asCompileString).error;
			} {
				list.do { arg item, idx;
					self.addFx(item)
				};
			};
		},

		removeFxAt: { arg self, idx;
			var fx;
			[idx, self.fxList].debug("removeFxAt");
			fx = self.fxList.removeAt(idx);
			[idx, self.fxList].debug("removeFxAt done");
			self.updateProxy;
			self.changed(\fxList);
		},

		moveNodeTo: { arg self, fromidx, toidx;
			var fx;
			var nextfx;
			//if(fromidx == ( toidx - 1 )) { // trick to allow inserting in last place
				//var tmp = fromidx;
				//fromidx = toidx;
				//toidx = tmp;
			//};
			if(fromidx > toidx) {
				
				fx = self.fxList[fromidx];
				nextfx = self.fxList[toidx];

				self.fxList[fromidx] = nil;
				self.fxList = self.fxList.insert(toidx, fx).select(_.notNil);
				GroupDef(fx.groupDefName).moveBefore(GroupDef(nextfx.groupDefName));
			} {
				if(toidx == ( self.fxList.size-1 )) {
					var prevfx;

					fx = self.fxList.removeAt(fromidx);
					prevfx = self.fxList[toidx-1];

					self.fxList = self.fxList.add(fx);
					GroupDef(fx.groupDefName).moveAfter(GroupDef(prevfx.groupDefName));
				} {
					fx = self.fxList.removeAt(fromidx);
					nextfx = self.fxList[toidx];

					self.fxList = self.fxList.insert(toidx, fx).select(_.notNil);
					GroupDef(fx.groupDefName).moveBefore(GroupDef(nextfx.groupDefName));
				};
			};
			self.changed(\fxList);
		},

		monitorProxy: { arg self;

			var first;
			var group;
			var grouplist;

			grouplist = self.fxList.collect { arg fx, idx;
				fx.groupDefName
			};
			if(grouplist.size > 0) {
				first = grouplist.removeAt(0);
				first.debug("quoi ?");
				// create the group list directly to be sure of the order
				group = grouplist.inject(GroupDef.pattern(first, self.groupDefPattern), { arg a, b; 
					"inject: GroupDef.pattern(%, %, \addAfter)  ".format(b, a).debug;
					GroupDef.pattern(b, a, \addAfter) 
				});
			} {
				group = 1;
			};
			self.groupStack = group;
			
			if(self[\monitorProxy_obj].isNil) {
				self[\monitorProxy_obj] = EventPatternProxy.new.source_(Pmono(\ifx_out,
					\out, Pfunc({ self.outBus }),
					\inbus, Pfunc({ self.inBus }),
					\mkg, Plazy({ arg ev;
						//~group = group;
						self.groupStack;
						//Pn(1,inf).embedInStream(ev);
					}),
					\group, self.groupDefPattern,
					//\group, group,
					\addAction, \addAfter,
				));
			};
			self[\monitorProxy_obj]
		},

		outBus: { arg self;
			0
		},

		updateProxy: { arg self;
			if(self.proxy.isNil) {
				self.proxy = EventPatternProxy.new;
			};
			if(self.fxList.size == 0) {
				self.proxy.source = self.monitorProxy;
			} {
				self.proxy.source = Ppar(self.fxList.collect(_.asPattern) ++ self.monitorProxy);
			};
		},
		play: { arg self;
			self.updateProxy;
			self.proxy.play;
		},

		stop: { arg self;
			self.proxy.stop;
		},

		fxBus: { arg self;
			self.inBus;
		},

		inBus: { arg self;
			BusDef(self.rackKey, \audio, 2)
		},

		isPlaying: { arg self;
			self.proxy.notNil and: {
				self.proxy.isPlaying;
			}
		},

		rackKey: { arg self;
			self.key;
		},
		groupDefName: { arg self;
			"%_mainGroup".format(self.rackKey).asSymbol;
		},
		groupDefPattern: { arg self;
			GroupDef.pattern(self.groupDefName)
		},
		groupDef: { arg self;
			GroupDef(self.groupDefName)
		},

		edit:{ arg self;
			self.editor.front(self)
		},
		asView: { arg self;
			self.editor.asView(self)
		},
		editor: { arg self;
			WindowDef(\InsertFxRack)
		},

		refCompileString: { arg self;
			//"ProtoTemplateDef(%)".format(self.key.asCompileString)
			self.asCompileString;
		},

		presetCompileString: { arg self, refCompileString;
			var str = List[];
			var ref;
			var namestack = self.fxList.collect { arg item, idx;
				item.proxySynthDef
			}.asCompileString;
			ref = refCompileString ?? { "ProtoDef(%, %)".format(self.key.asCompileString, self.parent.asCompileString) };
			str.add("%.synthDefNameStack = %;".format(ref, namestack));
			self.fxList.do { arg item, idx;
				str.add(item.presetCompileString(idx, refCompileString))
			};
			str.join("\n")
			
		},

		savePreset: { arg self, key;
			self.presetBank.savePreset(key);
		},

		loadPreset: { arg self, key;
			self.presetBank.loadPreset(key);
		},

		presetBank: { arg self;
			if(self[\presetBank_obj].isNil) {
				self[\presetBank_obj] = ProtoTemplateDef(\PresetGraphBank).new((
					main: ParamGroup([
						Param(Message(self), \synthDefNameStack),
					].flat),
					items: {
						self.fxList.collect({ arg fx;
							(main: fx.asParamGroup)
						})
					}
				))
			};
			self[\presetBank_obj];
		},

		asParamGroup: { arg self;
			ParamGroup([
				Param(Message(self), \synthDefNameStack),
				self.fxList.collect { arg item, idx;
					item.asParamGroup.asArray;
				}
			].flat)
			
		},

		childAt: { arg self, idx;
			self.fxList[idx];
		},

		elAt: { arg self, idx;
			self.childAt(idx)
		},
	));

	WindowDef(\InsertFxRack, { arg def, model;
		var fxlistview = View.new;
		var scrollview = ScrollView.new;
		var updateView = {
			fxlistview.removeAll;
			fxlistview.layout = VLayout (
				* model.fxList.collect { arg fx, idx;
					var fxpgview = View.new;
					var labelview = View.new;
					fxpgview.layout = VLayout(*fx.proxy.asParamGroup.rejectByProperty([ \adsr, \out,\dur,\legato ]).collect({ arg p; WindowDef(\FormEntryMod).asView(p) }));
					fxpgview.background_(Color.white);
					fxpgview.visible = false;
					labelview.background_(ParamViewToolBox.color_ligth);
					VLayout (
						labelview.layout_(HLayout (
							StaticText.new.string_(" " ++ fx.label).mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
								[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
								if(buttonNumber == 1) {
									Menu(
										MenuAction("Remove Fx", {
											model.removeFxAt(idx);
										})
									).front;
									
								} {
									fxpgview.visible = fxpgview.visible.not;
								};
							}).background_(ParamViewToolBox.color_ligth),
							Param(fx.proxy, \wet).asSlider.orientation_(\horizontal).maxWidth_(140),
							Param(fx.proxy, \gain).asSlider.orientation_(\horizontal).maxWidth_(140),
							DragBoth.new.object_(idx).fixedWidth_(20).string_(idx).align_(\center)
							.receiveDragHandler_({
								var oldidx = View.currentDrag;
								model.moveNodeTo(oldidx, idx);
							})
							,
						).margins_(2)),
						fxpgview,
					).spacing_(0)
				} ++ [nil]
			)
		};
		fxlistview.followChange(model, \fxList, {
			updateView.()
		});
		VLayout (
			HLayout (
				PlayerWrapper(model).asView,
				BasicButton.new.string_("Add").action_({
					WindowDef(\GlobalLibrary_select).front(nil, { arg libid;
						//libid.debug("libid");
						model.addFx(libid.last.key);
				   
					}, [\SynthDef])
				}),
				Param(Message(model), \inBus, TagSpecDef(\BusDef)).asPopUpMenu,
				Param(Message(model), \outBus, TagSpecDef(\BusDef)).asPopUpMenu,
			),
			scrollview.canvas_(fxlistview)
		)
		
	});
)

// END

ProtoTemplateDef(\InsertFxRack).edit
ProtoDef(\fx, \InsertFxRack)
ProtoDef(\fx).edit
ProtoDef(\fx).presetCompileString("kjkj").editorInsert
ProtoDef(\fx).presetBank.printTree
ProtoDef(\fx).presetBank.printTree(~pr)
ProtoDef(\fx).presetBank.printCurrentPreset
ProtoDef(\fx).presetBank.loadPresetFromObject(~pr)
ProtoDef(\fx).fxList
~pr
~pr = ProtoDef(\fx).presetBank.getCurrentPreset
ProtoDef(\fx).presetBank.presetScheme.items.value
ProtoDef(\fx).savePreset(\preset1)
ProtoDef(\fx).loadPreset(\preset1)
(
kjkj.synthDefNameStack = [ 'ifx_echo' ];
kjkj.fxList[0].proxy.setVal('wet', 1.0);

);
#
ProtoTemplateDef(\PresetGraphBank).new()
(
kjkj.synthDefNameStack = [ 'ifx_echo' ];
kjkj.fxList[0].proxy.setVal('wet', 1.0);

);
(
kjkj.synthDefNameStack = [ 'ifx_echo' ];
kjkj.fxList[0].proxy.setVal('wet', 1.0);

);
(
ProtoDef('fx', ProtoTemplateDef('InsertFxRack')).synthDefNameStack = [ 'ifx_echo' ];
ProtoDef('fx').fxList[0].proxy.setVal('wet', 1.0);

);
(
ProtoDef('fx', ProtoTemplateDef('InsertFxRack')).synthDefNameStack = [ 'ifx_echo' ];
ProtoDef('fx').fxList[0].proxy.setVal('wet', 1.0);

);

ProtoTemplateDef(\InsertFxRack).fxList.collect
ProtoTemplateDef(\InsertFxRack).fxList
ProtoTemplateDef(\InsertFxRack).fxNextIndex
~g2 = GroupDef(ProtoTemplateDef(\InsertFxRack).fxList.first.groupDefName)
~g1 = GroupDef(ProtoTemplateDef(\InsertFxRack).fxList[1].groupDefName)
~g1.moveAfter(~g2)
WindowDef(\FormEntryMod)

NoteTimeline(\bla).edit
NoteTimeline(\bla).eventList[2]
NoteTimeline(\hoho).edit

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\type, \locator,
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

ClipTimeline(\haz).edit
