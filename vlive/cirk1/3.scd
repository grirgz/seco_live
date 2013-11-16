~name = '3';

(
	~save_maps = { arg tracks, suffix;
		tracks.do { arg track;
			~save_object.(track+++suffix, Ndef(track).nodeMap);
		};
	};
	~load_maps = { arg tracks, suffix, do;
		tracks.collect { arg track;
			var res;
			res = ~load_object.(track+++suffix);
			do.(track, res);
		};
		
	};

	~set_maps = { arg tracks, suffix;
		~load_maps.(tracks, suffix, { arg track, obj;
			Ndef(track).quant = Pdef.defaultQuant;
			Ndef(track).setNodeMap(obj);
		})
	};
	~fade_to_maps = { arg tracks, suffix;
		~load_maps.(tracks, suffix, { arg track, obj;
			Ndef(track).quant = Pdef.defaultQuant;
			Ndef(track).fadeToMap(obj);
		})
	};

);
