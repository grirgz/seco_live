(
	s.boot;
Ndef(\bla, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Pdef(\zozo, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

ParamProto.init(true)
ParamTimeline(\bla3).clear;
ParamTimeline(\bla3, Param(Ndef(\bla), \freq)).edit
ParamTimeline(\zozo).clear
ParamTimeline(\zozo).edit

ParamTimeline(\bla3, Param(Ndef(\bla), \freq)).presetCompileString.editorInsert
(
ParamTimeline('bla3').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.125, \label: 'start', \playDur: 0.125, \relDur: 0.125, \sustain: 0, \type: 'start', ),
	(\absTime: 0.125, \dur: 1.375, \legato: 1, \level: 93.329629700485, \next_absTime: 1.5, \next_level: 1636.5225040402, \playDur: 1.375, \relDur: 1.375, \sustain: 1.375, ),
	(\absTime: 1.5, \dur: 1.75, \legato: 1, \level: 1636.5225040402, \next_absTime: 3.25, \next_level: 386.13954577665, \playDur: 1.75, \relDur: 1.75, \sustain: 1.75, ),
	(\absTime: 3.25, \dur: 0.25, \legato: 1, \level: 386.13954577665, \next_absTime: 3.5, \next_level: 2987.0742878246, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 3.5, \dur: 3.5, \legato: 1, \level: 2987.0742878246, \next_absTime: 7.0, \next_level: 425.16365125682, \playDur: 3.5, \relDur: 3.5, \sustain: 3.5, ),
	(\absTime: 7.0, \dur: 0.5, \legato: 1, \level: 425.16365125682, \next_absTime: 7.5, \next_level: 875.27591521752, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 7.5, \dur: 0.25, \legato: 1, \level: 875.27591521752, \next_absTime: 7.75, \next_level: 105.26508635251, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 7.75, \dur: 0.25, \legato: 1, \level: 105.26508635251, \playDur: 0.25, \relDur: 0.25, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


ClipTimeline(\test2).edit
ProtoDef(\GlobalLibrary).clipFactories.keys
ProtoDef(\GlobalLibrary).init_default_clip_factories

( 'instrument': \env_segment, 'playDur': 1.5, 'dur': 1.5, 'time': 1.5,
  'absTime': 0.375, 'out': BusDef('ParamTimeline_bla3'), 'legato': 1, 'curve': 0, 'level': 342.35720568702,
  'delta': 1.5, 'relDur': 1.5, 'type': \rest )


Ndef(\bla).edit
Ndef(\bla).get(\freq)
BusDef(\ParamTimeline_bla3).index
BusDef(\ParamTimeline_bla3).set(200)
Ndef(\bla).get(\freq).asCachedBus.getCached
Ndef(\bla).getVal(\freq)
Ndef(\bla).inBusMode(\freq)
\c2.asBus.set(400)
\c2.asBus.numChannels
ParamTimeline(\bla3, Param(Ndef(\bla), \freq)).edit
ParamTimeline(\bla3).param.set(1000)
ParamTimeline(\bla4, Param(Ndef(\bla), \lpfr)).edit
ParamTimeline(\zozo, Param(Pdef(\zozo), \freq)).edit
ParamTimeline(\zozo2, Param(Pdef(\zozo), \fff, \unipolar)).edit
Font

~t = 185/2/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[790].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
	])
)).play;
);

(
Ndef(\bla, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * ( SinOsc.ar(freq/(1..8) * ( SinOsc.kr(0.31) * 0.41 + 1 )) * 0.1 + 1 ));
	//sig = DC.ar(0);
	sig = sig + LFPulse.ar(freq/4 * ( SinOsc.ar(freq*((1..8) * LFNoise1.kr(1/2).range(0.0,1.0)+1) * ( SinOsc.kr(0.31) * 0.41 + 1 )) * 0.1 + 1 ));
	sig = RHPF.ar(sig, \lpfr.kr(0.3) * freq, \rq.kr(0.5));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan) * 0.8;
}).play;
)



