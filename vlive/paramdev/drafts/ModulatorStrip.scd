
//////// ModulatorStrip
// ModulatorStrip draw a strip that mimic a timeline and draw its events with modulation data inside
// ModulatorStripEventModel is created by ModulatorStrip GUI to interact with the event from the timeline
// ModulatorStrip_generic and ModulatorStrip_slider are standalone version of the GUI that use Param as model instead of a timeline

ProtoTemplateDef(\ModulatorStrip, (
	new: { arg self, fxtimeline;
		self = ProtoClass((parent:self));
	
		self.fxTimelinePanel = {fxtimeline}; // the panel view
	
		self;
	},
	masterTimeline: { arg self;
		self.fxTimelinePanel.timeline;
		
	},

	timelineModel: { arg self;
		self.fxTimelinePanel.timeline_model;
	},

	edit: { arg self;
		WindowDef(\ModulatorStrip).front(self)
	},
	asView: { arg self;
		WindowDef(\ModulatorStrip).asView(self)
	},

	levelList: { arg self;
		if(self[\levelList_obj].isNil) {
			self[\levelList_obj] = SparseArray(16, 0);
		};
		self[\levelList_obj];
	},

));

ProtoTemplateDef(\ModulatorStripEventModel, (
	new: { arg self, strip;
		self = ProtoClass((parent:self));
	
		self.strip = strip;
		
		self.wrapperDict = (
			raw: ProtoTemplateDef(\ModulatorStripEventModel_raw).newMode(strip),
			step: ProtoTemplateDef(\ModulatorStripEventModel_step).newMode(strip),
			modenv: ProtoTemplateDef(\ModulatorStripEventModel_modenv).newMode(strip),
			lfosin: ProtoTemplateDef(\ModulatorStripEventModel_lfosin).newMode(strip),
		);
	
		self;
	},

	newMode: { arg self, strip;
		self = ProtoClass((parent:self));
	
		self.strip = strip;
		
	
		self;
	},

	wrapperFor: { arg self, ev, key;
		var modtype;
		key = key ?? { self.selectedParam.propertyRoot };
		//if(ev.modulatorType.notNil and: { ev.modulatorType[key].notNil }) {
			//modtype = ev.modulatorType[key];
		//};
		modtype = self.getModulatorType(ev, key);
		//modtype = modtype ?? { self.strip.selectedModulatorType };
		//[modtype].debug("wrapperFor: modtype");
		//[ self.wrapperDict.keys].debug("wrapperFor: keys");
		self.wrapperDict[modtype];
	},

	drawEventContent: { arg self, ev;
		self.wrapperFor(ev).drawEventContent(ev)
	},

	drawBar: { arg self ...args;
		self.strip.drawBar(*args)
	},

	colors: { arg self;
		self.strip.colors;
	},
	xlenkey: \sustain,
	xkey: \absTime,
	cellWidth: 1/8,

	selectedParam: { arg self;
		self.strip.selectedParam
	},

	selectedTrackParam: { arg self;
		self.strip.selectedTrackParam
	},

	selectedModulatorType: { arg self;
		self.strip.selectedModulatorType;
	},

	view: { arg self;
		self.strip.view;
	},

	setEventContent: { arg self, ev, idx, val, direction=1, pxpos;
		// val is already full spec

		self.wrapperFor(ev).setEventContent(ev, idx, val, direction, pxpos);

	},

	getModulatorType: { arg self, ev, key;
		if(ev.localMod.notNil and: {ev.localMod[key].notNil} and: {ev.localMod[key].modulatorType.notNil}) {
			ev.localMod[key].modulatorType;
		} {
			\raw
		};
	},

	setModulatorType: { arg self, ev, key, val;
		if(ev.localMod.isNil) {
			ev.localMod = ();
		};
		if(ev.localMod[key].isNil) {
			ev.localMod[key] = ();
		};
		ev.localMod[key].modulatorType = val;
	},

	isModulatorDefined: { arg self, ev, key, modtype;
		modtype = modtype ?? { self.modulatorType };
		ev.localMod.notNil and: {ev.localMod[key].notNil and: {ev.localMod[key][modtype].notNil}}
	},

	getModulatorData: { arg self, ev, key, modtype, defaultFun;
		self.getModulatorDataAndIsSet(ev, key, modtype, defaultFun).first;
	},

	getAndCreateModulatorData: { arg self, ev, key, modtype, defaultFun;
		var mod, seq, isSet = true;
		modtype = modtype ?? { self.modulatorType };
		defaultFun = defaultFun ?? { { self.defaultData } };
		if(ev.localMod.isNil) { // do not create if not existing
			ev.localMod = ();
		};
		if(ev.localMod[key].isNil) { // do not create if not existing
			ev.localMod[key] = ();
		};
		if(ev.localMod[key][modtype].isNil) { // do not create if not existing
			[mod, key, modtype].debug("running defaultFun").debug;
			[ ev].debug("running defaultFun ev").debug;
			ev.localMod[key][modtype] = defaultFun.value;
		};
		ev.localMod[key][modtype]
	},

	getModulatorDataAndIsSet: { arg self, ev, key, modtype, defaultFun;
		var mod, seq, isSet = true;
		modtype = modtype ?? { self.modulatorType };
		defaultFun = defaultFun ?? { { self.defaultData } };
		if(ev.localMod.isNil) { // do not create if not existing
			mod = ();
			isSet = false;
		} {
			mod = ev.localMod;
		};
		if(mod[key].isNil) { // do not create if not existing
			mod[key] = ();
			isSet = false;
		};
		if(mod[key][modtype].isNil) { // do not create if not existing
			[mod, key, modtype].debug("running defaultFun").debug;
			[ ev].debug("running defaultFun ev").debug;
			seq = defaultFun.value;
			isSet = false;
		} {
			seq = mod[key][modtype];
		};
		[seq, isSet];
	},

	installEventListeners: { arg self, evlist;
		var key;
		var modtype;
		//"installVisibleListeners".debug;
		//evlist = evlist ?? {self.getLineEvents};
		if(self.visibleListeners.notNil) {
			self.visibleListeners.do { arg item, idx;
				item.remove;
			};
		};
		self.visibleListeners = List.new;
		if(self.selectedParam.notNil) {
			key = self.selectedParam.propertyRoot;
			//[key].debug("listener for key");
			evlist.do { arg ev, idx;
				var con;
				"make listener".debug;
				con = self.wrapperFor(ev, key).makeEventListener(ev, key);
				if(con.notNil) {
					self.visibleListeners.add(con);
				};
			};
		};
		
	},

	asPattern: { arg self, ev;
		// asPattern have no access to self.strip
		// because eventModel is in the strip gui and not the model
		var modev = ();
		var modtype;
		if(ev[\localValues].notNil) {
			var mod = ev.localMod ?? { () };
			( ev.localValues.keys ++ mod.keys ).do { arg key, idx;
				//if(ev.modulatorType.notNil and: { ev.modulatorType[key].notNil }) {
				//modtype = ev.modulatorType[key];
				//};
				if(mod[key].notNil) {
					modtype = mod[key][\modulatorType];
				};
				modtype = modtype ? \raw;
				[key, idx, modtype].debug("asPattern: modtype");

				modev[key] = ProtoTemplateDef("ModulatorStripEventModel_%".format(modtype).asSymbol).modulatorPattern(ev, key);
				modev[key].debug("asPattern: result");
				//if(modtype == \raw) {
				//modev[key] = ev.localValues[key];
				//} {
				//if(modtype == \step) {
				//if(ev[\localSeq].notNil and: { ev[\localSeq][key].notNil }) {
				//modev[key] = PstepSeq(ev[\localSeq][key]);
				//} {
				//modev[key] = ev.localValues[key];
				//};
				//};
				//};
			};
			Pbind(
				* modev.keys.asArray.collect { arg key, idx;
					[key, modev[key]]
				}.flatten ++ [\dur, self.cellWidth];
			);
		};
		
	},

	modulatorParamGroup: { arg self, ev, key;

	},

	asParamGroup: { arg self, ev, key;
		var ret;
		[ev, key].debug("asParamGroup");
		ret = if(ev.notNil) {
			var wr = self.wrapperFor(ev, key);
			wr.keys.debug("wrapper");
			wr.modulatorParamGroup(ev, key)
		} ?? { ParamGroup([]) };
		ret.debug("asParamGroup: ret");
		ret
	},
));

