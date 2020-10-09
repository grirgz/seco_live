
// from vlive/lib/main.scd


(
~pEnv = { arg ... args;
	Ptuple( Env(*args).asArray ).collect{ arg x; [x] }
};
~pEnvadsr = { arg ... args;
	Ptuple( Env.adsr(*args).asArray ).collect{ arg x; [x] }
};
)
