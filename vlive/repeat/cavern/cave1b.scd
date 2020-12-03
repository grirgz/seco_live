
FileSystemProject.loadOnce("cavern/main.scd");
FileSystemProject.loadOnce("cavern/cave1.scd");
~t = 185/4/60; TempoClock.default.tempo = ~t;


(

Builder(\osc1B, Builder(\oscbuilder)).build; 
Builder(\osc2B, Builder(\oscbuilder)).build; 
Builder(\filter1B, Builder(\filterbuilder)).build; 
Builder(\filter2B, Builder(\filterbuilder)).build; 
Builder(\modosc1B, Builder(\modoscbuilder)).build; 
Builder(\modosc2B, Builder(\modoscbuilder)).build; 
Pdef(\modseq1B, Pmono( \modseq,));
Pdef(\modseq2B, Pmono( \modseq,));

ProtoDef(\modularRackB, ProtoDef(\modularRack)).putAll((
	modules: [
		Builder(\osc1B), Pdef(\osc1B),
		Builder(\osc2B), Pdef(\osc2B),

		Builder(\filter1B), Pdef(\filter1B),
		Builder(\filter2B), Pdef(\filter2B),

		Pdef(\modseq1B),
		Pdef(\modseq2B),

		Builder(\modosc1B), Pdef(\modosc1B),
		Builder(\modosc2B), Pdef(\modosc2B),

		Ndef(\fx1B),
		Ndef(\fx2B),
	],
	edit: { arg self;
		WindowDef(\modularRackB).front;
	},
));

ProtoDef(\modmanagerB, ProtoTemplateDef(\ModulationTable)).putAll((
	paramTags: { arg self;
		TagSpecDef(\modularRack_paramB)
	},
	paramTagLabels: { arg self;
		TagSpecDef(\modularRack_paramlabelB)
	},

));

ProtoDef(\modularRackB).modules.collect { arg module, idx;
	var exclude = [\dur, \legato];
	module.asParamGroup.do { arg param, idx;
		if(param.type == \scalar and: { exclude.includes(param.property).not }) {
			TagSpecDef(\modularRack_paramB).addUnique( param.fullLabel.asSymbol -> param );
			TagSpecDef(\modularRack_paramlabelB).addUnique( param.fullLabel.asSymbol -> param.fullLabel.asSymbol );
		}
	};
};


WindowDef(\modularRackB, { arg def;
	HLayout (
		VLayout (
			WindowDef(\oscbuilder).asView(\osc1B),
			WindowDef(\oscbuilder).asView(\osc2B),
		),
		VLayout (
			HLayout (
				WindowDef(\modseq).asView(Pdef(\modseq1B)),
				WindowDef(\modseq).asView(Pdef(\modseq2B)),
			),
			HLayout (
				WindowDef(\builder_moduleB).asView(\filter1B),
				WindowDef(\builder_module).asView(\filter2B),
			)
		),
		VLayout (
			WindowDef(\builder_module).asView(\modosc1B),
			WindowDef(\oscbuilder).asView(\modosc2B),
		),
		VLayout (
			WindowDef(\fx_module).asView(Ndef(\fx1B)),
			WindowDef(\fx_module).asView(Ndef(\fx2B)),
			WindowDef(\modmanager).asView(ProtoDef(\modmanagerB)),
		),
	)
});


WindowDef(\builder_moduleB, { arg def, name=\osc1;
	var synthView = View.new;
	var builder = Builder(name);
	var pgroup = builder.asParamGroup;
	synthView.followChange(builder, \build, { arg view;
		var patpgroup = Pdef(name).asParamGroup;
		if(Pdef(name).source.isKindOf(Pmono)) {
			patpgroup = ParamGroup(patpgroup.reject({ arg p;
				[\legato,\dur,\adsr].includes(p.property)
			}));
		};
		patpgroup.dump.debug("patgroup");
		view.removeAll;
		view.layout = patpgroup.asView
	});
	//synthView.layout = Pdef(name).asParamGroup.asView;
	//oscType.changed(\set);
	VLayout (
		HLayout (
			*[
			PlayerWrapper(Pdef(name)).label_("").asView,
			StaticText.new.string_("%".format(name)).background_(ParamViewToolBox.color_ligth).align_(\center),
			pgroup[0].asPopUpMenu,
			]
			++
			( pgroup[1] !? {|x| [x.asTextField]} ?? {[]} )
		),
		//builder.asParamGroup.asView,
		synthView,
		nil,
	)
});
)

WindowDef(\builder_moduleB).front(\filter1B)
ProtoDef(\modularRackB).edit
ProtoDef(\modularRack).edit

NoteTimeline(\bla).edit

(
Pdef(\part, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[693].value,
			\bufnum, ~buflib.kick[701].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1459].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1329].value,
			\bufnum, ~buflib.snare[1708].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('vipere/amenbreak.wav'),
		\legato, Pseq([1.91,0.4,1],inf),
		\speed, 1 * (~t/( 137/4/60 )),
		\pos, Pseg(Pseq([0,2,1,2],1),Pseq([4,0,1,0],inf)).loop/(137/4/60),
		\isRest, Pseq([
			Plazy({ arg ev;
				Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
				],1)
			}).loop,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
	),
	Pbind(
		\instrument, \playersec,
		\bufnum, BufDef('vipere/amenbreak.wav'),
		\legato, 1.91,
		\speed, 1/2 * (~t/( 137/4/60 )),
		\pos, Pseg(Pseq([0,2],1),4).loop/(137/4/60),
		\isRest, Pseq([
			Plazy({ arg ev;
				Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
				],1)
			}).loop,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
	),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 0.51,
			\st, ( 92.20/4/60 ) ,
			\speed, 1/1.5 * ~t/ Pkey(\st) ,
			\pos, Pseg(Pseq([
				0,1,1,4,
				0,1,0,3,
				2,1,0,3,
				0,1/2,0,3,
			]/2,1),Pseq([1,0,1,0],inf)).loop/Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
		\isRest, Pseq([
			Plazy({ arg ev;
				Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					].scramble,4),
				],1)
			}).loop,
		],inf).coin.not,
			\dur, 1/16,
			\gain, 1.01,
		)
	]),
).play
)
