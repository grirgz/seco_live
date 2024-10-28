~t = 200/4/60; TempoClock.default.tempo = ~t;

// from fmgen.scd and sun45
(
	~sdbank = 10.collect { arg item, idx;
		~fmgen_ambientchords.(88595.rand,rrand(2,15))
	};
)
FileSystemProject.load("sun/fmgen.scd");
(
NoteTimeline('endmelo').param = Param(Pdef('endmelo'), 'midinote');
NoteTimeline('endmelo').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 0.5, \instrument: 'fmgen_short_v198921n10', \label: 'start', \playDur: 0.5, \relDur: 0.5, \sustain: 0, \type: 'start', ),
	(\absTime: 0.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13960.680775708, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.22234222416591, ),
	(\absTime: 0.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13960.908377477, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.18363383749784, ),
	(\absTime: 1.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13961.680007472, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.24232710166689, ),
	(\absTime: 1.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13961.905527288, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.21332652417004, ),
	(\absTime: 2.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13962.682423394, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.24395948833262, ),
	(\absTime: 2.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13962.92013655, \dur: 0.5, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.5, \relDur: 0.5, \sustain: 0.14772297083255, ),
	(\absTime: 3.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13963.40929792, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 95, \midinote: 95, \playDur: 0.25, \relDur: 0.25, \sustain: 0.19840713583471, ),
	(\absTime: 3.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13963.664513439, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.22105795750031, ),
	(\absTime: 3.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13963.866338544, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.20330253916654, ),
	(\absTime: 4.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13964.674712709, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.24025830416576, ),
	(\absTime: 4.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13964.888015846, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.22619960000156, ),
	(\absTime: 5.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13965.650201247, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.24829628666885, ),
	(\absTime: 5.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13965.867285926, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.17689639666787, ),
	(\absTime: 6.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13966.671125041, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 95, \midinote: 95, \playDur: 0.25, \relDur: 0.25, \sustain: 0.20378933666871, ),
	(\absTime: 6.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13966.898180442, \dur: 0.5, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.5, \relDur: 0.5, \sustain: 0.13080518999959, ),
	(\absTime: 7.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13967.412887462, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.25, \relDur: 0.25, \sustain: 0.19972695666729, ),
	(\absTime: 7.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13967.663648575, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.21254357916405, ),
	(\absTime: 7.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13967.896925607, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.16304561749712, ),
	(\absTime: 8.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13968.680884493, \dur: 1.0, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 1.0, \relDur: 1.0, \sustain: 0.21652145500047, ),
	(\absTime: 9.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13969.661751391, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.24520034749912, ),
	(\absTime: 9.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13969.869329187, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.16367571166484, ),
	(\absTime: 10.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13970.706635939, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.75, \relDur: 0.75, \sustain: 0.15924508749777, ),
	(\absTime: 11.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13971.393906959, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 95, \midinote: 95, \playDur: 0.25, \relDur: 0.25, \sustain: 0.22415756749979, ),
	(\absTime: 11.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13971.654352022, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.17654934499842, ),
	(\absTime: 11.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13971.884475039, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.16709549166626, ),
	(\absTime: 12.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13972.68896326, \dur: 1.0, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 1.0, \relDur: 1.0, \sustain: 0.15523047749957, ),
	(\absTime: 13.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13973.685183397, \dur: 1.0, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 1.0, \relDur: 1.0, \sustain: 0.12896919083323, ),
	(\absTime: 14.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13974.659616914, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1855390891651, ),
	(\absTime: 14.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13974.882071889, \dur: 0.5, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.5, \relDur: 0.5, \sustain: 0.16044204333411, ),
	(\absTime: 15.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13975.424415274, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 95, \midinote: 95, \playDur: 0.25, \relDur: 0.25, \sustain: 0.18110766666723, ),
	(\absTime: 15.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13975.647593386, \dur: 1.0, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 1.0, \relDur: 1.0, \sustain: 0.16040164666811, ),
	(\absTime: 16.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13976.644506119, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.23142083333369, ),
	(\absTime: 16.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13976.878485837, \dur: 0.5, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.5, \relDur: 0.5, \sustain: 0.15983862916619, ),
	(\absTime: 17.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13977.423435126, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.25, \relDur: 0.25, \sustain: 0.18823241250175, ),
	(\absTime: 17.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13977.665188039, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.75, \relDur: 0.75, \sustain: 0.14440219749849, ),
	(\absTime: 18.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13978.418179081, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 95, \midinote: 95, \playDur: 0.25, \relDur: 0.25, \sustain: 0.19391674333383, ),
	(\absTime: 18.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13978.659952949, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.75, \relDur: 0.75, \sustain: 0.17782074749812, ),
	(\absTime: 19.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13979.394349266, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.25, \relDur: 0.25, \sustain: 0.2028458525001, ),
	(\absTime: 19.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13979.654958053, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.39397605083286, ),
	(\absTime: 19.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13979.950992549, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.22826949500086, ),
	(\absTime: 20.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13980.703575504, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.22342453833153, ),
	(\absTime: 20.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13980.929731052, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.1810969183316, ),
	(\absTime: 21.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13981.686602014, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.19452424500014, ),
	(\absTime: 21.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13981.909529776, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.16886369833264, ),
	(\absTime: 22.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13982.676653644, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.29368780500045, ),
	(\absTime: 22.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13982.918425804, \dur: 0.5, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.5, \relDur: 0.5, \sustain: 0.17407276499944, ),
	(\absTime: 23.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13983.409356534, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 95, \midinote: 95, \playDur: 0.25, \relDur: 0.25, \sustain: 0.20422689916813, ),
	(\absTime: 23.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13983.642716285, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.21904314833228, ),
	(\absTime: 23.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13983.870264879, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.19418716666769, ),
	(\absTime: 24.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13984.680029458, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.75, \relDur: 0.75, \sustain: 0.19058940250034, ),
	(\absTime: 25.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13985.364541773, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.25, \relDur: 0.25, \sustain: 0.20167937583574, ),
	(\absTime: 25.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13985.631397854, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.18638283916516, ),
	(\absTime: 25.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13985.859627298, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.17596557166326, ),
	(\absTime: 26.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13986.636473886, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.75, \relDur: 0.75, \sustain: 0.25824554916653, ),
	(\absTime: 27.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13987.42485163, \dur: 0.5, \instrument: 'fmgen_short_v198921n10', \kitIndex: 95, \midinote: 95, \playDur: 0.5, \relDur: 0.5, \sustain: 0.22414090250095, ),
	(\absTime: 27.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13987.90799317, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.75, \relDur: 0.75, \sustain: 0.1791255266653, ),
	(\absTime: 28.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13988.63902997, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.28692870416671, ),
	(\absTime: 28.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13988.869696725, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.20176613500189, ),
	(\absTime: 29.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13989.651115328, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.18747775333395, ),
	(\absTime: 29.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13989.884498943, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.17716431666486, ),
	(\absTime: 30.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13990.635511443, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.29067066916832, ),
	(\absTime: 30.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13990.864993629, \dur: 0.5, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.5, \relDur: 0.5, \sustain: 0.18874882417003, ),
	(\absTime: 31.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13991.393428714, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.20026770333243, ),
	(\absTime: 31.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13991.629955005, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.25, \relDur: 0.25, \sustain: 0.20931940833179, ),
	(\absTime: 31.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13991.896742014, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.75, \relDur: 0.75, \sustain: 0.1708225825023, ),
	(\absTime: 32.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13992.655516119, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 95, \midinote: 95, \playDur: 0.25, \relDur: 0.25, \sustain: 0.21908694500235, ),
	(\absTime: 32.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13992.903322697, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.75, \relDur: 0.75, \sustain: 0.1615470708366, ),
	(\absTime: 33.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13993.663157839, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 95, \midinote: 95, \playDur: 0.25, \relDur: 0.25, \sustain: 0.2132472175017, ),
	(\absTime: 33.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13993.9209731, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.75, \relDur: 0.75, \sustain: 0.16627755416448, ),
	(\absTime: 34.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13994.673239562, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.25, \relDur: 0.25, \sustain: 0.20117476499763, ),
	(\absTime: 34.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13994.938843761, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.75, \relDur: 0.75, \sustain: 0.14498770666432, ),
	(\absTime: 35.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13995.683411315, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.22486606500024, ),
	(\absTime: 35.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13995.911447959, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.18893357916568, ),
	(\absTime: 36.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13996.692306839, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 95, \midinote: 95, \playDur: 0.25, \relDur: 0.25, \sustain: 0.21773500416566, ),
	(\absTime: 36.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13996.946955081, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.16611979249865, ),
	(\absTime: 37.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13997.717871699, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.19456855166754, ),
	(\absTime: 37.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13997.995701864, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.75, \relDur: 0.75, \sustain: 0.18102505749994, ),
	(\absTime: 38.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13998.719600637, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.23001521333208, ),
	(\absTime: 38.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13998.972911328, \dur: 0.5, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.5, \relDur: 0.5, \sustain: 0.15278002083323, ),
	(\absTime: 39.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13999.443281842, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.18558162166664, ),
	(\absTime: 39.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13999.679955275, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.25, \relDur: 0.25, \sustain: 0.16677105083545, ),
	(\absTime: 39.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 13999.926141498, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.75, \relDur: 0.75, \sustain: 0.14236521750172, ),
	(\absTime: 40.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14000.683562915, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 95, \midinote: 95, \playDur: 0.25, \relDur: 0.25, \sustain: 0.16373667250082, ),
	(\absTime: 40.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14000.928579317, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.75, \relDur: 0.75, \sustain: 0.15520289250162, ),
	(\absTime: 41.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14001.67208559, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.25, \relDur: 0.25, \sustain: 0.2039905916663, ),
	(\absTime: 41.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14001.907727333, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.75, \relDur: 0.75, \sustain: 0.1592317791692, ),
	(\absTime: 42.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14002.644705671, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.23669520666772, ),
	(\absTime: 42.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14002.905760879, \dur: 0.5, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.5, \relDur: 0.5, \sustain: 0.13718079750106, ),
	(\absTime: 43.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14003.395875483, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 95, \midinote: 95, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1875137508323, ),
	(\absTime: 43.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14003.631837077, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.16564905250016, ),
	(\absTime: 43.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14003.854982159, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.19917001166505, ),
	(\absTime: 44.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14004.642015035, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.2294537050002, ),
	(\absTime: 44.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14004.886371574, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.17913312083328, ),
	(\absTime: 45.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14005.659934121, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.30580291249862, ),
	(\absTime: 45.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14005.895801953, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.14824937583217, ),
	(\absTime: 46.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14006.652024969, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.2473625149978, ),
	(\absTime: 46.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14006.907277067, \dur: 0.5, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.5, \relDur: 0.5, \sustain: 0.15274462666639, ),
	(\absTime: 47.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14007.41362879, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 95, \midinote: 95, \playDur: 0.25, \relDur: 0.25, \sustain: 0.14764187000219, ),
	(\absTime: 47.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14007.631003649, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.15075461750166, ),
	(\absTime: 47.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14007.850147719, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.20506178999858, ),
	(\absTime: 48.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14008.652669901, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.22751438083469, ),
	(\absTime: 48.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14008.896554913, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.20675364166527, ),
	(\absTime: 49.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14009.65249769, \dur: 1.0, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 1.0, \relDur: 1.0, \sustain: 0.18685215999722, ),
	(\absTime: 50.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14010.618518763, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.25, \relDur: 0.25, \sustain: 0.19526385083373, ),
	(\absTime: 50.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14010.837136357, \dur: 0.5, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.5, \relDur: 0.5, \sustain: 0.24293391750143, ),
	(\absTime: 51.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14011.394987256, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.18756070749987, ),
	(\absTime: 51.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14011.6303692, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.25, \relDur: 0.25, \sustain: 0.17129080000086, ),
	(\absTime: 51.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14011.864968151, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.75, \relDur: 0.75, \sustain: 0.18289601750075, ),
	(\absTime: 52.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14012.601163144, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.25, \relDur: 0.25, \sustain: 0.18876027916667, ),
	(\absTime: 52.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14012.829133888, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.75, \relDur: 0.75, \sustain: 0.20257165583098, ),
	(\absTime: 53.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14013.601635129, \dur: 1.0, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 1.0, \relDur: 1.0, \sustain: 0.18886169000143, ),
	(\absTime: 54.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14014.589629574, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.75, \relDur: 0.75, \sustain: 0.1893963675011, ),
	(\absTime: 55.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14015.351515546, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.25, \relDur: 0.25, \sustain: 0.20811575333209, ),
	(\absTime: 55.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14015.597814652, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.32692031416809, ),
	(\absTime: 55.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14015.826570011, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.23882889083325, ),
	(\absTime: 56.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14016.61823472, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 95, \midinote: 95, \playDur: 0.25, \relDur: 0.25, \sustain: 0.19137719500031, ),
	(\absTime: 56.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14016.853510927, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.75, \relDur: 0.75, \sustain: 0.17783239333585, ),
	(\absTime: 57.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14017.616920837, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.22988771249948, ),
	(\absTime: 57.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14017.858508148, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.16786284916634, ),
	(\absTime: 58.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14018.653855141, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.21848635916467, ),
	(\absTime: 58.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14018.885955666, \dur: 0.5, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.5, \relDur: 0.5, \sustain: 0.16371409083149, ),
	(\absTime: 59.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14019.408947838, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 95, \midinote: 95, \playDur: 0.25, \relDur: 0.25, \sustain: 0.19862075833225, ),
	(\absTime: 59.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14019.636075266, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.17456783916532, ),
	(\absTime: 59.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14019.865550902, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.18298226750085, ),
	(\absTime: 60.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14020.643655413, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.327373551665, ),
	(\absTime: 60.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14020.870423473, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.19533003166543, ),
	(\absTime: 61.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14021.621541094, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 95, \midinote: 95, \playDur: 0.25, \relDur: 0.25, \sustain: 0.20752192583313, ),
	(\absTime: 61.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14021.849855622, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.75, \relDur: 0.75, \sustain: 0.17462977750074, ),
	(\absTime: 62.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14022.594110734, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.22194369583303, ),
	(\absTime: 62.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14022.854831569, \dur: 0.5, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.5, \relDur: 0.5, \sustain: 0.17010005583506, ),
	(\absTime: 63.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14023.357671117, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.3470833766678, ),
	(\absTime: 63.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14023.580316138, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.25, \relDur: 0.25, \sustain: 0.19529338583197, ),
	(\absTime: 63.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14023.856211616, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.14245788416702, ),
	(\absTime: 64.0, \dur: 0.5, \instrument: 'fmgen_short_v198921n10', \label: 'end', \playDur: 0.5, \relDur: 0.5, \type: 'end', ),
	(\absTime: 64.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14024.629849094, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 88, \midinote: 88, \playDur: 0.25, \relDur: 0.25, \sustain: 0.26047199749883, ),
	(\absTime: 64.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14024.884361798, \dur: 0.75, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0.75, \relDur: 0.75, \sustain: 0.1625014149995, ),
	(\absTime: 65.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14025.612969501, \dur: 0.25, \instrument: 'fmgen_short_v198921n10', \kitIndex: 93, \midinote: 93, \playDur: 0.25, \relDur: 0.25, \sustain: 0.17588566916675, ),
	(\absTime: 65.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 1.1 ], -4.0, 2) ], \amp: 0.05, \clockTime: 14025.854730188, \dur: 0, \instrument: 'fmgen_short_v198921n10', \kitIndex: 91, \midinote: 91, \playDur: 0, \relDur: 0, \sustain: 0.17262982666762, ),
]);
);