ProtoTemplateDef(\ModulatorStripEventModel_raw, (
	parent: ProtoTemplateDef(\ModulatorStripEventModel),
	modulatorType: \raw,

	setEventContent: { arg self, ev, idx, val, direction=1;
		var key = self.selectedParam.propertyRoot;
		if(ev.localValues.isNil) {
			ev.localValues = ();
		};
		ev.localValues[key] = val;
		self.strip.valuePopupCurrentValue = val;
		self.setModulatorType(ev, key, \raw);
		//[self.selectedParam, ev].debug("selp");
		ev.localValues.changed(\set, key);
	},
		
	drawEventContent: { arg self, ev;
		var ouuu_raw;
		var key = self.selectedParam.propertyRoot;
		var len = ev[self.xlenkey];
		var num;
		var sliderwidth = self.cellWidth;
		var seqev, seq;
		var isSet = true;
		var xkey = self.xkey;
		var color;
		var modtype;
		var res;
		var curlevel;
		num = ( len / self.cellWidth ).asInteger;
		if(ev[\localValues].isNil or: { ev[\localValues][key].isNil }) {
			isSet = false;
			[self.selectedTrackParam, self.selectedTrackParam.get, ev].debug("set default raw");
			curlevel = self.selectedTrackParam.get;
		} {
			curlevel = ev.localValues[key];
		};
		curlevel = self.selectedParam.spec.unmap(curlevel);
		if(isSet) {
			color = self.colors.full;
		} {
			color = self.colors.unset;
		};
		num.do { arg idx;
			self.drawBar(ev[xkey], idx, curlevel, color);
		};
	},
	
	modulatorPattern: { arg self, ev, key;
		if(ev.localValues.notNil and: { ev.localValues[key].notNil }) {
			ev.localValues[key];
		} {
			//self.selectedTrackParam.get; // FIXME: not available in pattern
			nil
		};
	},

	makeEventListener: { arg self, ev, key;
		var con;
		"make raw listener".debug;
		if(ev.localValues.isNil) {
			ev.localValues = ();
		};
		//[ key, ev ].debug("installing raw listener");
		con = SimpleController(ev.localValues).put(\set, { arg obj, msg, prop;
			//[obj, msg, prop, key, prop == key].debug("listener got");
			if(self.view.isClosed) {
				con.remove;
			} {
				if(prop == key) {
					self.view.refresh;
				};
			};
		});
		con;
	},
));

ProtoTemplateDef(\ModulatorStripEventModel_step, (
	parent: ProtoTemplateDef(\ModulatorStripEventModel),
	modulatorType: \step,

	setEventContent: { arg self, ev, idx, val, direction=1;
		var key = self.selectedParam.propertyRoot;
		var num = ev[self.xlenkey] / self.cellWidth;
		var seq;

		self.setModulatorType(ev, key, \step);
		if(ev.localMod[key][\step].isNil) { // do not create if not existing
			seq = List.newFrom( self.selectedTrackParam.get!num );
			ev.localMod[key][\step] = seq;
		} {
			seq = ev.localMod[key][\step]
		};


		if(direction == 1) {
			if(idx >= seq.size) {
				var more = idx - ( seq.size-1 );
				ev.localMod[key][\step] = List.newFrom(seq ++ ( self.selectedTrackParam.get!more ));
			};
		} {
			if(idx <= 0) {
				var more = ( ev[self.xlenkey] / self.cellWidth ) - ( seq.size );
				[( ev[self.xlenkey] / self.cellWidth ) , ( seq.size ), more].debug("MORE") ;
				ev.localMod[key][\step] = List.newFrom(( self.selectedTrackParam.get!more ) ++ seq);
			};

		};
		self.strip.valuePopupCurrentValue = val;
		ev.localMod[key][\step][idx] = val;
	},
		
	drawEventContent: { arg self, ev;
		var ouuu_step;
		var key = self.selectedParam.propertyRoot;
		var len = ev[self.xlenkey];
		var num;
		var sliderwidth = self.cellWidth;
		var seqev, seq;
		var isSet = true;
		var xkey = self.xkey;
		var color;
		var modtype;
		var default = ( ev.localValues !? { ev.localValues[key] } ?? { self.selectedTrackParam.get } );
		var res;
		var mod;
		num = ( len / self.cellWidth ).asInteger;
		#seq, isSet = self.getModulatorDataAndIsSet(ev, key, \step, { List.newFrom( default !num); });


		if(isSet) {
			color = self.colors.full;
		} {
			color = self.colors.unset;
		};
		num.do { arg idx;
			var curlevel = seq[idx] ? default;
			curlevel = self.selectedParam.spec.unmap(curlevel);
			self.drawBar(ev[xkey], idx, curlevel, color);
		};
	},

	modulatorPattern: { arg self, ev, key;
		if(self.isModulatorDefined(ev, key)) {
			PstepSeq(ev[\localMod][key][\step]);
		} {
			ev.localValues[key];
		};
	},
));

ProtoTemplateDef(\ModulatorStripEventModel_modenv, (
	parent: ProtoTemplateDef(\ModulatorStripEventModel),
	modulatorType: \modenv,

	setEventContent: { arg self, ev, idx, val, direction=1, pxpos;
		var key = self.selectedParam.propertyRoot;
		var num = ev[self.xlenkey] / self.cellWidth;
		var seq, modenv;
		var gxpos;
		var xrel, idxrel, nearEnd;
		num = num + 1; // curve need one more segment

		gxpos = self.strip.pixelPointToGridPoint(Point(pxpos, 0)).x;

		xrel = gxpos - ev[self.xkey]; // relative to event start
		idxrel	= ( xrel / self.cellWidth );
		nearEnd = ( idxrel % 1 ) > 0.5;

		self.setModulatorType(ev, key, \modenv);
		if(ev.localMod[key][\modenv].isNil) { // do not create if not existing
			modenv = self.defaultData(num);
			ev.localMod[key][\modenv] = modenv;
		} {
			modenv = ev.localMod[key][\modenv]
		};

		seq = modenv.valSeq;

		if(direction == 1) {
			if(idx+1 >= seq.size) {
				var more = ( idx+1 ) - ( seq.size-1 );
				//more = more + 1; // curve need one more segment
				modenv.valSeq = List.newFrom(seq ++ ( self.selectedParam.get!more ));
			};
		} {
			if(idx <= 0) {
				var more = ( ev[self.xlenkey] / self.cellWidth ) - ( seq.size );
				[( ev[self.xlenkey] / self.cellWidth ) , ( seq.size ), more].debug("MORE") ;
				modenv.valSeq = List.newFrom(( self.selectedParam.get!more ) ++ seq);
			};

		};
		self.strip.valuePopupCurrentValue = val;
		if(nearEnd) {
			seq[idx + 1] = val;
		} {
			seq[idx] = val;
		};
	},

	defaultData: { arg self, num;
		(valSeq: List.newFrom(self.selectedParam.get!num), time:self.cellWidth,curve:0)
	},
		
	drawEventContent: { arg self, ev;
		var key = self.selectedParam.propertyRoot;
		var len = ev[self.xlenkey];
		var num;
		var sliderwidth = self.cellWidth;
		var seqev, seq;
		var isSet = true;
		var xkey = self.xkey;
		var color;
		var modtype;
		var default = ( ev.localValues[key] ?? { self.selectedTrackParam.get } );
		var res;
		var mod;
		var modenv;
		num = ( len / self.cellWidth ).asInteger;
		#modenv, isSet = self.getModulatorDataAndIsSet(ev, key, \modenv, { self.defaultData(num) });
		//if(ev.localMod.isNil) { // do not create if not existing
			//mod = ();
			//isSet = false;
		//} {
			//mod = ev.localMod;
		//};
		//if(mod[key].isNil) { // do not create if not existing
			//mod[key] = ();
			//isSet = false;
		//} {
		//};
		//if(mod[key][\modenv].isNil) { // do not create if not existing
			//modenv = (valSeq: List.newFrom(0!num), time:1,curve:0);
			//isSet = false;
		//} {
			//modenv = mod[key][\modenv];
		//};
		if(isSet) {
			color = self.colors.full;
		} {
			color = self.colors.unset;
		};
		seq = modenv.valSeq;
		num.do { arg idx;
			var startlevel, endlevel;
			startlevel = seq[idx] ? default;
			endlevel = seq[idx+1] ? default;
			startlevel = self.selectedParam.spec.unmap(startlevel);
			endlevel = self.selectedParam.spec.unmap(endlevel);
			self.strip.drawCurve(ev[xkey], idx, startlevel, endlevel, color);
		};
	},

	modulatorPattern: { arg self, ev, key;
		if(self.isModulatorDefined(ev, key)) {
			var modenv = ev.localMod[key][\modenv];
			PmodEnv(PstepSeq(modenv.valSeq), nil, modenv.curve);
		};
	},

));

