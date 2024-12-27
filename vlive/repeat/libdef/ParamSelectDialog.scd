
// moved to Param/Proto/misc/ParamSelectDialog.scd

/////////
// END


WindowDef(\ParamSelectDialog).front(nil, { arg param; param.debug("selected param") }, Param(Ndef(\bla), \pan))

WindowDef(\GlobalLibrary).front(ProtoDef(\GlobalLibrary))

WindowDef(\ParamSelectDialog).clear


TagSpecDef(\GlobalLibraryCategory).keyList.includes(\ParamGroup)



