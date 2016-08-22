
// see "~/.local/share/SuperCollider/Extensions/seco/seco/veco/inline_editor.scd" 
(
~vim_exec = { arg cmd;
	"vim --servername scvim --remote-send '<Esc>%<Enter>'".format(cmd).unixCmd;
};
)

// put in clipboard

"xsel -ib <<EOD\n%\nEOD".format("blaa\nRRRRRRRaaaaaa").unixCmd


RandDelayNetwork(\default).make(\rdn1, "5--", BusDef(\sendbus1, \audio, 2));
RandDelayNetwork(\default).getPresetCompileString(\rdn1).pbcopy.vimpbpaste // defined in RandDelayNetwork.sc

// vimbppaste =	"vim --servername scvim --remote-send '<Esc>\"+P<Enter>'".unixCmd;
"ss".vimpbpaste
