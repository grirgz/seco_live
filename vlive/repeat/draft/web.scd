
// trying to generate sound from webpage
Quarks.install("XML")

DOMDocument("/home/ggz/Documents/Google.clean.html")
DOMDocument("/home/ggz/Documents/sc/DuckDuckGo.xml")
DOMDocument("/home/ggz/Documents/sc/linuxfr.xml")
~dom = DOMDocument("/home/ggz/Documents/sc/linuxfr2.xml")
~dom_duck = DOMDocument("/home/ggz/Documents/sc/DuckDuckGo.xml");
~dom_duck = DOMDocument("/home/ggz/Documents/sc/DuckDuckGo.xml");
(
~doms = (
	linuxfr: DOMDocument("/home/ggz/Documents/sc/linuxfr2.xml"),
	duck: DOMDocument("/home/ggz/Documents/sc/DuckDuckGo.xml"),
	sculpting: DOMDocument("/home/ggz/Documents/sc/Sculpting.xml"),
);
)

| sed 's,<\(\([^<> ]*\)[^<>]*\)/>,<\1></\2>,' // change self-closed tags to empty ones
xmllint -xmlout -recover -html DuckDuckGo.html | sed 's,<\(\([^<> ]*\)[^<>]*\)/>,<\1></\2>,g' > DuckDuckGo.xml // clean file

~dom.inspect
~dom.getChildNodes
(
	~strtonum = { arg str;
		var ret = 0;
		str.do({ arg char;
			ret = ret + char.ascii;
		});
		ret;
	};
	~walkxml_jazzy = { arg doc;
		// jazzy
		var me = thisFunction;
		( 1/8 ).wait;
		doc.getChildNodes.collect({ arg node;
			var pat;
			var name = node.getNodeName;
			var num = ~strtonum.(name);
			var parnum = ~strtonum.(doc.getNodeName);
			node.getNodeName.postln;
			if(node.getChildNodes.size != 0) {
				pat = Pbind(\dur, Pseq([ [1/8,1/4,1/2].wrapAt(parnum) ],1), \midinote, num % 32 + 32 + [-12,0,12].choose).play;
				me.(node);
				pat.stop;
			} {
				me.(node);
			};
			("/"++node.getNodeName).postln;
		})
	};

	~walkxml_depth = { arg doc, lvl=0;
		// melody on depth
		var me = thisFunction;
		( 1/8 ).wait;
		doc.getChildNodes.collect({ arg node;
			var pat;
			var name = node.getNodeName;
			var num = ~strtonum.(name);
			var parnum = ~strtonum.(doc.getNodeName);
			var note = lvl+32+12+12;
			node.getNodeName.postln;
			pat = Pbind(
				\dur, Pn(1/8,1), 
				\legato, 0.1,
				\midinote, note,
			).play;
			me.(node, lvl+1);
			("/"++node.getNodeName).postln;
		})
	};

	~walkxml_lvlidx = { arg doc, lvl=0;
		// melody on lvl and idx
		var msign = 1;
		var me = thisFunction;
		( 1/8 ).wait;
		msign = [-1,1].wrapAt(lvl);
		doc.getChildNodes.do({ arg node, idx;
			var pat;
			var name = node.getNodeName;
			var num = ~strtonum.(name);
			var parnum = ~strtonum.(doc.getNodeName);
			var note = lvl+32 + ( ( lvl%5 )*12 ) + ( idx * msign );
			var dur;
			"state: %".format((name:name, note:note, lvl:lvl, idx:idx, msign:msign, num:num, parnum:parnum)).postln;
			//node.getNodeName.postln;
			if(node.getChildNodes.size < 8) {
				dur = Pn(1/8,1);
			} {
				dur = Pn(1/[1,8,2,4,8,16].wrapAt(lvl),inf);
			};
			pat = Pbind(
				\dur, dur, 
				\legato, 0.5,
				\midinote, note,
			).play;
			me.(node, lvl+1);
			pat.stop;
			("/"++node.getNodeName).postln;
		})
	};

	~walkxml_bf = { arg doc;
		// walk breadth first
		var queue = List.new;
		var lvl = 0;
		queue.add([doc]);
		while { queue.size >0 } {
			var nodes = queue.removeAt(0);
			lvl = lvl + 1;
			nodes.do { arg node, idx;
				(name:node.getNodeName, lvl:lvl).postln;
				Pbind(\dur, Pn(1/2,1), \midinote, ( lvl%32 )+32+[0,4,7,9].wrapAt(idx), \octave, [3,4,5].wrapAt(idx*2+1)).play;
				if(node.getChildNodes.size > 0) {
					queue.add(node.getChildNodes);
				}
			};
			"wait".postln;
			( 1/2 ).wait;
		}
	};

	~curdom = ~doms.linuxfr;
	Tdef(\main,{
		~walkxml_lvlidx.(~curdom);
		//~walkxml.(~dom_duck);
	}).play;
	Tdef(\main2,{
		~walkxml_jazzy.(~curdom);
		//~walkxml.(~dom_duck);
	}).play;
)

