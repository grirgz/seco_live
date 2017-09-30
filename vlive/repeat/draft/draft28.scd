0b1b
// http://wiki.bash-hackers.org/scripting/terminalcodes
0x1b.asAscii
"%[10;10H===========================".format(0x1b.asAscii).postln

(
ProtoDef(\term, (
	colors: IdentityDictionary.newFrom([
		\black,
		\red,
		\green,
		\yellow,
		\blue,
		\magenta,
		\cyan,
		\white,
		\default,
	].collect({ arg k, idx; [ k, ( idx+30 ) ] }).flatten),

	attributes: IdentityDictionary.newFrom( [
		\reset,
		\bold,
		\dim,
		\standout,
		\underscore,
		\blink,
		\reverse,
		\hidden,
	].collect({ arg k, idx; [ k, idx ] }).flatten),

	moveTo: { arg self, x, y;
		"%[%;%H".format(0x1b.asAscii, y, x).post
	},

	foreground_: { arg self, color;
		"%[%m".format(0x1b.asAscii, self.colors[color]).post
	},

	background_: { arg self, color;
		"%[%m".format(0x1b.asAscii, self.colors[color]+10).post
	},

	attribute_: { arg self, attr;
		"%[%m".format(0x1b.asAscii, self.attributes[attr]).post
	},

	clearScreen: {
		"%[2Jm".format(0x1b.asAscii).post
	}

));
)

[ 0 m	sgr0	Reset all attributes
[ 1 m	bold	Set "bright" attribute
[ 2 m	dim	Set "dim" attribute
[ 3 m	smso	Set "standout" attribute
[ 4 m	set smul unset rmul :?:	Set "underscore" (underlined text) attribute
[ 5 m	blink	Set "blink" attribute
[ 7 m	rev	Set "reverse" attribute
[ 8 m	invis	Set "hidden" attribute


ProtoDef(\term).colors
(
	Tdef(\colorme, {
		ProtoDef(\term).clearScreen;
		500.do {

			ProtoDef(\term).moveTo(rrand(1,30), rrand(1,70));
			ProtoDef(\term).background_(ProtoDef(\term).colors.keys.choose);
			["x", "|","-", "/"].choose.post;
			0.01.wait;
		}

	}).play;
)

(
	Tdef(\colorme, {
		14.do {
			fork {
				var px = rrand(1,40), py = rrand(1,90);
				var col = ProtoDef(\term).colors.keys.choose;
				var fcol = ProtoDef(\term).colors.keys.choose;
				var ch = ["x", "|","-", "/"].choose;
				ProtoDef(\term).clearScreen;
				500.do {
					px = px+[1,0,-1].choose;
					py = py+[1,0,-1].choose;
				
					ProtoDef(\term).moveTo(px, py);
					ProtoDef(\term).background_(col);
					ProtoDef(\term).foreground_(fcol);
					ch.post;
					0.1.wait;
				}
			}
		}

	}).play;
)

(
	Tdef(\colorme, {
		14.do {
			fork {
				var px = rrand(1,40), py = rrand(1,90);
				var col = ProtoDef(\term).colors.keys.choose;
				var fcol = ProtoDef(\term).colors.keys.choose;
				var ch = ["x", "|","-", "/"].choose;
				var pat = Prand([1,0,-1],inf).stutter(Pwhite(1,8));
				var pxstr = pat.asStream;
				var pystr = pat.asStream;
				ProtoDef(\term).clearScreen;
				500.do {
					px = px+pxstr.next;
					py = py+pystr.next;
				
					ProtoDef(\term).moveTo(px, py);
					ProtoDef(\term).background_(col);
					ProtoDef(\term).foreground_(fcol);
					ch.post;
					0.1.wait;
				}
			}
		}

	}).play;
)

(
	// downfall
	Tdef(\colorme, {
		14.do {
			fork {
				var px = rrand(1,40), py = rrand(1,90);
				var col = ProtoDef(\term).colors.keys.choose;
				var fcol = ProtoDef(\term).colors.keys.choose;
				var ch = ["x", "|","-", "/"].choose;
				var pat = Prand([1,0,-1],inf).stutter(Pwhite(1,8));
				var pxstr = pat.asStream;
				var pystr = pat.asStream;
				var file = File("~/code/sc/seco/vlive/rise11/*".pathMatch.choose, "r");
				ProtoDef(\term).clearScreen;
				500.do {
					px = px+pxstr.next;
					py = py+pystr.next;
				
					ProtoDef(\term).moveTo(px, py);
					ProtoDef(\term).background_(col);
					ProtoDef(\term).foreground_(fcol);
					file.readUpTo($\n).postln;
					0.1.wait;
				}
			}
		}

	}).play;
)

(
	Tdef(\colorme, {
		14.do {
			fork {
				var px , py = rrand(1,30);
				var col = ProtoDef(\term).colors.keys.choose;
				var fcol = ProtoDef(\term).colors.keys.choose;
				var ch = ["x", "|","-", "/"].choose;
				var pat = Prand([1,0,-1],inf).stutter(Pwhite(1,8));
				var pxstr = pat.asStream;
				var pystr = pat.asStream;
				var file = File("~/code/sc/seco/vlive/rise11/*".pathMatch.choose, "r");
				var attr;
				px = [1,30,40].choose;
				ProtoDef(\term).clearScreen;
				ProtoDef(\term).background_(\default);
				attr = [\bold, \underscore, \bright, \standout, \blink, \reverse].choose;
				attr = \reset;
				500.do {
					var txt;
				

					10.do {
						py = ( py+1 mod: 40 ).next;
						ProtoDef(\term).moveTo(px, py);
						//ProtoDef(\term).background_(col);
						ProtoDef(\term).attribute_(attr);
						if(0.2.coin) {
							ProtoDef(\term).foreground_(fcol);
						};

						txt = file.readUpTo($\n);
						if(txt.notNil) {
							txt.keep(10).post;
						} {
							file.reset;
						};
					};
					0.1.wait;
				}
			}
		}

	}).play;
)
