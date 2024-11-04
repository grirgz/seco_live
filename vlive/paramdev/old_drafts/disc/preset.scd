
~instr_clip = (
	new: { arg self;
		self = self.deepCopy;
	
		
		self.timeline = ~noteTimeline.newInstance;
		self.preset = PresetEvent.new;
		self.stepseq = StepEvent.new;
		self.source = Pbind();
	
		self;
	},

	xasPattern: { arg self;
		self.source <> self.timeline <> self.stepseq <> self.preset;
		
	},
)


////////////////////// 

(
~bank_factory = ProtoClass((
	new: { arg self;
		self = self.deepCopy;
	
		self.bank = BankList.new;
		self.prePattern = Pbind();
		self.postPattern = Pbind();
	
		self;
	},

	asPattern: { arg self;
		self.prePattern <> self.bank.asPattern <> self.postPattern;
	},

	at: { arg self, x;
		self.bank[x]
	},

	new_item: { arg self;
		PresetEvent.new;
	},
));

//~bank_gui_factory = ProtoClass((
//
//));

//~bank_factory.asPattern

)
~bank_factory.class
~bank_factory.asPattern
~bank_factory.asPattern
~bank_factory.new
~bank_factory.at(\asPattern)
~preset_bank = ~bank_factory.new(\PresetBank);
~preset_bank.new(\yep)
Lib
~preset_bank.asCompileString

~bla = Event.newFrom((bla:4,rah:2))
Ndef(\bla).storeOn(Post)

///////////////////////////////////// modStepTimeline bank

// l'idée est qu'au lieu d'une dependance ou l'item a une reference vers le parent qui contient les valeurs par defaut
// l'item n'a aucune idée des valeurs par defaut, elle viennent seulement au playtime par chainage d'event
// mais ou est fait le chainage ? il faut bien passer le pattern a chainer a l'enfant, sinon il n'en sait rien
// - asPattern
// - asView
// le bouton play play-t-il quel pattern, celui de l'item ou du parent ?
// si on utilise uniquement le parent et pas les enfants directement, alors comment le parent sait de quel enfant on parle ?
//		soit l'enfant courant, mais alors comment on accede a plusieurs enfants simultanement ?

// donc soit on fait asPatternAt(idx) et asViewAt(idx), soit on implemente un wrapper a l'item qui prend les parents en compte
// soit on integre directement dans l'item une possibilité de modifier la GUI et le pattern


// tout depend des données qu'on veut heriter du parent
// modStepTimeline
// - drumrack
// clipTimeline
// noteTimeline
// - param
// envTimeline
// - param
// PresetEvent
// - instrument, specs, paramGroup
// Pdef N/A
// - ParamGroup presets
// Ndef N/A
// - ParamGroup presets

// donc finalement on veut juste faire un init() sur les enfants a la creation dans la bank
// difference entre EventPatternProxy et Plazy est que Plazy attend la fin du pattern, le proxy change suivant un quant


ParamProto.init(true)
(
	

)


~modStepTimelineBank.new(\yep).edit
~y = ~modStepTimelineBank.new(\yep)
~y.edit
~y.bank.size
~y.bank[0].edit
~y.bank[0].asView
~modStepTimelineBank.new(\yep).play
~modStepTimelineBank.new(\yep).bank[0]
~modStepTimelineBank.new(\yep).drumrack = DrumRack

MenuSpec
AssociationSpec
MenuSpec((0..4)).map(0.4)
WindowDef(\test, { PopUpMenu.new.mapParam(Param(currentEnvironment, \bla, MenuSpec((0..4)))) }).front