ProtoTemplateDef(\ModulatorStripEventModel_lfosin, (
	parent: ProtoTemplateDef(\ModulatorStripEventModel),
	modulatorType: \lfosin,

	setEventContent: { arg self, ev, idx, val, direction=1, pxpos;
		var key = self.selectedParam.propertyRoot;
		var modev;
		var modtype = \lfosin;

		self.setModulatorType(ev, key, modtype);
		if(ev.localMod[key][modtype].isNil) { // do not create if not existing
			modev = self.defaultData;
			ev.localMod[key][modtype] = modev;
		} {
			modev = ev.localMod[key][modtype]
		};


		self.strip.valuePopupCurrentValue = val;
		ev.localValues[key] = val;
	},

	defaultData: { arg self;
		(
			spec: self.selectedTrackParam.spec,
			amount: 0.5,
			freq: 2,
			phase: 0,
		);
	},
		
	drawEventContent: { arg self, ev;
		var key = self.selectedParam.propertyRoot;
		var len = ev[self.xlenkey];
		var num;
		var sliderwidth = self.cellWidth;
		var seqev, seq;
		var isSet = true;
		var xkey = self.xkey;
		var color;
		var default = ( ev.localValues[key] ?? { self.selectedTrackParam.get } );
		var res;
		var mod;
		var modev;
		var modtype = \lfosin;
		var level = self.selectedParam.spec.unmap(default);
		var rect;
		num = ( len / self.cellWidth ).asInteger;
		#modev, isSet = self.getModulatorDataAndIsSet(ev, key, modtype);
		if(isSet) {
			color = self.colors.full;
		} {
			color = self.colors.unset;
		};
		//self.strip.drawCurve(ev[xkey], idx, startlevel, endlevel, color);
		rect = self.strip.gridRectToPixelRect(Rect(ev[self.xkey], 0, ev[self.xlenkey], 1));
		rect = self.scaleRectForView(rect);
		default = self.selectedTrackParam.spec.unmap(default);
		self.drawSin(rect, default, modev.freq ? 1, modev.amount, modev.phase ? 0);
	},

	scaleRectForView: { arg self, rect;
		//rect = rect.copy;
		rect = rect.moveBy(0,-2);
		rect.height = rect.height - 3;
		rect;
	},

	drawSin: { arg self, rect, base, freq, amount, phase=0;
		var val;
		//var unit = self.strip.gridPointToPixelPoint(Point(self.cellWidth,0)).x;
		var unit = self.strip.gridRectToPixelRect(Rect(0,0,1,0)).width;
		rect.width.do { arg idx;
			val = ( sin(idx/unit * 2pi * freq + phase)+1/2 * amount + base ).linlin(0,1,rect.bottom,rect.top);
			if(idx == 0) {
				Pen.moveTo(Point(rect.left + idx,val));
			} {
				Pen.lineTo(Point(rect.left + idx,val));
			};
		};
		Pen.lineTo(Point(rect.right, rect.bottom));
		Pen.lineTo(Point(rect.left, rect.bottom));
		Pen.lineTo(Point(rect.left, rect.bottom));
		Pen.color = self.colors.full;
		Pen.fill;
	},

	modulatorPattern: { arg self, ev, key;
		// can't use defaultData because spec from selectedParam
		if(self.isModulatorDefined(ev, key)) {
			var modev; 
			var base;
			debug("modulatorPattern: start");
			base = ev.localValues[key] ? 0;
			modev = self.getModulatorData(ev, key); 
			base = modev.spec.unmap(base);
			[base, modev].debug("modulatorPattern: modev");
			~pmodsynth.({ 
				var sig = SinOsc.kr(modev.freq * TempoClock.default.tempo, modev.phase).unipolar * modev.amount + base;
				sig = modev.spec.map(sig);
				//sig = sig.linlin(0,1, modev.spec.minval, modev.spec.maxval);
				//base.poll;
				//sig.poll;
				sig;
			});

		}
	},

	modulatorParamGroup: { arg self, ev, key;
		var data = self.getModulatorData(ev, key);
		data.debug("modulatorParamGroup data");
		ParamGroup([
			Param(data, \amount, \bipolar),
			Param(data, \phase, ControlSpec(0,2pi,\lin)),
			Param(data, \freq, \lofreq),
		])
	},

	makeEventListener: { arg self, ev, key;
		var con;
		var data = self.getAndCreateModulatorData(ev, key);
		data.debug("make lfosin listener");
		//[ key, ev ].debug("installing raw listener");
		con = SimpleController(data).put(\set, { arg obj, msg, prop;
			[obj, msg, prop, key, prop == key].debug("listener got");
			if(self.view.isClosed) {
				con.remove;
			} {
				self.view.refresh;
			};
		});
		con;
	},

));

//// GUI

// timeline model