(
Pdef(\endmelo, 
	Pbind(
		\instrument, ~fmgen_short.(198921).name,
		\amp, 0.1/2,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,1.1) ],
		],inf),
	)
)
);

///////////////////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Prout({ arg ev;
			var str;
			var sdbank = ~sdbank;
			str = Pseq([
				[0,4,7,9],
				[-1,2,6,9],
			],inf).do { arg chord, idx;
				ev = Ppar(chord.collect { arg note, idx;
					Pbind(
						\instrument, sdbank.choose,
						\note, note,
						\lpfr, ~pmodenv.(Pseq([1/2,4],1), 4, -1).loop,
						\octave, 5,
						\legato, 1,
						\dur, Pconst(4,[1,1/2,1/3,2,4,1/4,1/5].choose),
						\adsr, Pseq([
							[ Env.adsr(0.1,0.1,0.8,0.1,1,3) ],
						],inf),
						\amp, 0.1/4,
					)
				}).embedInStream(ev);
			};
		}),
		Ptpar([
			8, Pbind(
			   	\instrument, ~fmgen_short.(198921),
			   	\note, Pseq([
			   		0,2,
			   	],inf),
			   	\dur, 1,
			   	\octave, 7,
			   	\amp, 0.1/8,
			   ),
			16,   
			Pbind(
				\instrument, Pseq([
					~fmgen_short.(198921),
					~fmgen_short.(198927),
					~fmgen_short.(198926),
				],inf),
				\amp, 0.1/8,
			)<>
			NoteTimeline(\endmelo).asPattern,

		])
		
	])
)).play;
);

NoteTimeline(\endmelo, Pdef(\endmelo)).edit
NoteTimeline(\endmelo).presetCompileString.editorInsert

(
Pdef(\endmelo2, 
	Pbind(
		\instrument, ~fmgen_short.(191937).name,
		\amp, 0.1/2,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,1.1) ],
		],inf),
	)
)
);

ProtoDef(\piano).startControl(Pdef(\endmelo2))
