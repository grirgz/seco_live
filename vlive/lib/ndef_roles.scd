
(
	~qsetsrc = { arg source;
		{ arg pattern, proxy, channelOffset=0, index;
			pattern.collect { |event|
				var quant;
				event[\type] = \rest;
				quant = proxy.quant;
				[proxy.key, index, proxy.isPlaying].debug("proxy is playing ==========");
				if(proxy.isPlaying) {
					proxy.quant = nil;
					proxy.put(index + 1, source.value(event[\source]));
					proxy.quant = quant;
					event;
				} {
					[proxy.key, index].debug("returning nil");
					nil;
				};
			}.buildForProxy( proxy, channelOffset, index );
		}

	};
AbstractPlayControl.proxyControlClasses.put(\qsetsrc, StreamControl);
AbstractPlayControl.buildMethods.put(\qsetsrc,
	~qsetsrc.({ arg x; x; });
);

AbstractPlayControl.proxyControlClasses.put(\setsrcfx, StreamControl);
AbstractPlayControl.buildMethods.put(\setsrcfx,
	~qsetsrc.({ arg x; \filter -> x; });
);

);


(

AbstractPlayControl.proxyControlClasses.put(\mysetsrc, StreamControl);
AbstractPlayControl.buildMethods.put(\mysetsrc,
    #{ arg pattern, proxy, channelOffset=0, index;
		pattern.collect { |event|
			event[\type] = \rest;
			// loop in event[\source] if there is \filter ->
			[proxy.key, index, event[\source]].debug("mysetsrc running");
			proxy.put(index + 1, event[\source]);
			event
		}.buildForProxy( proxy, channelOffset, index );
	}
);

AbstractPlayControl.proxyControlClasses.put(\mysetsrcfx, StreamControl);
AbstractPlayControl.buildMethods.put(\mysetsrcfx,
    #{ arg pattern, proxy, channelOffset=0, index;
		pattern.collect { |event|
			event[\type] = \rest;
			// loop in event[\source] if there is \filter ->
			[proxy.key, index, event[\source]].debug("mysetsrc running");
			proxy.put(index + 1, \filter -> event[\source]);
			event
		}.buildForProxy( proxy, channelOffset, index );
	}
)

)

Ndef(\bla).key


(
AbstractPlayControl.proxyControlClasses.put(\qsetsrc, PatternControl);
AbstractPlayControl.buildMethods.put(\qsetsrc,
    #{ arg pattern, proxy, channelOffset=0, index;
		pattern.collect { |event|
			var quant;
			event[\type] = \rest;
			quant = proxy.quant;
			proxy.quant = nil;
			proxy.isPlaying.debug("proxy is playing ==========");
			if(proxy.isPlaying) {
				proxy.put(index + 1, event[\source]);
			};
			proxy.quant = quant;
			event;
		}.buildForProxy( proxy, channelOffset, index );
	}
);

AbstractPlayControl.proxyControlClasses.put(\setsrcfx, PatternControl);
AbstractPlayControl.buildMethods.put(\setsrcfx,
    #{ arg pattern, proxy, channelOffset=0, index;
		pattern.collect { |event|
			var quant;
			event[\type] = \rest;
			quant = proxy.quant;
			proxy.quant = nil;
			proxy.isPlaying.debug("fx proxy is playing ==========");
			if(proxy.isPlaying) {
				proxy.put(index + 1, \filter -> event[\source]);
			};
			proxy.quant = quant;
			event;
		}.buildForProxy( proxy, channelOffset, index );
	}
);

);
