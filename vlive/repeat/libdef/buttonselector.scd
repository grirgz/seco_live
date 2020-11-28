(

ProtoDef(\ButtonSelector, (
	hiligthColor: ParamViewToolBox.color_dark,
	offColor: Color.white,

	new: { arg self, action;
		self = self.deepCopy;
	
		self.selectedAction = action;
	
		self;
	},
	
	list: { arg self;
		self[\_list] = self[\_list] ?? {List.new};
		self[\_list];
	},

	updateButton: { arg self, idx;
		if(idx.notNil) {
			if(self.selectedIndex == idx) {
				self.list[idx].background = self.hiligthColor;
			} {
				self.list[idx].background = self.offColor;
			}
		}
	},

	selectButton: { arg self, idx;
		self.deselectedIndex = self.selectedIndex;
		self.selectedIndex = idx;
		self.updateButton(self.selectedIndex);
		self.updateButton(self.deselectedIndex);
		self.selectedAction(idx)
	},

	makeButton: { arg self;
		var but = BasicButton.new;
		var idx = self.list.size;
		self.list.add(but);
		but.action = { 
			self.selectButton(idx)
		};
		self.updateButton(idx);
		but;
	},
))
)

// END