WindowDef(\ModulatorStrip, (

	shouldDrawEmptyBar: false,

	virtualBounds: { arg self;
		var offsetx = 5;
		var offsety = 5;
		//self.view.bounds.insetBy(5,10);
		Rect(offsetx, offsety, self.view.bounds.extent.x-(2*offsetx), self.view.bounds.extent.y-(2*offsety));
		//self.view.bounds;
	},
	viewport: { arg self;
		var vp = self.masterTimeline.viewport;
		Rect(vp.origin.x, 0, vp.extent.x, 1);
	},
	masterTimeline: { arg self;
		self.model.masterTimeline;
	},
	areasize: { arg self;
		var as = self.masterTimeline.areasize;
		Point(as.x, 1);
	},
	pixelRectToNormRect: { arg self, rect;
		var bounds = self.virtualBounds;
		var x_pixel_to_norm, y_pixel_to_norm;
		var viewport = self.viewport;
		var areasize = self.areasize;

		rect = rect
		// now in pixels in screen coordinates
		.translate(0-bounds.origin)
		.flipScreen(bounds.height)
		// now in pixels in bottom coordinates
		.scale(1/bounds.extent)
		// now in normalized in bottom coordinate
		.scale(viewport.extent)
		.translate(viewport.origin)
		;

		rect;

	},

	normRectToPixelRect: { arg self, rect;
		var bounds = self.virtualBounds;
		var x_norm_to_pixel;
		var y_norm_to_pixel;
		var viewport = self.viewport;

		//viewport.debug("normRectToPixelRect viewport");

		rect = rect
			.translate(0-viewport.origin)
			.scale(1/viewport.extent)
			.scale(bounds.extent)
			// now in pixel in bottom coordinates
			.flipScreen(bounds.height)
			// now in pixel in screen coordinates
			.translate(bounds.origin) // bounds is in screen coordinates so need flipping before translating
		;

		rect;

	},

	gridRectToNormRect: { arg self, rect;
		//rect.debug("gridRectToNormRect");
		Rect.fromPoints(
			self.gridPointToNormPoint(rect.origin),
			self.gridPointToNormPoint(rect.rightBottom),
		);
	},

	normRectToGridRect: { arg self, rect;
		Rect.fromPoints(
			self.normPointToGridPoint(rect.origin),
			self.normPointToGridPoint(rect.rightBottom),
		);
	},

	gridRectToPixelRect: { arg self, rect;
		self.normRectToPixelRect(self.gridRectToNormRect(rect));
	},


	pixelRectToGridRect: { arg self, rect;
		self.normRectToGridRect(self.pixelRectToNormRect(rect));
	},

	normPointToGridPoint: { arg self, point;
		(point * self.areasize)
	},

	gridPointToNormPoint: { arg self, point;
		(point / self.areasize)
	},
	
	pixelPointToGridPoint: { arg self, point;
		self.normPointToGridPoint(self.pixelPointToNormPoint(point))
	},

	pixelPointToNormPoint: { arg self, point;
		self.pixelRectToNormRect(Rect.fromPoints(point, point+Point(0,0))).origin;
	},

	gridPointToPixelPoint: { arg self, point;
		self.normPointToPixelPoint(self.gridPointToNormPoint(point))
	},

	normPointToPixelPoint: { arg self, point;
		self.normRectToPixelRect(Rect.fromPoints(point, point+Point(0,0))).origin;
	},


	mimicTimeline: { arg self, timeline, orientation;
		var timeline_controller;
		var viewport = self.viewport;
		var areasize = self.areasize;
		var rect_copy_horizontal = { arg me, rect;
			me = me.copy;
			me.width = rect.width;
			me.origin = Point(rect.origin.x, me.origin.y);
			me;
		};
		var rect_copy_vertical = { arg me, rect;
			me = me.copy;
			me.height = rect.height;
			me.origin = Point(me.origin.x, rect.origin.y);
			me;
		};

		if(timeline_controller.notNil) {timeline_controller.remove};
		timeline_controller = SimpleController(timeline)
			.put(\viewport, {
				if(self.view.isNil or: { self.view.isClosed }) {
					timeline_controller.remove;
				} {
					//[this].debug("refresh viewport because mimicTimeline!!");
					switch(orientation,
						\horizontal, {
							self.viewport = rect_copy_horizontal.(viewport, timeline.viewport);
						},
						\vertical, {
							self.viewport = rect_copy_vertical.(viewport, timeline.viewport);
						},
						// else
						{
							self.viewport = timeline.viewport; 
						}
					);
					self.refresh;
				}
			})
			.put(\areasize, {
				if(self.view.isNil or: {self.view.isClosed}) {
					timeline_controller.remove;
				} {
					//[this].debug("refresh viewport because mimicTimeline!!");
					switch(orientation,
						\horizontal, {
							self.areasize = Point(timeline.areasize.x, areasize.y);
						},
						\vertical, {
							self.areasize = Point(areasize.x, timeline.areasize.y);
						},
						// else
						{
							self.areasize = timeline.areasize;
						}
					);
					self.refresh;
				}
			})
			.put(\lastGridPos, {
				self.lastGridPos = timeline.lastGridPos;
				//this.view.refresh;
				self.refresh;
			})
		;
		// init
		timeline.changed(\areasize);
		timeline.changed(\viewport); 

	},

	selectEventInTimeline: { arg self, ev;
		var node;
		debug("selectEventInTimeline");
		node = self.model.masterTimeline.nodes.detect { arg x; x.model == ev };
		self.model.masterTimeline.deselectAllNodes;
		if(node.notNil) {
			self.model.masterTimeline.selectNode(node);
			self.model.fxTimelinePanel.selectedEvent = ev;
		} {
			"Can't find node for ev %".format(ev).error;
			nil
		};
	},

	createEventInTimeline: { arg self, pxpos;
		var gypos = self.model.fxTimelinePanel.selectedFxIndex;
		var gxpos = self.model.masterTimeline.pixelPointToGridPoint(Point(pxpos, 0)).x.trunc(self.cellWidth);
		var ev = self.model.masterTimeline.eventFactory(Point(gxpos,gypos), self.cellWidth);
		self.model.fxTimelinePanel.timeline_model.addHistorySnapshot;
		self.model.fxTimelinePanel.eventList.addEvent( ev );
		ev;
	},

	refresh: { arg self;
		self.view.refresh;
	},

	cellWidth: { arg self;
		self.model.timelineModel.cellWidth
	},

	installListeners: { arg self;
		self.view.followChange(self.model.fxTimelinePanel, \selectedFx, {
			self.refresh;
		}, false);
		self.view.followChange(self.model.fxTimelinePanel, \selectedParam, {
			self.refresh;
			self.installVisibleListeners;
		}, false);
		
	},

	installVisibleListeners: { arg self, evlist;
		evlist = evlist ?? {self.getLineEvents};
		if(self.selectedTrackParam.notNil and: { self.selectedParam.notNil }) {
			self.eventModel.installEventListeners(evlist);
		};
		//var key;
		//var modtype;
		////"installVisibleListeners".debug;
		//evlist = evlist ?? {self.getLineEvents};
		//if(self.visibleListeners.notNil) {
			//self.visibleListeners.do { arg item, idx;
				//item.remove;
			//};
		//};
		//self.visibleListeners = List.new;
		//if(self.selectedParam.notNil) {
			//key = self.selectedParam.propertyRoot;
			////[key].debug("listener for key");
			//evlist.do { arg ev, idx;
				//if(ev.modulatorType.notNil) {
					//modtype = ev.modulatorType[key];
				//};
				//modtype = modtype ?? { self.selectedModulatorType };
				////[modtype, ev].debug("listener for ev");
				//if(modtype == \raw) {
					//var con;
					//if(ev.localValues.isNil) {
						//ev.localValues = ();
					//};
					////[ key, ev ].debug("installing raw listener");
					//con = SimpleController(ev.localValues).put(\set, { arg obj, msg, prop;
						////[obj, msg, prop, key, prop == key].debug("listener got");
						//if(self.view.isClosed) {
							//con.remove;
						//} {
							//if(prop == key) {
								//self.view.refresh;
							//};
						//};
					//});
					//self.visibleListeners.add(con);
				//} {
					//if(modtype == \step) {

					//};
				//};
			//};
		//};
		
	},

	getLineEvents: { arg self;
		var idx = self.model.timelineModel.tracks.indexOf(self.model.fxTimelinePanel.selectedFx);
		var ykey = \midinote;
		var ypos;
		if(idx.notNil) {
			self.model.timelineModel.eventList.select({ arg ev;
				ypos = ev.use { currentEnvironment[ykey] };
				ypos == idx;
			})
		} {
			[]
		};
	},

	selectedParam: { arg self;
		self.model.fxTimelinePanel.selectedParam;
	},

	selectedTrackParam: { arg self;
		self.model.fxTimelinePanel.selectedTrackParam;
	},

	xkey: \absTime,
	xlenkey: \sustain,

	colors: (
		//empty: ParamViewToolBox.color_pale(0.7),
		disabled: ParamViewToolBox.color_pale.copy.divide(Color.white, 0.5),
		empty: ParamViewToolBox.color_pale,
		selected: ParamViewToolBox.color_light.complementary,
		//eventBox: ParamViewToolBox.color_dark.divide(Color.white,0.8),
		eventBox: Color.black,
		barBox: ParamViewToolBox.color_ligth,
		full: ParamViewToolBox.color_ligth,
		unset: ParamViewToolBox.color_ligth.copy.alpha_(0.6),
	),

	selectedModulatorType: { arg self;
		self.model.fxTimelinePanel.selectedModulatorType ? \raw;
	},

	selectedModulatorTypeAction: { arg self, ev;
		ev.debug("selectedModulatorTypeAction");
		if(ev.notNil and: { self.selectedParam.notNil }) {
			self.eventModel.setModulatorType(ev, self.selectedParam.propertyRoot, self.selectedModulatorType);
		};
	},

	eventModel: { arg self;
		if(self[\eventModel_obj].isNil) {
			self[\eventModel_obj] = ProtoTemplateDef(\ModulatorStripEventModel).new(self);
		};
		self[\eventModel_obj];
	},

	drawEventContent: { arg self, ev;
		var key = self.selectedParam.propertyRoot;
		var len = ev[self.xlenkey];
		var num;
		var sliderwidth = self.cellWidth;
		var seqev, seq;
		var isSet = true;
		var xkey = self.xkey;
		var color;
		var modtype;
		var res;
		num = ( len / self.cellWidth ).asInteger;
		Pen.width = 1;

		"ModulatorStrip.drawEventContent".debug;

		self.eventModel.drawEventContent(ev);

		//if(ev.modulatorType.notNil and: { ev.modulatorType[key].notNil }) {
			//modtype = ev.modulatorType[key];
		//};
		//modtype = modtype ?? { self.selectedModulatorType };
		//if(modtype == \raw) {
			//var curlevel;
			//if(ev[\localValues].isNil or: { ev[\localValues][key].isNil }) {
				//isSet = false;
				//[default, self.selectedTrackParam, self.selectedTrackParam.get, ev].debug("set default raw");
				//curlevel = default;
			//} {
				//curlevel = ev.localValues[key];
			//};
			//curlevel = self.selectedParam.spec.unmap(curlevel);
			//if(isSet) {
				//color = self.colors.full;
			//} {
				//color = self.colors.unset;
			//};
			//num.do { arg idx;
				//self.drawBar(ev[xkey], idx, curlevel, color);
			//};
		//} {
			//if(modtype == \step) {
				//if(ev.localSeq.isNil) { // do not create if not existing
					//seqev = ();
					//isSet = false;
				//} {
					//seqev = ev.localSeq;
				//};
				//if(seqev[key].isNil) {
					//seq = List.newFrom( default !num);
					//isSet = false;
				//} {
					//seq = seqev[key];
				//};
				//if(isSet) {
					//color = self.colors.full;
				//} {
					//color = self.colors.unset;
				//};
				//num.do { arg idx;
					//var curlevel = seq[idx] ? default;
					//curlevel = self.selectedParam.spec.unmap(curlevel);
					//self.drawBar(ev[xkey], idx, curlevel, color);
				//};
			//};
		//};

	},

	setCellAtPos: { arg self, pxpos, val, mouseActionType;
		var ev;
		var idx;
		var key = self.selectedParam.propertyRoot;
		var direction = 1;

		#ev, idx = self.getEventIdxAtPos(pxpos);

		if(ev.isNil and: { mouseActionType == \down }) {
			// event creation on mouse down
			ev = self.createEventInTimeline(pxpos);
			if(ev.localValues.isNil) {
				ev.localValues = ();
			};
			if(self.selectedModulatorType != \raw) {
				ev.localMod = ();
				ev.localMod[key] = (modulatorType: self.selectedModulatorType);
			};
			ev.localValues[key] = val; // localValues is the ref for keys
			self.createdEvent = ev;
			self.createdEventPxpos = pxpos;
			self.createdEventAbsTime = ev[self.xkey];
			ev.sustain = self.cellWidth;
			idx = 0;
		};
		if(ev.notNil and: {mouseActionType == \move} and: { ev != self.createdEvent }) {
			// when encountering another event, stop event resize
			self.createdEvent = nil;
		};
		if(ev.isNil and: { mouseActionType == \move } and: { self.createdEvent.notNil }) {
			// event resize on mouse move
			var xrel;
			var gxpos;
			ev = self.createdEvent;
			gxpos = self.pixelPointToGridPoint(Point(pxpos, 0)).x;
			xrel = gxpos - ev[self.xkey]; // relative to event start
			idx	= xrel / self.cellWidth;
			idx = idx.asInteger;
			[ self.createdEventAbsTime, ev.absTime, idx, self.cellWidth, self.createdEventAbsTime + (idx * self.cellWidth) ].debug("first abstime, ev abstime, idx, cellwidth, result");
			if(idx <= 0) {
				ev.absTime = ev.absTime + (idx-1 * self.cellWidth);
				ev.sustain = max(ev.sustain, ev.sustain + ( ( ( idx+1 ).abs ) * self.cellWidth ));
				direction = -1;
				// TODO: should shift the current sequences to the left
				// insert0 instead of adding ?
			} {
				ev.sustain = max(ev.sustain, ( idx.abs+1 ) * self.cellWidth);
			};
			ev.changed(\refresh);
			ev.changed(\refraw);
			self.model.masterTimeline.refresh;
			[idx, xrel, self.cellWidth, ev.sustain].debug("setCellAtPos: move: created event");
		};
		if(ev.isNil) {
			//"Can't find the event".error.throw;
			"Can't find the event".error;
		} {

			if(mouseActionType == \down) {
				self.selectEventInTimeline(ev);
				self.model.masterTimeline.refresh;
				self.shouldShowValuePopup = true;
				self.valuePopupPxpos = pxpos;
			};
			if(mouseActionType == \move) {
				self.valuePopupPxpos = pxpos;
				
			};
			val = self.selectedParam.spec.map(val);
			//ev.debug("setCellAtPos: ev");
			self.eventModel.setEventContent(ev, idx, val, direction, pxpos);

			if(mouseActionType == \up) {
				self.shouldShowValuePopup = false;
				self.installVisibleListeners;
			};
			self.view.refresh;
		};
	},

	showValuePopup: { arg self, show=true;
		var unit = self.gridRectToPixelRect(Rect(0,0,self.cellWidth*2,0.5)).extent;
		if(show) {
			var rect = Rect(self.valuePopupPxpos + unit.x, unit.y, 55, 20);
			//Pen.color = Color.gray.blend(Color.red, 0.1);
			Pen.color = self.colors.selected;
			Pen.strokeColor = Color.black;
			Pen.fillColor = self.colors.selected;
			Pen.width = 1/2;
			//self.drawRoundBox(rect,10);
			//Pen.stroke;
			//self.drawRoundBox(rect.insetBy(1),10);
			Pen.addRect(rect.insetBy(1));
			Pen.draw(3);
			Pen.color = Color.black;
			Pen.stringInRect(self.valuePopupCurrentValue.asStringPrec(5), rect.insetBy(4).moveBy(3,0), Font.default.size_(9), alignment:\center);
			Pen.stroke;
		};
	},

	getEventAtPos: { arg self, pxpos;
		var gxpos, gypos, pypos;
		var node;
		pypos = self.gridPointToPixelPoint(Point(0,self.model.fxTimelinePanel.selectedFxIndex)).y + 1;
		gypos = self.model.fxTimelinePanel.selectedFxIndex + 0.1;
		gxpos = self.pixelPointToGridPoint(Point(pxpos, 0)).x;

		node = self.model.masterTimeline.findNode(gxpos, gypos);
		
		if(node.notNil) {
			node.model;
		} {
			nil
		};
	},

	getEventIdxAtPos: { arg self, pxpos;
		var gxpos, gypos, pypos;
		var ev;
		var node;
		pypos = self.gridPointToPixelPoint(Point(0,self.model.fxTimelinePanel.selectedFxIndex)).y + 1;
		gypos = self.model.fxTimelinePanel.selectedFxIndex + 0.1;
		gxpos = self.pixelPointToGridPoint(Point(pxpos, 0)).x;

		node = self.model.masterTimeline.findNode(gxpos, gypos);
		
		if(node.notNil) {
			ev = node.model;
			if(ev.notNil) {
				var xrel, idx;
				xrel = gxpos - ev[self.xkey]; // relative to event start
				idx	= ( xrel / self.cellWidth ).asInteger;
				[ev, idx];
			} {
				[ nil, nil ]
			};
		} {
			[ nil, nil ]
		};
	},

	drawRoundBox: { arg self, rect, smooth=1, width=1;
		// problem: can't fill because addAnnularWedge do not add to pen path
		// maybe use curveTo
		var radius = smooth;
		var inradius = radius - ( width/10 );
		Pen.moveTo(Point(rect.left, rect.bottom - radius));
		Pen.lineTo(Point(rect.left, rect.top + radius));
		Pen.addAnnularWedge(Point(rect.left, rect.top)+radius, inradius,radius, 2pi/2, pi/2);
		Pen.moveTo(Point(rect.left + radius, rect.top));
		Pen.lineTo(Point(rect.right - radius, rect.top));
		Pen.addAnnularWedge(Point(rect.right - radius, rect.top + radius), inradius,radius, 3pi/2, pi/2);
		Pen.moveTo(Point(rect.right, rect.top + radius));
		Pen.lineTo(Point(rect.right, rect.bottom - radius));
		Pen.addAnnularWedge(Point(rect.right, rect.bottom) - radius, inradius,radius, 4pi/2, pi/2);
		Pen.moveTo(Point(rect.right - radius, rect.bottom ));
		Pen.lineTo(Point(rect.left + radius, rect.bottom));
		Pen.addAnnularWedge(Point(rect.left + radius, rect.bottom - radius), inradius,radius, pi/2, pi/2);
	},

	drawEventBox: { arg self, gxpos, len, selected=false;
		//var penOffset = 0; // compensate width
		//var maxlevel = 1;
		//var rect = self.gridRectToPixelRect(Rect(gxpos, 0, len, maxlevel));
		//rect.left = rect.left + penOffset;
		//rect.bottom = rect.bottom - 4;
		//if(selected) {
			//Pen.width = 8;
			//Pen.color = self.colors.selected;
		//} {
			//Pen.width = 4;
			//Pen.color = self.colors.eventBox;
		//};
		//Pen.addRect( rect.insetBy(1) );
		//Pen.stroke;

		//Pen.width = 1;
		//Pen.addRect( rect.insetBy(0) );
		//Pen.color = Color.white;
		//Pen.fill;


		var maxlevel = 1;
		var rect = self.gridRectToPixelRect(Rect(gxpos, 0, len, maxlevel));
		//Pen.capStyle = 2;
		rect.bottom = rect.bottom - 4;
		if(selected) {
			Pen.width = 2;
			Pen.color = self.colors.selected;
		} {
			Pen.width = 1.5;
			//Pen.color = self.colors.eventBox;
			Pen.color = ParamViewToolBox.color_ligth;
		};
		self.drawRoundBox(rect.insetBy(1), 3);
		//Pen.addRect( rect.insetBy(1) );
		Pen.stroke;

	},

	drawBar_old: { arg self, gxoffset, idx, level, color, colorEmpty;
		var maxlevel = 1;
		var penOffset = 0; // compensate don't know what
		var sliderwidth = self.cellWidth;
		var gposx = sliderwidth * idx;
		var rect;
		var fullrect;
		//"drawBar".debug;
		rect = self.gridRectToPixelRect(Rect(gposx+gxoffset,0, sliderwidth, maxlevel * level));
		//rect.debug("rect");
		rect.left = rect.left + penOffset;
		rect.bottom = rect.bottom - 4;
		rect.width = rect.width - 1;
		//fullrect.top = self.virtualBounds.height;
		//fullrect.height = self.virtualBounds.height.neg * 0.5;
		fullrect = Rect(rect.origin.x, 6, rect.width, self.virtualBounds.height);
		//fullrect.debug("FULLRECT");

		//Pen.color = colorEmpty ?? { self.colors.empty };
		//Pen.width = 1;
		//Pen.addRect( fullrect.insetBy(1) );
		//Pen.stroke;

		//Pen.width = 1;
		//Pen.addRect( fullrect.insetBy(1) );
		////Pen.color = colorEmpty ?? { self.colors.empty };
		//Pen.fill;

		Pen.color = colorEmpty ?? { self.colors.empty };
		Pen.width = 4;
		Pen.addRect( fullrect.insetBy(2) );
		Pen.stroke;
		Pen.addRect( fullrect.insetBy(2) );
		Pen.fill;

		if(color.notNil) {

			Pen.color = color;
			Pen.width = 1;
			Pen.addRect( rect.insetBy(1) );
			Pen.stroke;
			Pen.addRect( rect.insetBy(0) );
			Pen.fill;
		};
	},

	drawBar: { arg self, gxoffset, idx, level, color, colorEmpty;
		var maxlevel = 1;
		var penOffset = 0; // compensate don't know what
		var sliderwidth = self.cellWidth;
		var gposx = sliderwidth * idx;
		var rect;
		var fullrect;
		var zerolevel;
		//"drawBar".debug;
		sliderwidth.debug("drawBar: sliderwidth");

		if(self.centered == true) {
			zerolevel = 0.5;
			if(level > 0.5) {
				//rect.top = rect.top - ( rect.height/2 );
				rect = self.gridRectToPixelRect(Rect(gposx+gxoffset,0.5, sliderwidth, level - 0.5));
			} {
				rect = self.gridRectToPixelRect(Rect(gposx+gxoffset,level, sliderwidth, 0.5 - level));
				//rect.bottom = rect.bottom - ( rect.height/2 );
			}
		} {
			rect = self.gridRectToPixelRect(Rect(gposx+gxoffset,0, sliderwidth, maxlevel * level));
			zerolevel = 0;
		};

		//rect.debug("rect");
		rect.left = rect.left + penOffset;
		rect.bottom = rect.bottom - 4;
		rect.width = rect.width - 1;

		fullrect = self.gridRectToPixelRect(Rect(gposx+gxoffset,0, sliderwidth, maxlevel));
		fullrect.bottom = fullrect.bottom - 4;
		fullrect.width = fullrect.width - 1;
		//fullrect.debug("FULLRECT");


		//// draw empty rect

		Pen.color = colorEmpty ?? { self.colors.empty };
		Pen.width = 4;
		Pen.addRect( fullrect.insetBy(2) );
		Pen.stroke;
		Pen.addRect( fullrect.insetBy(2) );
		Pen.fill;

		//// draw value rect

		if(color.notNil and: { level.equalWithPrecision(zerolevel).not or: { self.shouldDrawEmptyBar == true } }) {
			//level.debug("drawFunc: level");

			Pen.color = color;
			Pen.width = 1;
			Pen.addRect( rect.insetBy(1) );
			Pen.stroke;
			Pen.addRect( rect.insetBy(0) );
			Pen.fill;
		};
	},

	drawCurve: { arg self, gxoffset, idx, startlevel, endlevel, color, colorEmpty;
		var maxlevel = 1;
		var penOffset = 0; // compensate don't know what
		var sliderwidth = self.cellWidth;
		var gposx = sliderwidth * idx;
		var rect;
		var fullrect;
		//"drawBar".debug;
		rect = self.gridRectToPixelRect(Rect(gposx+gxoffset,0, sliderwidth, maxlevel));
		//rect.debug("rect");
		rect.left = rect.left + penOffset;
		rect.bottom = rect.bottom - 4;
		rect.width = rect.width - 1;
		//fullrect.top = self.virtualBounds.height;
		//fullrect.height = self.virtualBounds.height.neg * 0.5;
		fullrect = Rect(rect.origin.x, 6, rect.width, self.virtualBounds.height);
		//fullrect.debug("FULLRECT");

		//Pen.color = colorEmpty ?? { self.colors.empty };
		//Pen.width = 1;
		//Pen.addRect( fullrect.insetBy(1) );
		//Pen.stroke;

		//Pen.width = 1;
		//Pen.addRect( fullrect.insetBy(1) );
		////Pen.color = colorEmpty ?? { self.colors.empty };
		//Pen.fill;

		Pen.color = colorEmpty ?? { self.colors.empty };
		Pen.width = 4;
		Pen.addRect( fullrect.insetBy(2) );
		Pen.stroke;
		Pen.addRect( fullrect.insetBy(2) );
		Pen.fill;

		if(color.notNil) {

			Pen.color = color;
			Pen.width = 1;
			//Pen.addRect( rect.insetBy(1) );
			rect = rect.insetBy(1);
			startlevel = 1-startlevel;
			endlevel = 1-endlevel;
			Pen.moveTo(Point(rect.left,rect.bottom));
			Pen.lineTo(Point(rect.left,rect.top + (rect.height * startlevel)));
			Pen.lineTo(Point(rect.right,rect.top+ (rect.height * endlevel)));
			Pen.lineTo(Point(rect.right,rect.bottom));
			Pen.draw(3);
			//Pen.stroke;
			//Pen.addRect( rect.insetBy(0) );
			//Pen.fill;
		};
		
	},

	drawFunc: { arg self;
		{
			var bounds = self.virtualBounds;
			var num;
			var sliderwidth; // in grid unit
			var maxlevel = 1;
			var xkey = self.xkey;
			var xlenkey = self.xlenkey;
			var gxoffset = self.pixelPointToGridPoint(Point(5,0)).x;
			gxoffset = gxoffset.trunc(self.cellWidth);
			sliderwidth = self.cellWidth;
			//"draw".debug;
			//[bounds, self.areasize, self.pixelRectToGridRect(bounds).width].debug("width");
			num = ( self.pixelRectToGridRect(bounds).width / sliderwidth ).trunc.asInteger + 2;
			//num.debug("ModulatorStrip: num");
			self.getLineEvents.debug("line events");
			//Pen.scale(1,0.90);
			Pen.translate(0,5);
			num.do { arg idx;
				//gxoffset.debug("gxoffset");
				self.drawBar(gxoffset, idx, 1, nil, self.colors.disabled);
			};

			self.getLineEvents.do { arg ev, idx;
				self.drawEventContent(ev);
				self.drawEventBox(ev[xkey], ev[xlenkey], ev === self.model.fxTimelinePanel.selectedEvent);
			};

			self.showValuePopup(self.shouldShowValuePopup ? false);
		}
	},

	asView: { arg self, def, model;
		var view = UserView.new;
		var tl;
		self.view = view;
		self.model = model;
		//self.timeline = TimelineView.new; // for conversions
		self.mimicTimeline(model.masterTimeline, \horizontal);
		//tl = self.timeline;
		self.installListeners;

		view.drawFunc = self.drawFunc;
		view.background_(Color.white);

		view.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			var idx;
			var offset = -8;
			[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
			if(buttonNumber == 1) {
				self.showContextMenu(x);
			} {
				self.setCellAtPos(x, 1 - ( ( y + offset )/self.virtualBounds.height ), \down);
			};
		});
		view.mouseMoveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			var idx;
			var offset = -8;
			//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseMoveAction");
			self.setCellAtPos(x, 1 - ( ( y + offset )/self.virtualBounds.height ), \move);

		});
		view.mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			var idx;
			var offset = -8;
			//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseMoveAction");
			self.setCellAtPos(x, 1 - ( ( y + offset )/self.virtualBounds.height ), \up);

		});
		view.addUniqueMethod(\proto, { self });
		view;
	},

	unsetEventSeq: { arg self, ev, key;
		if(ev.localSeq.notNil) {
			ev.localSeq[key] = nil;
			self.changed(\refresh);
		};
	},

	clearAllEventData: { arg self, ev;
		ev[\localSeq] = nil;
		ev[\localValues] = nil;
		self.changed(\refresh);
	},

	showContextMenu: { arg self, pxpos;
		var ev, key;
		ev = self.getEventAtPos(pxpos);
		Menu(
			MenuAction("Unset", {
				key = self.selectedParam.propertyRoot;
				self.unsetEventSeq(ev, key);
			}).enabled_(ev.notNil),
			MenuAction("Clear all event data", {
				self.clearAllEventData(ev)
			}).enabled_(ev.notNil),
		).front
	},

	findCellIndex: { arg self, x;
		self.pixelPointToGridPoint(Point(x, 0)).x / self.cellWidth;
		
	},

));

