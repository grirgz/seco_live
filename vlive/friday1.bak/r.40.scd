
(
	if( ~pattoggle == 0 ) {
		[\a, \z, \e  ].do { arg name;
			~patfx_off.(name+++\patfx, Pbind(\isRest, Pseq([true],inf)));
		};
		~spawnclips.([
			'a', \p,
			'z', \p,
			'e', \p,
			//'r', \p,
		]);
		~pattoggle = 1;
	} {
		[\a, \z, \e ].do { arg name;
			~patfx_on.(name+++\patfx, Pbind(\isRest, Pseq([true],inf)));
		};
		~pattoggle = 0;
	}
);
// END

(
[\a, \z, \e, \r ].do { arg name;
	~patfx_off.(name+++\patfx, Pbind(\isRest, Pseq([true],inf)));
}
)
