
(
	ProtoTemplateDef(\PlayerTracker, (
		new: { arg self;
			ProtoClass((parent: self));
		},
		addPlayer: { arg self ...args;
			args.do  { arg player;
				if(player.isKindOf(PlayerWrapper).not ) {
					player = PlayerWrapper(player);
				};
				if(self.playerList.includesEqual(player).not) {
					self.playerList = self.playerList.add(player);
				};
				player.target.addDependant(self);
			};
			self;
		},
		removeAll: { arg self;
			"clear".debug;
			self.removePlayer(*self.playerList);
		},
		clear: { arg self;
			self.removeAll;
		},
		removePlayer: { arg self ...args;
			args.do  { arg player;
				if(player.isKindOf(PlayerWrapper).not ) {
					player = PlayerWrapper(player);
				};
				self.playerList.remove(player);
				player.target.removeDependant(self)
			};
			self;
		},
		playerList: { arg self;
			self[\playerList] = List.new;
			self[\playerList];
		},
		playingState: { arg self;
			self[\playingState] = Dictionary.new;
			self[\playingState];
		},
		play: { arg self;
			self.captureEnabled = false;
			self.playingState.asAssociations.select(_.value).collect({ arg player;
				player.debug("playing player");
				player.key.play;
			});
			self.captureEnabled = true;
		},
		stop: { arg self;
			self.captureEnabled = false;
			self.playerList.collect({ arg player;
				player.debug("stopping player");
				player.stop;
			});
			self.captureEnabled = true;
		},
		isPlaying: { arg self;
			//"isPlaying".debug;
			self.playerList.any({ arg x; x.isPlaying == true });
		},
		label: { arg self;
			self.key;
		},
		update: { arg self, player, changed, status;
			[ player, changed, status ].debug("update============");
			if(self.playerList.includesEqual(PlayerWrapper(player))) {
				Log(\Param).debug("PlayerTracker: update OK: % is part of %", player, self.key);
				if(self.captureEnabled == true) {
					switch(status,
						\userPlayed, { true },
						\userStopped, { false },
						{ nil },
					) !? { arg shouldplay;
						Log(\Param).debug("shouldplay: %", shouldplay);
						self.playingState[player] = shouldplay;
						Log(\Param).debug("huh: %", shouldplay);
					};
				}
			}
		},
		captureEnabled: true,
		edit: { arg self;
			WindowDef(\playerManager, { arg def;
				VLayout (
					PlayerWrapper(self).asView,
					StaticText.new,
					VLayout(
						*self.playerList.collect({ arg player;
							var view = player.asView.rightClickEditorEnabled_(true);
							//var follower = { arg ...args;
					
							//};
							//player.target.addDependant(follower);
							//view.onClose({ plaer.target.removeDependant(follower) });

							//view.button.followChange(player.target, \PlayerWrapper, { arg but, pw, changed, status;
								////if(a)
					
							//});
							view;
						}) ++ [nil]
					)
				)
			}).front;
		},
	));
)

// END

ProtoDef(\m)
	ProtoDef(\PlayerManager).edit;
	ProtoDef(\PlayerManager).edit;
PlayerWrapper(Pdef(\saw)) == PlayerWrapper(Pdef(\saw))
~pm = ProtoTemplateDef(\PlayerManager).new;
~pm.addPlayer(Pdef(\bla1), Pdef(\bla2), NoteTimeline(\note1))
~pm.removeAll
~pm.playerList.removeEqual
~pm.clear
~pm.playerList
~pm.edit
ProtoDef(\PlayerManager).edit
NoteTimeline(\not)

	FileSystemProject.load("libdef/MainProject.scd"); // LOAD

FileSystemProject("repeat/simpleProject").playerTracker.playerList = []
FileSystemProject("repeat/simpleProject").playerTracker.playerList = []
FileSystemProject("repeat/simpleProject").playerTracker.playingState

ProtoTemplateDef(\filemanager_node_project).keys

FileSystemProject.unresolve("repeat/simpleProject")
FileSystemProject.unresolve( FileSystemProject("repeat/simpleProject").key.asString )
FileSystemProject("repeat/simpleProject").key.asString
	ClipTimeline(\bla).hash
	ClipTimeline(\bla).keysValuesDo { arg k, v;
		[k, v].postln;
		//v.hash;
	};
	~eventTimeline.hash
	ClipTimeline(\bla).recorder.keysValuesDo { arg k, v;
		[k, v].postln;
		//v.hash;
	};

	NoteTimeline(\hih).hash
	SampleTimeline(\hih).hash


	ProtoTemplateDef('SampleClipTimelineMultiTrackRecorder').keys 	
	ProtoTemplateDef('SampleClipTimelineMultiTrackRecorder').hash
	.
	ProtoTemplateDef('SampleClipTimelineMultiTrackRecorder').keysValuesDo { arg k, v;
		[k, v].postln;
		//v.hash;
	};
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \saw,
			\degree, Pwhite(0,10),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

Pdef(\part).clear;
Pdef(\part).edit

(
WindowDef(\win, { arg def;
	VLayout (
		HLayout (
			Button.new,
			Button.new,
			Button.new,
			Button.new,
		),
		HLayout (
			Button.new,
			Button.new,
			Button.new,
			Button.new,
		).spacing_(0).margins_(10),
		nil,
	).spacing_(0)
}).front;
);

(
WindowDef(\win, { arg def;
	VLayout (
		HLayout (
			PlayerWrapperView.new.asView,
			PlayerWrapperView.new.asView,
			PlayerWrapperView.new.asView,
			PlayerWrapperView.new.asView,
		),
		HLayout (
			Button.new,
			Button.new,
			Button.new,
			Button.new,
		),
		HLayout (
			PlayerWrapperView.new.asView,
			PlayerWrapperView.new.asView,
			PlayerWrapperView.new.asView,
			PlayerWrapperView.new.asView,
		).spacing_(0),
		nil,
	).spacing_(0)
}).front;
);


FileSystemProject(\bla)
FileSystemProject('.')
FileSystemProject("..")
FileSystemProject("vlive/repeat/simpleProject")
".".asAbsolutePath

FileSystemProject.relativeToAbsolutePath("./hello")
FileSystemProject.relativeToAbsolutePath(".")