// param model

WindowDef(\ModulatorStrip_generic, (
	parent: WindowDef(\ModulatorStrip).proto,
	// TODO: return child by spec
));

WindowDef(\ModulatorStrip_slider, (
	parent: WindowDef(\ModulatorStrip).proto,

	shouldDrawBarLabel: true,
	shouldDrawBarLabelOnChange: true,
	inElasticMode: true,

	virtualBounds: { arg self;
		var offsetx = 0;
		var offsety = 0;
		//self.view.bounds.insetBy(5,10);
		Rect(offsetx, offsety, self.view.bounds.extent.x-(2*offsetx), self.view.bounds.extent.y-(2*offsety));
		//self.view.bounds;
	},

	viewport: { arg self;
		Rect(0, 0, 1, 1);
	},
	areasize: { arg self;
		Point(8, 1);
	},

	seqSize_: { arg self, val;
		self[\seqSize] = val;
		if(self.targetParam.notNil) {
			[self.targetParam.propertyRoot, val].debug("seqSize_");
		} {
			["vide", val].debug("seqSize_");
		};
		self.areasize = Point(val,1);
		self.refresh;
	},

	cellWidth: { arg self; self.stepDur },
	stepDur: 1/8,

	mapParam: { arg self, param;
		var spec = param.spec;
		self.targetParam = param;
		if(spec.isKindOf(ParamArraySpec)) {
			spec = spec.array.first;
		};
		if(spec.isKindOf(ParamBoolSpec)) {
			self.centered = false;
		} {
			if(spec.minval == spec.maxval.neg) {
				self.centered = true;
			} {
				self.centered = false;
			};
		};
		self.installListeners;
	},

	drawBarLabel: { arg self, gxoffset, idx, level, color, colorEmpty;
		var maxlevel = 1;
		var penOffset = 0; // compensate don't know what
		var sliderwidth = self.cellWidth;
		var gposx = sliderwidth * idx;
		var rect;
		var fullrect;
		var label;
		var font;
		//"drawBar".debug;
		rect = self.gridRectToPixelRect(Rect(gposx+gxoffset,0, sliderwidth, maxlevel * level));
		//rect.debug("rect");
		rect.left = rect.left + penOffset;
		rect.bottom = rect.bottom - 4;
		rect.width = rect.width - 1;
		//fullrect.top = self.virtualBounds.height;
		//fullrect.height = self.virtualBounds.height.neg * 0.5;
		//fullrect = Rect(rect.origin.x, 0, rect.width, self.virtualBounds.height);
		fullrect = self.gridRectToPixelRect(Rect(gposx+gxoffset,0, sliderwidth, maxlevel));
		fullrect.bottom = fullrect.bottom - 4;
		fullrect.width = fullrect.width - 1;

		label = level.asStringPrec(3).asString;
		//[level.asCompileString, label.asCompileString].debug("label");
		font = Font.default.pixelSize_(min(fullrect.height/2, fullrect.width*1.2));
		Pen.stringInRect(label, fullrect.insetBy(fullrect.width/7,fullrect.height/5), font, Color.black, \right)
	},

	drawSeparator: { arg self, gxoffset, idx, level, color, penwidth=2;
		var maxlevel = 1;
		var penOffset = 0; // compensate don't know what
		var sliderwidth = self.cellWidth;
		var gposx = sliderwidth * idx;
		var rect;
		var fullrect;
		//"drawBar".debug;
		rect = self.gridRectToPixelRect(Rect(gposx+gxoffset,0, sliderwidth, maxlevel));
		rect.left = rect.left + penOffset;
		rect.bottom = rect.bottom - 4;
		rect.width = rect.width - 1;
		Pen.line(Point(rect.left,rect.bottom), Point(rect.left,rect.top));
		Pen.color = color;
		Pen.width = penwidth;
		Pen.stroke;
	},

	drawFunc: { arg self;
		{
			var rect;
			var arr = self.targetParam.get;
			var gxoffset = self.pixelPointToGridPoint(Point(0,0)).x;
			var color_empty_cursor = self.colors.full.complementary.add(self.colors.full.complementary, 0.5);
			//gxoffset = gxoffset.trunc(self.cellWidth);
			//Pen.translate(28,-7);
			//[gxoffset, arr, self.targetParam, self.targetParam.get].debug("drawFunc");
			//rect = Rect(5,5,100,100);
			//rect = self.normRectToPixelRect(Rect(0,0,1,1));
			//[self.viewport, self.virtualBounds, rect].debug("ss");
			//Pen.addRect(rect);
			//Pen.fill;
			self.targetParam.size.do { arg item, idx;
				//var val = self.targetParam.at(idx).spec.unmap(arr[idx]);
				var val = self.targetParam.at(idx).normGet;
				var label = self.targetParam.at(idx).get;
				if(self.cursorEnabled == true and: {self.cursorIndex == idx}) {
					self.drawBar(0, idx, val, self.colors.full.complementary, color_empty_cursor);
				} {
					self.drawBar(0, idx, val, self.colors.full, self.colors.empty);
				};
				if(self.shouldDrawBarLabel == true or: { self.shouldDrawBarLabelOnChange and: {self.inMouseMove == true }}) {
					self.drawBarLabel(0, idx, label, self.colors.full, self.colors.empty);
				};

				if(idx != 0 and: {idx%8 == 0}) {
					self.drawSeparator(0, idx, label, Color.white, 4);
				} {
					if(idx != 0 and: {idx%4 == 0}) {
						self.drawSeparator(0, idx, label, Color.white, 2);
					}
				};
			};
		}
	},

	setCellAtPos: { arg self, pxpos, val, mouseActionType;
		var xrel, idx;
		var gxpos;
		gxpos = self.pixelPointToGridPoint(Point(pxpos, 0)).x;
		idx	= ( gxpos / self.cellWidth ).asInteger;
		idx = idx.clip(0,(self.areasize.x/self.cellWidth ).asInteger-1);
		[pxpos, gxpos, idx, self.cellWidth].debug("ModulatorStrip_slider.setCellAtPos");
		self.targetParam.at(idx).normSet(val);
		self.view.refresh;
	},

	showContextMenu: { arg self, pxpos;
		var ev, key;
		Menu(
			MenuAction("Edit text", {
				WindowDef(\CompileStringEditor).front(self.targetParam);
			}),
			MenuAction("Set step to default value", {
				var idx;
				var gxpos;
				gxpos = self.pixelPointToGridPoint(Point(pxpos, 0)).x;
				idx	= ( gxpos / self.cellWidth ).asInteger;
				idx = idx.clip(0,(self.areasize.x/self.cellWidth ).asInteger-1);
				self.targetParam.at(idx).set(self.targetParam.at(idx).default);
			}),
			MenuAction("Set all steps to default value", {
				var default = self.targetParam.default;
				default.debug("ModulatorStrip default");
				if(default.isSequenceableCollection.not) {
					default = default ! self.targetParam.size;
				};
				default.debug("ModulatorStrip default2");
				self.targetParam.set(default);
			}),
			MenuAction("Unset", {
				self.targetParam.unset;
			}),
			Menu(
				MenuAction("Set random pattern", {
					var val = self.targetParam.get;
					var pat = Pwhite(0.0,1,inf).asStream;
					val.do { arg item, idx;
						val[idx] = pat.next;
					};
					self.targetParam.normSet(val);
				}),
				* [
					[0],
					[1],
					[1,0],
					[1,0,0,0],
					[1,0,0,0, 0,0,0,0],
					[0,1],
					[0,0,1,0],
					[0,0,0,0, 1,0,0,0],
				].collect { arg seq, idx;
					MenuAction("Set pattern %".format(seq), {
						var val = self.targetParam.get;
						var pat = Pseq(seq,inf).asStream;
						val.do { arg item, idx;
							val[idx] = pat.next;
						};
						self.targetParam.normSet(val);
					})
				},

			).title_("Set patterns")
		).front
	},
	
	installListeners: { arg self, evlist;
		var cursorTarget = self.targetParam.parent.at(\source).get;
		self.targetParam.onChange({
			self.view.refresh;
		}, self.view);
		self.view.followChange(cursorTarget, \cursor, { arg view, obj, msg, val;
			if(self.cursorEnabled == true) {
				//[view, obj, msg, val].debug("cursor");
				//"cursor".debug;
				{
					self.cursorIndex = val;
					self.view.refresh;
				}.defer(Server.default.latency);
			};
		});

		
	},

	asView: { arg self, def, param, size;
		var view = UserView.new;
		var tl;
		var offsety = 0;
		self.view = view;
		//self.model = ProtoTemplateDef(\ModulatorStrip);
		if(self.inElasticMode == true) {
			self.seqSize = size ?? { param.size };
		} {
			if(size.notNil) {
				self.seqSize = size;
			};
		};
		self.mapParam(param);

		view.drawFunc = self.drawFunc;
		view.background_(Color.clear);

		view.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			var idx;
			[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction !");
			if(buttonNumber == 1) {
				self.showContextMenu(x);
			} {
				self.inMouseMove = true;
				self.setCellAtPos(x, 1 - ( ( y + offsety )/self.virtualBounds.height ), \down);
			};
		});
		view.mouseMoveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			var idx;
			//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseMoveAction");
			self.setCellAtPos(x, 1 - ( ( y + offsety )/self.virtualBounds.height ), \move);

		});
		view.mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			var idx;
			//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseMoveAction");
			self.inMouseMove = false;
			view.refresh;

		});
		view.addUniqueMethod(\proto, { self });
		view;
	},

));

