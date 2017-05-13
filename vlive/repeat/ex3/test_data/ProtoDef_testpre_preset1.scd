PlayerWrapper(ProtoDef('testpre_preset1')).presetCompileStringSavePath = "ex3/test_data/ProtoDef_testpre_preset1.scd";

ProtoDef('testpre_preset1').preset = StepEvent.newFrom((amp: 0.1, fmf1: 2.0, fmf2: 0.5, freq: 200, pan: 0));