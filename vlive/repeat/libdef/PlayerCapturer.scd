
(
ProtoTemplateDef(\PlayerCapturer, (

	capturePlayerHook: { arg self;
		{ arg model;
			Log(\Param).debug("capturePlayerHook %", model);
			self.addPlayer(model);
		}
	},
	startCapture: { arg self;
		Log(\Param).debug("startCapture");
		PlayerWrapper.capturePlayerHook = self.capturePlayerHook;
		self[\isCapturing] = true;
		self.changed(\capturing);
	},

	clearPlayerList: { arg self;
		self.playerList = List.new;
		self.changed(\playerList);
	},

	isCapturing_: { arg self, val;
		if(val == true) {
			self.startCapture
		} {
			self.stopCapture;
		};
	},

	addPlayer: { arg self, player;
		if(player.isKindOf(PlayerWrapper).not) {
			player = PlayerWrapper(player)
		};
		self.playerList = self.playerList ?? { List.new };
		self.playerList.add(player);
		self.changed(\playerList);
	},

	stopCapture: { arg self;
		PlayerWrapper.capturePlayerHook = nil;
		self[\isCapturing] = false;
		self.changed(\capturing);
	},

	loopPreventer: { arg self, fun, defaultResult;
		var res;
		if(self.loopPreventer_flag != true) {
			self.loopPreventer_flag = true;
			res = fun.();
			self.loopPreventer_flag = false;
			res;
		} {
			Log(\Param).debug("PlayerCapturer: loopPreventer prevented a loop: %", self);
			defaultResult;
		}
	},

	play: { arg self;
		self.loopPreventer {
			if(self.playerList.notNil) {
				Server.default.bind {
					self.playerList.do(_.play);
				}
			}
		}
	},

	stop: { arg self;
		self.loopPreventer {
			if(self.playerList.notNil) {
				Server.default.bind {
					self.playerList.do(_.stop);
				}
			};
		}
	},

	isPlaying: { arg self;
		self.loopPreventer ({
			self.playerList.notNil and: { self.playerList.isEmpty.not } and: {
				self.playerList.every(_.isPlaying) 
			}
		}, false)
	},

	edit_list: { arg self;
		WindowDef(\PlayerCapturer, { arg me, model;
			var listview = ListView.new;
			var updatelist = {
				model.playerList = model.playerList ?? { List.new };
				listview.items = model.playerList.as(Array).collect({ arg pw; "% (%)".format(pw.label, pw) });
			};
			listview.followChange(model, \playerList, {
				updatelist.()
			});
			VLayout (
				HLayout (
					PlayerWrapper(model).asView,
					Param(Message(model), \isCapturing, ParamBoolSpec()).asButton,
					BasicButton.new.string_("Remove selected").action_({ 
						if(listview.items.size > 0 and: { listview.value.notNil }) {
							self.playerList.removeAt(listview.value);
						};
						updatelist.();
					}),
				),
				listview
			);
	   
		}).front(self)
	},

	edit: { arg self;
		WindowDef("PlayerCapturer_%".format(self.key).asSymbol, { arg me, model;
			var listview = View.new;
			var updatelist = {
				listview.removeAll;
				model.playerList = model.playerList ?? { List.new };
				listview.layout = VLayout(
					* model.playerList.as(Array).collect({ arg pw, idx; 
						HLayout (
							pw.asView.rightClickEditorEnabled_(true),
							BasicButton.new.string_("X").action_({
								self.playerList.removeAt(idx);
								updatelist.();
							}).maxWidth_(20),
						)
					}) 
					++ [nil];
				);
			};
			me.windowName = model.key;
			listview.followChange(model, \playerList, {
				updatelist.()
			});
			VLayout (
				HLayout (
					PlayerWrapper(model).asView,
					BasicButton.new.string_("Add player").action_({
						WindowDef(\GlobalLibrary_select).front(nil, { arg val; self.addPlayer(val.last.value) }, [
							\Players
						]);
					}),
					Param(Message(model), \isCapturing, ParamBoolSpec()).asButton,

				),
				listview
			);
	   
		}).front(self)
	},
))
)

// END

WindowDef(\bla, { PlayerWrapper(Pdef(\zed)).asView.rightClickEditorEnabled_(true) }).front

ProtoDef(\pc, \PlayerCapturer).edit
ProtoDef(\pc).edit
ProtoDef(\pc).clear
WindowDef(\GlobalLibrary_select)

ProtoDef(\PlayerCapturer).edit
ProtoDef(\PlayerCapturer).isPlaying
ProtoDef(\PlayerCapturer).clearPlayerList
PlayerWrapper.capturePlayerHook
ProtoDef(\PlayerCapturer).playerList
PlayerWrapper(Pdef(\zed)).label

(
SynthDef(\sin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \sin,
		\lpf, 1000,
		\degree, Pseq([0],inf),
		\legato, 0.5,
		\dur, 1,
		\amp, 0.1,
	)
);
);
~t
TempoClock.default.tempo
Pdef(\zed).edit
FileSystemProject
WindowDef(\PbindefEditor).notNil
WindowDef(\PbindefEditor).front(Pdef(\zed))
ProtoDef(\rdn).quant
ProtoDef(\rdn).proxy.quant = Pdef.defaultQuant
Pdef.defaultQuant
s.latency

ClipTimeline(\bla).edit
ClipTimeline(\bla).quant
ClipTimeline(\bla).recorder.play


