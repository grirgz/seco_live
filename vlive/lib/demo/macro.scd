
Sdef(~name, \mymacro, \macro, 8);
Sdef(~name, \mymacro).pbind
Sdef(~name, \mymacro).pbind(\wet)
Sdef(~name, \mymacro).connect(1, Sdef(~name, \mypreset), \ffreq, \freq.asSpec)
Sdef(~name, \mymacro).modulate(1, Sdef(~name, \mypreset), \ffreq, \freq.asSpec, { arg val, macro; val + macro })
Sdef(~name, \mymacro).padd(2, Ndef(~name+++\fx), \wet, \freq.asSpec, { arg val, macro; val + macro })

Sdef(~name, \mymacro).map(2, Ndef(~name+++\fx), \wet, \freq.asSpec, { arg val, macro; val + macro })

///// sources
// - gui
// - midi
// - ndef
// - pattern
// - osc
// - hid

///// dest
// - pattern preset
// - ndef
// - env var
// - dictionnary key
// - bus
// - synth/group node

~cont.map(1, 3, Ndef(~name+++\fx), \wet)
