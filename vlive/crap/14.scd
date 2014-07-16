SCVim.updateCaches
SCVim.updateHelpCache


(
	Pbind(
		\instrument, \default,
		\freq, 1455,
		\dur, 1,
	).play
)

~midi.(\k1, 100, \freq.asSpec)

(
	Pbind(
		\instrument, \default,
		\freq, ~class_number_editor_gui.new_pattern(100),
		\dur, 1,
	).play
)

(

~class_number_editor_gui = (
	new: { arg self;
		self = self.deepCopy;
	
		
		self.spec = \freq.asSpec;
		self.current_val = 100;
	
		self;
	},

	new_pattern: { arg self, exit_function, val=0, spec=\freq;
		self = self.deepCopy;

		self.exit_function = { arg self, val; exit_function.(val) };
		self.spec = spec.asSpec;
		self.current_val = val;

		self.make_gui;
		Pfunc({ self.current_val });
		
	},

	make_gui: { arg self;
		var layout;
		self.window = Window.new;
		self.slider = Slider.new;
		layout = VLayout.new;
		self.slider.value = self.spec.unmap(self.current_val);
		self.slider.action = { arg slider;
			self.current_val = self.spec.map(slider.value)
		};
		self.window.onClose = self.window.onClose.addFunction({
			self.exit_function(self.spec.map(self.slider.value))
		});
		layout.add(self.slider);
		self.window.layout = layout;
		self.window.front;
	},

);
//~editor = ~class_number_editor_gui.new;
//~editor.make_gui;
//~class_number_editor_gui.new_pattern(100)

	

~inline_editor = { arg cmd, line, col, code;
	~class_inline_editor.compute_code(cmd, line, col, code);
};

~class_inline_editor = (
	compute_code: { arg self, cmd, start, end, line, col, code;
		self[(\edit_++cmd).asSymbol].(self, start, end, line, col, code);
	},

	vim_exec: { arg self, cmd;
		"vim --servername scvim --remote-send '<Esc>%<Enter>'".format(cmd).unixCmd;
	},

	replace_vim_block: { arg self, start, end, text;
		self.vim_exec("call SCreplaceTextBlock(%, %, %)".format(start, end, text.asCompileString))
	},

	edit_pbind_asso: { arg self, line, col, code;
		var key, val;
		#key, val = self.get_pbind_asso(line, code);
		code = self.replace_in_line(code, val, "150");
		
	},

	edit_number: { arg self, start, end, line, col, code;
		var dyn_code;
		~inline_editor_on_exit = { arg self, new_val;
			var res_code = self.replace_number(line, col, code, new_val);
			self.replace_vim_block(start, end, res_code);
		};
		dyn_code = self.replace_number(line, col, code, {arg x; "~class_number_editor_gui.new_pattern(~inline_editor_on_exit, "++ x ++")"});
		debug("CURRES("++code++")");
		code.interpret;
	},

	find_token_limit: { arg self, line, col, charlist, direction=\left;
		var char, pos;
		block { arg break;
			10000.do { arg x;
				if(direction == \left) {
					pos = col - x;
				} {
					pos = col + x;
				};
				if(pos == 0) {
					"left: not found".debug;
					break.value;
				};
				char = line[pos];
				char.debug("current char");
				if( charlist.includes(char) ) {
					char.debug("continue");
					// continue
				} {
					char.debug("found limit");
					break.value;
				}
			}
		};
		if(direction == \left) {
			pos+1;
		} {
			pos-1;
		}
	},

	get_current_number: { arg self, linenum, col, code;
		var line = self.get_line(linenum, code);
		var leftpos, rightpos;
		var charlist = "-.0123456789";

		leftpos = self.find_token_limit(line, col, charlist, \left);
		rightpos = self.find_token_limit(line, col, charlist, \right);
		line.copyRange(leftpos,rightpos);

	},

	replace_number: { arg self, linenum, col, code, replace;
		var lines = code.split($\n);
		var leftpos, rightpos;
		var charlist = "-.0123456789";
		var line;
		var token;
		
		line = lines[linenum];

		leftpos = self.find_token_limit(line, col, charlist, \left);
		rightpos = self.find_token_limit(line, col, charlist, \right);
		token = line.copyRange(leftpos,rightpos);
		line = line.replace(token, replace.(token));
		lines[linenum] = line;
		code = lines.join($\n);
		code;
	},

	get_line: { arg self, linenum, code;
		var lines = code.split($\n);
		lines[linenum]
	},

	get_pbind_asso: { arg self;
		
	},

);

)




~inline_editor = { arg cmd, line, col, code;
	"===".debug;
	[cmd, line, col, code].postcs;
	"===".debug;
	code.interpret;
	"--===".debug;
};
