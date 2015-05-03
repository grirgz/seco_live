

~midi_macro_manager.map_node_morphers_to_knobs
~list = ~veco_sendpad.get_send_screen_param;
~list.do(_.postln);
~pg = ParamGroup(~list)
~pg.save(\p1)
~pg.save(\p2)

~pg.load(\p1)
~pg.load(\p2)
~pg.edit
~pm = ParamMorpher(~pg, [\p1, \p2]);
MIDIMap(\c1, { MIDIMap(\k9, ~pm); });
MIDIMap(\c2, { MIDIMap(\k9, ~pm); });
~pm

~pg.presets[\p1]

ParamGroup(~veco_sendpad.get_send_column_param('stone8-1')).edit

~fxg = ParamGroup(~veco_sendpad.get_send_screen_param);
~fxg.save(\p1)
~fxg.save(\p2)
~fxg.do(_.postln)

~fxpm = ParamMorpher(~fxg, [\p1, \p2]);
~fxpm.optimizeMorphing; ~fxpm.optimizedPresets
MIDIMap(\k9, ~fxpm)
MIDIMap(\c2, { MIDIMap(\k9, ~fxpm); });

~send_view = ~class_send_view.new;
)

