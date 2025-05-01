
FileSystemProject.loadOnce("libdef/apc.scd");

(

TrackTemplateDef(\PlayerGridSection).splitAndAssignPattern = { arg self, pat;
	var list = [];
	pat = pat ?? { Pdef(\part) };
	if(pat.source.isKindOf(Pdef)) {
		pat = pat.source;
	};
	if(pat.source.isKindOf(Ppar)) {
		var prefix = self.trackKey;
		list = pat.source.list;
		list = list.collect { arg item, idx;
			//item.debug("splitAndAssignPattern: item");
			Pdef("%_%".format(prefix, idx).asSymbol, item);
		};
	};
	self.source = list;
};

ProtoDef(\apc40).callback_scene_button = { arg self, idx;
	if(self.shiftModifier == true) {
		idx.debug("assign_splitpart");
		self.grid.sectionAtOffset(idx).splitAndAssignPattern;
		//~assign_splitpart.(self.grid, Pdef(\part), player.target.index, ( self.grid.trackKey++\_split ).asSymbol);
		self.render_grid;
		false;
	};
};

);

(
TrackDef(\split_extra, \PlayerGrid);
TrackDef(\split_extra).enableAutoSetOutbus = false;
TrackDef(\split_extra).enableOnePlayerPerTrack = false;
TrackDef(\split_extra).isMixerEnabled = false;

ProtoDef(\apc40).extra_playergrid = TrackDef(\split_extra);

TrackDef(\split_extra).source = [ 
	[ Pdef(\part), Pdef(\part2), Pdef(\part3), Pdef(\part4) ],
	[ ProtoDef(\rdn), ProtoDef(\rdn2), ProtoDef(\rdn3), ProtoDef(\rdn4) ],
	[ ProtoDef(\FxManager)],
];

ProtoDef(\apc40).quickpad[0][0] = {
	"quick yes!".debug;
};

ProtoDef(\apc40).gridBank = [ TrackDef(\split, \PlayerGrid), TrackDef(\splitdrum, \PlayerGrid) ];

////// fx pads
ProtoDef(\apc40).quickfxpad[0] = { arg self, apc, track, point;
	var fx = track.mixer.insertFxAt(8+point.y);
	fx.synthName = \ifx_stutter;
	fx.enabled = true;
	apc.ktl.elAt(\kn, \t, point.x).mapParam(fx.getParam(\time).withSpec(TagSpec([1,1/2,1/4,1/8]/~t)));
	fx.getParam(\wet).set(1);
	fx.getParam(\mix).set(1);

	self[\stop] = {
		var fx = track.mixer.insertFxAt(8+point.y);
		fx.getParam(\wet).set(1);
		fx.getParam(\mix).set(0);
	}
};
ProtoDef(\apc40).quickfxpad[1] = { arg self, apc, track, point;
	var fx = track.mixer.insertFxAt(8+point.y);
	fx.synthName = \ifx_rlpf;
	fx.enabled = true;
	apc.ktl.elAt(\kn, \t, point.x).mapParam(fx.getParam(\lpf));
	fx.getParam(\wet).set(1);
	fx.getParam(\mix).set(1);

	self[\stop] = {
		var fx = track.mixer.insertFxAt(8+point.y);
		fx.getParam(\wet).set(1);
		fx.getParam(\mix).set(0);
	}
};
ProtoDef(\apc40).quickfxpad[2] = { arg self, apc, track, point;
	//track.mixer.getParam(\postfader).set(0.ampdb);
	track.mixer.getParam(\send5).set(1);

	self[\stop] = {
		track.mixer.getParam(\send5).set(0);
	}
};
)
