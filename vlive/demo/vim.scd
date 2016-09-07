

// see "~/.local/share/SuperCollider/Extensions/seco/seco/veco/inline_editor.scd" 
(
~vim_exec = { arg cmd;
	"vim --servername scvim --remote-send '<Esc>%<Enter>'".format(cmd).unixCmd;
};
)

"vim --servername scvim --remote-send '<Esc>%<Enter>'".format("%:p").unixCmd;
~bla = "vim --servername scvim --remote-send '<Esc>%<Enter>'".format(":!echo %:p").unixCmdGetStdOut;
~bla
::
"vim --servername scvim --remote-send '<Esc>:call SendToSC(%)<Enter>'".format("%;%".asCompileString.format("~bli = %:p", Char.ff)).debug("CMF").unixCmd;
"vim --servername scvim --remote-send '<Esc>:call SendToSC(%)<Enter>'".format("%;%".asCompileString.format("~bli = 7474", Char.ff)).debug("CMF").unixCmd;
pas si simple, il faut retrouver mes fonctions vim pour remplacer %:p par le path
~bli
"vim --servername scvim --remote-expr %".format("%:p").unixCmd;

OCh
0x0c.acr
// put in clipboard

"xsel -ib <<EOD\n%\nEOD".format("blaa\nRRRRRRRaaaaaa").unixCmd


RandDelayNetwork(\default).make(\rdn1, "5--", BusDef(\sendbus1, \audio, 2));
RandDelayNetwork(\default).getPresetCompileString(\rdn1).pbcopy.vimpbpaste // defined in RandDelayNetwork.sc

// vimbppaste =	"vim --servername scvim --remote-send '<Esc>\"+P<Enter>'".unixCmd;
"ss".vimpbpaste



//====== Current path

(
thisProcess.nowExecutingPath  = "kjk";
thisProcess.nowExecutingPath.postln ;
)
thisProcess.class
Main
"echo '%' > /tmp/test.scd".format("thisProcess.nowExecutingPath.debug(\"PATH\");").unixCmd
"/tmp/test.scd".load

FileSystemProject.load("/home/ggz/code/sc/seco/vlive/demo/vim.scd")
FileSystemProject.load("/tmp/test.scd")
(
thisProcess.nowExecutingPath  = "kjk";
FileSystemProject.load("/tmp/test.scd");
thisProcess.nowExecutingPath.debug("end path");
)
FileSystemProject
