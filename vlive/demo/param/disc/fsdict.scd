
FileSystemProjectDictionary(\myclass)["proto1/bla"] = "iihello"
FileSystemProjectDictionary(\myclass)["proto1/bla"].dump
FileSystemProjectDictionary(\myclass).saveAt("proto1/bla")
FileSystemProjectDictionary(\myclass).loadAt("proto1/bla")
FileSystemProjectDictionary(\myclass)
FileSystemProjectDictionary(\myclass)["bla"].dump
FileSystemProjectDictionary(\myclass)["./bla"].dump
FileSystemProjectDictionary(\myclass)["bla"] = "bye"
FileSystemProject.cwd
PathName("").isFile
PathName(" ").isAbsolutePath


// pseudocode

~myclass = ProtoClass((
	all: { FileSystemProjectDictionary('MyClass') }
	new: { arg self, key;
		self = self.deepCopy;
	
		if(self.all[key].notNil)
	
		self;
	},

));

~myclass.new('./proto1')

ParamProto.bla = 4

FileSystemProjectDictionary {

	at { arg key;
		#path, project = this.resolve(key);
		if(already_loaded) {
			^current
		} {
			if(exist) {
				^read_and_load(path + datapath)
			} {
				^nil
			}
		}
		

	}

	keys

	dataPath {
		path.

	}


}
