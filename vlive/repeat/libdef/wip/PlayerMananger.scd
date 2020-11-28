
(
	ProtoDef(\PlayerManager, (
		playerList: [
			PlayerWrapper(Pdef(\saw)),
		],
		edit: { arg self;
			WindowDef(\playerManager, { arg def;
				VLayout(
					*self.playerList.collect({ arg player;
						var view = player.asView;
						//var follower = { arg ...args;
							
						//};
						//player.target.addDependant(follower);
						//view.onClose({ plaer.target.removeDependant(follower) });
						view.button.followChange(player.target, \PlayerWrapper, { arg ...args;
							args.debug("change!");

						});
						view;
					})
				)
			}).front;
		},
	));
	ProtoDef(\PlayerManager).edit;
)
