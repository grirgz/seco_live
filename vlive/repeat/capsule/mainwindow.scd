
	WindowDef(\main, {
		VLayout (
			* [
				"master" -> { ~master.(); },
				"mixer" -> { ProtoDef(\simpleMixer).edit },
				"rdn" -> { ProtoDef(\rdn).edit },
				"rdn2" -> { ProtoDef(\rdn2).edit },
				"rdn3" -> { ProtoDef(\rdn3).edit },
				"startControl icon" -> { ~startControl.() },
				"startControl piano" -> { ProtoDef(\piano).startControl },
				"basic recorder" -> { ProtoDef(\basicrecorder).edit },
				"init 3 rdn" -> { 
					ProtoDef(\rdn, ProtoTemplateDef(\rdn));
					ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
					ProtoDef(\rdn3, ProtoTemplateDef(\rdn));
				},
			].collect({  arg target;
				BasicButton.new.string_(target.key).action_(target.value)
			})
		)
	});
