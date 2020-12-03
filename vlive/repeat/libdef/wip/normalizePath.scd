
(
	~normalizePath = { arg path, stripTrailing;
		var ret;
		var len;
		var segs;
		var prefix = "";
		ret = if (path == "\\" or: { path == "/"}) { "/" };
		ret ?? {
			len = path.size;
			ret = if (len <= 1) { path };

			ret ?? {
				if (len > 4 and:{  path[3] == "\\" }) {
					var ch = path[2];
					if ((ch == $? or:{  ch == $. }) and:{  path.keep(2) == "\\\\" }) {
						path = path[2..];
						prefix = "//";
					}
				};

				path.debug("path");
				segs = path.split($/);
				segs.debug("segs");
				//if(segs[0].postcs == "") {
					//segs = segs.drop(1)
				//};
				//segs.debug("segs");
				if (stripTrailing != false and: { segs[segs.size - 1] == ""}) {
					segs.pop();
				};
				ret = prefix + segs.join("/");
				if(ret[0] == $ ) {
					ret = ret.drop(1)
				};
				//segs.debug("segs");
			}
		};
		ret;
	};
	~dotest.();
)

(
	///// working! !!! from python normpath
	~normalizePath = { arg path;
		var ret;
		var sep = $/, empty = "", dot = ".", dotdot = "..";
		var initial_slashes = 0;
		var comps, new_comps;
		ret = if ( path == empty ){ empty };
		ret ?? {

			initial_slashes = path.beginsWith(sep.asString);
			// POSIX allows one or two initial slashes, but treats three or more
			// as single slash.
			if (
				initial_slashes 
				and: { path.beginsWith("//") and: { path.beginsWith("///").not } }
			) { 
				initial_slashes = 1; // no double!
			};
			initial_slashes = initial_slashes.asInteger;
			comps = path.split(sep);
			//[path, comps].asCompileString.debug("com");
			//initial_slashes.debug("initial_slashes");
			new_comps = List.new;
			comps.do { arg comp;
				block { arg break;
					if ( [empty, dot].includesEqual(comp) ) {
						break.value;
					};
					//[ comp != dotdot,  ]
					if (
						comp != dotdot 
						or: { ( initial_slashes == 0 and: { new_comps.size == 0 } ) 
						or: { new_comps.size > 0 and: { new_comps.last == dotdot }}}
					) {
						//[new_comps, comp].debug("add");
						new_comps.add(comp);
					} {
						if ( new_comps.size > 0 ) {
							//[new_comps, comp].debug("remove");
							new_comps.pop
						}
					};
				}
			};
			//[comps, new_comps].asCompileString.debug("com, nc");
			comps = new_comps;
			if(comps.last == dotdot) {
				comps[comps.size-1] = comps.last ++ sep
			};
			path = comps.join(sep);
			if ( initial_slashes > 0 ) {
				path = sep.dup(initial_slashes).join ++ path
			};
			ret = if(path.size > 0) {
				path
			} {
				dot ++ "/";
			};
		};
		ret;
	};
	//~normalizePath.("../bla");
	//~normalizePath.("////../abc/def");
	//~normalizePath.("./").asCompileString;
	~dotest.();
)


///// tests

(
	~dotest = {
		var data =   [
			[ "", "" ],
			[ "/..", "/" ],
			[ "/../", "/" ],
			[ ".", "./" ],
			[ "./", "./" ],
			[ "..", "../" ],
			[ "../", "../" ],
			[ "../abc/def", "../abc/def" ],
			[ "../abc/def/..", "../abc/" ],
			[ "../abc/././././def/..", "../abc/" ],
			[ "////../abc/def", "/abc/def" ],
			[ "/../def", "/def" ],
			[ "../def", "../def" ],
			[ "/abc////../def", "/def" ],
			[ "abc/../def/ghi", "def/ghi" ],
			[ "/abc/def/../ghi", "/abc/ghi" ],
			[ "/abc/..abc////../def", "/abc/def" ],
			[ "/abc/..abc/../def", "/abc/def" ],
			[ "abc/../def", "def" ],
			[ "abc/../../def", "../def" ],
			[ "././", "./" ],
			[ "abc/..", "./" ],
			[ "abc/../", "./" ],
			[ "abc/../..", "../" ],
			[ "abc/../../", "../" ],
			[ "a/..", "./" ],
			[ "a/../", "./" ],
			[ "a/../..", "../" ],
			[ "a/../../", "../" ],
			[ "../../../a", "../../../a" ],
			[ "../a../../a", "../a" ],
			[ "cccc/abc////..////.//../", "./" ],
			[ "aaaa/cccc/abc////..////.//../", "aaaa/" ],
			[ "..//////.///..////..////.//////abc////.////..////def//abc/..", "../../../def/" ],
			[ "////////////..//////.///..////..////.//////abc////.////..////def//abc/..", "/def/" ],
		];
		data.do({ arg arr;
			var test = ~normalizePath.(arr[0]) == arr[1];
			debug("passed: %. In: %. Out: %. Should be: %".format(test, arr[0].asCompileString, ~normalizePath.(arr[0]).asCompileString, arr[1].asCompileString));
			test;
		}).debug("test passed")
	};
	~dotest.value;
)