WindowDef(\ModulatorStrip_button, (
	parent: WindowDef(\ModulatorStrip_slider).proto,


	drawBarLabel: { arg self;
		// NOOP
	},

	setCellAtPos: { arg self, pxpos, val, mouseActionType;
		var xrel, idx;
		var gxpos;
		var param;
		gxpos = self.pixelPointToGridPoint(Point(pxpos, 0)).x;
		idx	= ( gxpos / self.cellWidth ).asInteger;
		idx.debug("idx");
		idx = idx.clip(0,( self.areasize.x/self.cellWidth ).asInteger-1);
		[pxpos, gxpos, idx, self.cellWidth].debug("ModulatorStrip_slider.setCellAtPos");
		if(idx != self.lastSetIndex or: { mouseActionType == \down }) {
			self.lastSetIndex = idx;
			param = self.targetParam.at(idx);
			param.normSet(1-param.normGet.round);
			self.view.refresh;
		};
	},
	

));

WindowDef(\ModulatorStrip_cursor, (
	parent: WindowDef(\ModulatorStrip_slider).proto,


	drawBarLabel: { arg self;
		// NOOP
	},

	setCellAtPos: { arg self, pxpos, val, mouseActionType;
		// NOOP
	},

	centered: false,
	centered_: {},

	cursorEnabled: true,
	
	drawFunc: { arg self;
		{
			var rect;
			var arr = self.targetParam.get;
			var gxoffset = self.pixelPointToGridPoint(Point(0,0)).x;
			//gxoffset = gxoffset.trunc(self.cellWidth);
			//Pen.translate(28,-7);
			[gxoffset, arr, self.targetParam, self.targetParam.get].debug("drawFunc");
			//rect = Rect(5,5,100,100);
			//rect = self.normRectToPixelRect(Rect(0,0,1,1));
			//[self.viewport, self.virtualBounds, rect].debug("ss");
			//Pen.addRect(rect);
			//Pen.fill;
			self.seqSize.do { arg item, idx;
				//var val = self.targetParam.at(idx).spec.unmap(arr[idx]);
				var val = self.targetParam.at(idx).normGet;
				var label = self.targetParam.at(idx).get;
				if(self.cursorEnabled == true and: {self.cursorIndex == idx}) {
					self.drawBar(0, idx, 1, self.colors.full.complementary, self.colors.empty);
				} {
					self.drawBar(0, idx, 1, self.colors.full, self.colors.empty);
				};
				if(idx != 0 and: {idx%8 == 0}) {
					self.drawSeparator(0, idx, label, Color.white, 4);
				} {
					if(idx != 0 and: {idx%4 == 0}) {
						self.drawSeparator(0, idx, label, Color.white, 2);
					}
				};
			};
		}
	},

));