//////////////////////////////////////
//////////////////////////////////////
//////////////////////////////////////
//////////////////////////////////////
///// design the vertical ruler with dynamic adding of graduations when zooming




ParamTimeline(\zozo, Param(Pdef(\zozo), \freq)).edit
ParamTimeline(\zozo2, Param(Pdef(\zozo), \fff, \unipolar)).edit
ParamTimeline(\zozo3, Param(Pdef(\zozo), \zert, ControlSpec(10,1320,\lin))).edit
ParamTimeline(\zozo4, Param(Pdef(\zozo), \zert, ControlSpec(10,13,\lin))).edit

(
	// 1ere etape: faire une graduation statique, qui rajoute pas des lignes quand on zoom mais qui se contente
	// de mettre a l'echelle
	// methode:
	//		diviser la hauteur en gridunit par lineCount=10, un nombre arbitraire de graduations
	//		on a donc la hauteur d'une graduation qui est areasize.y/lineCount
	//		pour chaque idx, la position en pixel est gridPointToPixelPoint(idx*areasize/10).y
	~horizontal_grid_do = { arg view, fun;
		// dynamic grid generation
		var unitRect = view.gridRectToPixelRect(Rect(0,0,1,1));

		var minsize = 40;
		var bounds = view.bounds;
		var areasize = view.areasize;
		var viewport = view.viewport;
		var ylen = unitRect.height; // number of pixel for one cell height
		var offset = unitRect.top;
		var factor = 1;
		var lineCount; 
		var xxx;
		factor = 2**( ( ylen/minsize ).log2.asInteger );
		factor = 1/100;
		// plus on zoom et plus unitRect donc ylen augmente sa valeur en pixel, ce qui rend factor plus grand
		//factor = ( ylen/minsize ).asInteger; // combien de minsize pixels dans une unit ?
		//xlen.debug("xlen");

		//[ (areasize.x * viewport.origin.x).asInteger, (areasize.x * factor * viewport.width + 1).asInteger ].debug("start, end XXXXXX");
		// on prend la hauteur visible en grid unit (area*viewport) qu'on multiplie par le factor
		// par exemple s'il y a moyen de caser 5 graduations dans un gridunit, le factor est de 5
		// donc si 3 gridunit sont visibles a l'ecran, alors il y aura 3*5=15 graduations
		//lineCount = (factor * areasize.y * viewport.height + 1).asInteger;
		lineCount = 10;
		lineCount.do { arg idx;
			var oidx, y;

			// idx = 0 when at top of zoomed screen
			// idx * ylen = y coordinate of lines for each idx in lineCount
			// idx * ylen / factor = put 9 lines for each gridunit if factor = 9
			// viewport.bottom = 1 when slider upper bound is at the top most
			// 1-viewport.bottom = 0 when slider upper bound is at the top most
			[offset, ( bounds.height - offset  ), 1-viewport.bottom, areasize.y * ( 1-viewport.bottom )].debug("offset");

			xxx = idx * ylen / factor;

			// if zoomed viewport is at bottom
			// oidx is like virtual idx, even at start of screen, if viewport is offset, oidx will be offset
			// add 1 because at idx 0, the text is half out of screen
			oidx = (idx + (areasize.y * ( 1-viewport.bottom ).debug("originy") * factor).asInteger + 1);
			[oidx, idx, lineCount, ylen].debug("oidx, idx, lineCount, ylen");
			factor.debug("factor");
			y = oidx * ylen / factor + ( bounds.height - offset  );
			y = oidx * ylen / factor;
			y = view.gridPointToPixelPoint(idx * (areasize/lineCount)).y;

			fun.(factor, y, oidx, idx, lineCount, xxx);
		}
	};
	~draw_param_values = { arg me, param;
		var areasize = me.areasize;
		//~drawme.(this, areasize);
		areasize.debug("draw_param_values: areasize ===========================");
		if(param.notNil) {
			var font = Font.default.copy.size_(9);
			//var pixelPerLine = 20;
			//var gridPerLine = me.pixelRectToGridRect(Rect(0,0,10,pixelPerLine)).height;
			//var lineCount = ( me.areasize.y/gridPerLine ).asInteger;
			//lineCount.debug("lineCount");
			Pen.use {
				Pen.width = 1;
				Pen.color = Color.black;
				~horizontal_grid_do.(me, { arg factor, y, oidx, idx, lineCount, xxx;
					var normVal = me.pixelPointToNormPoint(Point(1,y)).y;
					var val;
					val = param.spec.map(normVal).asStringPrec(5); 
					[normVal, val].debug("val");
					lineCount.debug("lineCount");
					Pen.use{
						//Pen.line(Point(x,0), Point(x,this.virtualBounds.height));
						// when idx = 0, 
						y.debug("y");
						//val = oidx.asString;
						Pen.stringAtPoint(val, Point(10,y), font);
						//Pen.stroke;
					}
				});
			}
		}
	}
)
(
	// 2ere etape: calculer un facteur qui multiplie le lineCount en fonction du zoom
	~horizontal_grid_do = { arg view, fun;
		// dynamic grid generation
		var unitRect = view.gridRectToPixelRect(Rect(0,0,1,1));

		var minsize = 40;
		var bounds = view.bounds;
		var areasize = view.areasize;
		var viewport = view.viewport;
		var ylen = unitRect.height; // number of pixel for one cell height
		var offset = unitRect.top;
		var factor = 1;
		var lineCount; 
		var xxx;
		factor = 2**( ( ylen/minsize ).log2.asInteger );
			factor.debug("factor");
		//factor = 1/100;
		// plus on zoom et plus unitRect donc ylen augmente sa valeur en pixel, ce qui rend factor plus grand
		//factor = ( ylen/minsize ).asInteger; // combien de minsize pixels dans une unit ?
		//xlen.debug("xlen");

		//[ (areasize.x * viewport.origin.x).asInteger, (areasize.x * factor * viewport.width + 1).asInteger ].debug("start, end XXXXXX");
		// on prend la hauteur visible en grid unit (area*viewport) qu'on multiplie par le factor
		// par exemple s'il y a moyen de caser 5 graduations dans un gridunit, le factor est de 5
		// donc si 3 gridunit sont visibles a l'ecran, alors il y aura 3*5=15 graduations
		//lineCount = (factor * areasize.y * viewport.height + 1).asInteger;
		lineCount = ( 10 * factor * 100 ).asInteger;
		lineCount.do { arg idx;
			var oidx, y;

			// idx = 0 when at top of zoomed screen
			// idx * ylen = y coordinate of lines for each idx in lineCount
			// idx * ylen / factor = put 9 lines for each gridunit if factor = 9
			// viewport.bottom = 1 when slider upper bound is at the top most
			// 1-viewport.bottom = 0 when slider upper bound is at the top most
			[offset, ( bounds.height - offset  ), 1-viewport.bottom, areasize.y * ( 1-viewport.bottom )].debug("offset");

			xxx = idx * ylen / factor;

			// if zoomed viewport is at bottom
			// oidx is like virtual idx, even at start of screen, if viewport is offset, oidx will be offset
			// add 1 because at idx 0, the text is half out of screen
			oidx = (idx + (areasize.y * ( 1-viewport.bottom ).debug("originy") * factor).asInteger + 1);
			[oidx, idx, lineCount, ylen].debug("oidx, idx, lineCount, ylen");
			y = oidx * ylen / factor + ( bounds.height - offset  );
			y = oidx * ylen / factor;
			y = view.gridPointToPixelPoint(idx * (areasize/lineCount)).y;

			fun.(factor, y, oidx, idx, lineCount, xxx);
		}
	};
	~draw_param_values = { arg me, param;
		var areasize = me.areasize;
		//~drawme.(this, areasize);
		areasize.debug("draw_param_values: areasize ===========================");
		if(param.notNil) {
			var font = Font.default.copy.size_(9);
			//var pixelPerLine = 20;
			//var gridPerLine = me.pixelRectToGridRect(Rect(0,0,10,pixelPerLine)).height;
			//var lineCount = ( me.areasize.y/gridPerLine ).asInteger;
			//lineCount.debug("lineCount");
			Pen.use {
				Pen.width = 1;
				Pen.color = Color.black;
				~horizontal_grid_do.(me, { arg factor, y, oidx, idx, lineCount, xxx;
					var normVal = me.pixelPointToNormPoint(Point(1,y)).y;
					var val;
					val = param.spec.map(normVal).asStringPrec(5); 
					[normVal, val].debug("val");
					lineCount.debug("lineCount");
					Pen.use{
						//Pen.line(Point(x,0), Point(x,this.virtualBounds.height));
						// when idx = 0, 
						y.debug("y");
						//val = oidx.asString;
						Pen.stringAtPoint(val, Point(10,y), font);
						//Pen.stroke;
					}
				});
			}
		}
	}
)
(
	// 3ere etape: trouver un facteur qui change pas en fonction de la spec
	~horizontal_grid_do = { arg view, fun;
		// dynamic grid generation
		var unitRect = view.gridRectToPixelRect(Rect(0,0,1,1));
		var nunitRect = view.normRectToPixelRect(Rect(0,0,1,1));

		var minsize = 30;
		var bounds = view.bounds;
		var areasize = view.areasize;
		var viewport = view.viewport;
		var ylen = unitRect.height; // number of pixel for one cell height
		var offset = unitRect.top;
		var factor = 1;
		var lineCount; 
		var xxx;
		factor = 2**( ( ylen/minsize ).log2.asInteger );
		factor = 2**( ( nunitRect.height/minsize ).log2.asInteger );
			factor.debug("factor");
		//factor = 1/100;
		// plus on zoom et plus unitRect donc ylen augmente sa valeur en pixel, ce qui rend factor plus grand
		//factor = ( ylen/minsize ).asInteger; // combien de minsize pixels dans une unit ?
		//xlen.debug("xlen");

		//[ (areasize.x * viewport.origin.x).asInteger, (areasize.x * factor * viewport.width + 1).asInteger ].debug("start, end XXXXXX");
		// on prend la hauteur visible en grid unit (area*viewport) qu'on multiplie par le factor
		// par exemple s'il y a moyen de caser 5 graduations dans un gridunit, le factor est de 5
		// donc si 3 gridunit sont visibles a l'ecran, alors il y aura 3*5=15 graduations
		//lineCount = (factor * areasize.y * viewport.height + 1).asInteger;
		lineCount = ( factor ).asInteger;
		lineCount.do { arg idx;
			var oidx, y;

			// idx = 0 when at top of zoomed screen
			// idx * ylen = y coordinate of lines for each idx in lineCount
			// idx * ylen / factor = put 9 lines for each gridunit if factor = 9
			// viewport.bottom = 1 when slider upper bound is at the top most
			// 1-viewport.bottom = 0 when slider upper bound is at the top most
			[offset, ( bounds.height - offset  ), 1-viewport.bottom, areasize.y * ( 1-viewport.bottom )].debug("offset");

			xxx = idx * ylen / factor;

			factor.debug("factor");
			// if zoomed viewport is at bottom
			// oidx is like virtual idx, even at start of screen, if viewport is offset, oidx will be offset
			// add 1 because at idx 0, the text is half out of screen
			oidx = (idx + (areasize.y * ( 1-viewport.bottom ).debug("originy") * factor).asInteger + 1);
			[oidx, idx, lineCount, ylen].debug("oidx, idx, lineCount, ylen");
			y = oidx * ylen / factor + ( bounds.height - offset  );
			y = oidx * ylen / factor;
			y = view.gridPointToPixelPoint(idx * (areasize/lineCount)).y;

			fun.(factor, y, oidx, idx, lineCount, xxx);
		}
	};
	~draw_param_values = { arg me, param;
		var areasize = me.areasize;
		//~drawme.(this, areasize);
		areasize.debug("draw_param_values: areasize ===========================");
		if(param.notNil) {
			var font = Font.default.copy.size_(9);
			//var pixelPerLine = 20;
			//var gridPerLine = me.pixelRectToGridRect(Rect(0,0,10,pixelPerLine)).height;
			//var lineCount = ( me.areasize.y/gridPerLine ).asInteger;
			//lineCount.debug("lineCount");
			Pen.use {
				Pen.width = 1;
				Pen.color = Color.black;
				~horizontal_grid_do.(me, { arg factor, y, oidx, idx, lineCount, xxx;
					var normVal = me.pixelPointToNormPoint(Point(1,y)).y;
					var val;
					val = param.spec.map(normVal).asStringPrec(5); 
					[normVal, val].debug("val");
					lineCount.debug("lineCount");
					Pen.use{
						//Pen.line(Point(x,0), Point(x,this.virtualBounds.height));
						// when idx = 0, 
						y.debug("y");
						//val = oidx.asString;
						Pen.stringAtPoint(val, Point(10,y), font);
						//Pen.stroke;
					}
				});
			}
		}
	}
)
(
	// 4ere etape: ne pas calculer les valeurs hors ecran
	~horizontal_grid_do = { arg view, fun;
		// dynamic grid generation
		var unitRect = view.gridRectToPixelRect(Rect(0,0,1,1));
		var nunitRect = view.normRectToPixelRect(Rect(0,0,1,1));

		var minsize = 30;
		var bounds = view.bounds;
		var areasize = view.areasize;
		var viewport = view.viewport;
		var ylen = unitRect.height; // number of pixel for one cell height
		var offset = unitRect.top;
		var factor = 1;
		var lineCount; 
		var xxx;
		var startidx, endidx;
		var vlineCount;
		factor = 2**( ( ylen/minsize ).log2.asInteger );
		factor = 2**( ( nunitRect.height/minsize ).log2.asInteger );
			factor.debug("factor");
		//factor = 1/100;
		// plus on zoom et plus unitRect donc ylen augmente sa valeur en pixel, ce qui rend factor plus grand
		//factor = ( ylen/minsize ).asInteger; // combien de minsize pixels dans une unit ?
		//xlen.debug("xlen");

		//[ (areasize.x * viewport.origin.x).asInteger, (areasize.x * factor * viewport.width + 1).asInteger ].debug("start, end XXXXXX");
		// on prend la hauteur visible en grid unit (area*viewport) qu'on multiplie par le factor
		// par exemple s'il y a moyen de caser 5 graduations dans un gridunit, le factor est de 5
		// donc si 3 gridunit sont visibles a l'ecran, alors il y aura 3*5=15 graduations
		//lineCount = (factor * areasize.y * viewport.height + 1).asInteger;
		lineCount = ( factor ).asInteger;
		endidx = ( view.pixelPointToGridPoint(Point(0,0)).y*lineCount/areasize.y ).asInteger + 2;
		startidx = ( view.pixelPointToNormPoint(Point(0,bounds.height)).y*lineCount ).asInteger;
		vlineCount = endidx - startidx;
		vlineCount.do { arg idx;
			var oidx, y;
			var vidx = idx + startidx;

			[startidx, endidx, vlineCount].debug("startidx");
			// idx = 0 when at top of zoomed screen
			// idx * ylen = y coordinate of lines for each idx in lineCount
			// idx * ylen / factor = put 9 lines for each gridunit if factor = 9
			// viewport.bottom = 1 when slider upper bound is at the top most
			// 1-viewport.bottom = 0 when slider upper bound is at the top most
			[offset, ( bounds.height - offset  ), 1-viewport.bottom, areasize.y * ( 1-viewport.bottom )].debug("offset");

			factor.debug("factor");
			// if zoomed viewport is at bottom
			// oidx is like virtual idx, even at start of screen, if viewport is offset, oidx will be offset
			// add 1 because at idx 0, the text is half out of screen
			y = view.gridPointToPixelPoint(vidx * (areasize/lineCount)).y;

			fun.(factor, y, oidx, idx, lineCount, xxx);
		}
	};
	~draw_param_values = { arg me, param;
		var areasize = me.areasize;
		//~drawme.(this, areasize);
		areasize.debug("draw_param_values: areasize ===========================");
		if(param.notNil) {
			var font = Font.default.copy.size_(9);
			//var pixelPerLine = 20;
			//var gridPerLine = me.pixelRectToGridRect(Rect(0,0,10,pixelPerLine)).height;
			//var lineCount = ( me.areasize.y/gridPerLine ).asInteger;
			//lineCount.debug("lineCount");
			Pen.use {
				Pen.width = 1;
				Pen.color = Color.black;
				~horizontal_grid_do.(me, { arg factor, y, oidx, idx, lineCount, xxx;
					var normVal = me.pixelPointToNormPoint(Point(1,y)).y;
					var val;
					val = param.spec.map(normVal).asStringPrec(5); 
					[normVal, val].debug("val");
					lineCount.debug("lineCount");
					Pen.use{
						//Pen.line(Point(x,0), Point(x,this.virtualBounds.height));
						// when idx = 0, 
						y.debug("y");
						//val = oidx.asString;
						Pen.stringAtPoint(val, Point(10,y), font);
						//Pen.stroke;
					}
				});
			}
		}
	}
)
(
	// 5eme etape: nettoyage
	~horizontal_grid_do = { arg view, fun;
		// dynamic grid generation
		var unitRect = view.normRectToPixelRect(Rect(0,0,1,1));
		var minsize = 30;
		var bounds = view.bounds;
		var areasize = view.areasize;
		var ylen = unitRect.height; // number of pixel of the virtual height, the more we zoom, the bigger
		var factor = 1;
		var lineCount; 
		var startidx, endidx;
		var vlineCount;
		// we want a graduation each minsize pixels, we take the virtual height and count how many graduations
		factor = 2**( ( ylen/minsize ).log2.asInteger );
		lineCount = factor.asInteger;
		endidx = ( view.pixelPointToNormPoint(Point(0,0)).y*lineCount ).asInteger + 2;
		startidx = ( view.pixelPointToNormPoint(Point(0,bounds.height)).y*lineCount ).asInteger;
		vlineCount = endidx - startidx;
		vlineCount.do { arg idx;
			var y;
			var vidx = idx + startidx;
			y = view.normPointToPixelPoint(Point(0,vidx/lineCount)).y;
			// we use vidx and lineCount together because the vertue of vidx is it behave like it was the real index, but skip the off-screen ones, so we want the real lineCount too
			fun.(y, vidx, lineCount, idx, vlineCount);
		}
	};
	~draw_param_values = { arg me, param;
		var areasize = me.areasize;
		//~drawme.(this, areasize);
		if(param.notNil) {
			var font = Font.default.copy.size_(9);
			Pen.use {
				Pen.width = 1;
				Pen.color = Color.black;
				~horizontal_grid_do.(me, { arg y, idx, lineCount;
					var normVal = me.pixelPointToNormPoint(Point(1,y)).y;
					var val;
					val = param.spec.map(normVal).asStringPrec(5); 
					//[normVal, val].debug("val");
					Pen.stringAtPoint(val, Point(10,y), font);
				});
			}
		}
	}
)
(
	// old code
	~horizontal_grid_do = { arg view, fun;
		// dynamic grid generation
		var unitRect = view.gridRectToPixelRect(Rect(0,0,1,1));

		var minsize = 40;
		var bounds = view.bounds;
		var areasize = view.areasize;
		var viewport = view.viewport;
		var ylen = unitRect.height; // number of pixel for one cell height
		var offset = unitRect.top;
		var factor = 1;
		var lineCount; 
		var xxx;
		factor = 2**( ( ylen/minsize ).log2.asInteger );
		factor = 1/100;
		// plus on zoom et plus unitRect donc ylen augmente sa valeur en pixel, ce qui rend factor plus grand
		//factor = ( ylen/minsize ).asInteger; // combien de minsize pixels dans une unit ?
		//xlen.debug("xlen");

		//[ (areasize.x * viewport.origin.x).asInteger, (areasize.x * factor * viewport.width + 1).asInteger ].debug("start, end XXXXXX");
		// on prend la hauteur visible en grid unit (area*viewport) qu'on multiplie par le factor
		// par exemple s'il y a moyen de caser 5 graduations dans un gridunit, le factor est de 5
		// donc si 3 gridunit sont visibles a l'ecran, alors il y aura 3*5=15 graduations
		lineCount = (factor * areasize.y * viewport.height + 1).asInteger;
		lineCount.do { arg idx;
			var oidx, y;

			// idx = 0 when at top of zoomed screen
			// idx * ylen = y coordinate of lines for each idx in lineCount
			// idx * ylen / factor = put 9 lines for each gridunit if factor = 9
			// viewport.bottom = 1 when slider upper bound is at the top most
			// 1-viewport.bottom = 0 when slider upper bound is at the top most
			[offset, ( bounds.height - offset  ), 1-viewport.bottom, areasize.y * ( 1-viewport.bottom )].debug("offset");

			xxx = idx * ylen / factor;

			// if zoomed viewport is at bottom
			// oidx is like virtual idx, even at start of screen, if viewport is offset, oidx will be offset
			// add 1 because at idx 0, the text is half out of screen
			oidx = (idx + (areasize.y * ( 1-viewport.bottom ).debug("originy") * factor).asInteger + 1);
			[oidx, idx, lineCount, ylen].debug("oidx, idx, lineCount, ylen");
			factor.debug("factor");
			y = oidx * ylen / factor + ( bounds.height - offset  );
			y = oidx * ylen / factor;

			fun.(factor, y, oidx, idx, lineCount, xxx);
		}
	};
	~draw_param_values = { arg me, param;
		var areasize = me.areasize;
		//~drawme.(this, areasize);
		areasize.debug("draw_param_values: areasize ===========================");
		if(param.notNil) {
			var font = Font.default.copy.size_(9);
			//var pixelPerLine = 20;
			//var gridPerLine = me.pixelRectToGridRect(Rect(0,0,10,pixelPerLine)).height;
			//var lineCount = ( me.areasize.y/gridPerLine ).asInteger;
			//lineCount.debug("lineCount");
			Pen.use {
				Pen.width = 1;
				Pen.color = Color.black;
				~horizontal_grid_do.(me, { arg factor, y, oidx, idx, lineCount, xxx;
					var normVal = me.pixelPointToNormPoint(Point(1,y)).y;
					var val;
					val = param.spec.map(normVal).asStringPrec(5); 
					[normVal, val].debug("val");
					lineCount.debug("lineCount");
					Pen.use{
						//Pen.line(Point(x,0), Point(x,this.virtualBounds.height));
						// when idx = 0, 
						y.debug("y");
						//val = oidx.asString;
						Pen.stringAtPoint(val, Point(10,y), font);
						//Pen.stroke;
					}
				});
			}
		}
	}
)
(
	~draw_param_values = { arg me, param;
		var areasize = me.areasize;
		//~drawme.(this, areasize);
		areasize.debug("draw_param_values: areasize");
		if(param.notNil) {
			var font = Font.default.copy.size_(9);
			var pixelPerLine = 20;
			var gridPerLine = me.pixelRectToGridRect(Rect(0,0,10,pixelPerLine)).height;
			var lineCount = ( me.areasize.y/gridPerLine ).asInteger;
			lineCount.debug("lineCount");
			Pen.use {
				Pen.width = 1;
				Pen.color = Color.black;
				lineCount.do { arg idx;
					var pixpos = me.gridPointToPixelPoint(Point(1,idx * gridPerLine));
					var val = param.spec.map(idx/lineCount).asStringPrec(5); // reverse
					Pen.stringAtPoint(val, pixpos, font);

				};
			}
		}
	}
)

