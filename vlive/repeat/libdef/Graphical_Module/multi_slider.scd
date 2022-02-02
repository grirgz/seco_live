(
{ arg
	sliderColor = ~gm.at( \mainColor ),
	borderColor = ~gm.at( \borderColor ),
	backgroundColor = ~gm.at( \backgroundColor ),
	borderSize = ~gm.at( \borderSize ),
	orientation = \horizontal,
	isFading = true,
	sliderWidthRatio = 0.75,
	growthType = \lin,
	minVal = 0,
	maxVal = 1,
	values = [ 0.8, 0.7, 0.6, 0.55, 0.5, 0.45, 0.4, 0.35 ];

	var view = UserView();

	view.drawFunc = { | view |

		var sliderPos;
		var caseSize;

		if( orientation == \horizontal, {
			caseSize = view.bounds.width - ( borderSize * 2 ) / values.size
		}, {
			caseSize = view.bounds.height - ( borderSize * 2 ) / values.size
		} );

		Pen.fillColor_( backgroundColor );
		Pen.fillRect(
			Rect(
				0,
				0,
				view.bounds.width,
				view.bounds.height
			)
		);


		values.do( { | value, index |

			if( orientation == \vertical, {
				if( growthType == \lin, {
					sliderPos = value.linlin(
						minVal, maxVal, borderSize,
						view.bounds.width - borderSize )
				}, {
					sliderPos = value.explin(
						minVal, maxVal, borderSize,
						view.bounds.width - borderSize )
				} );
			}, {
				if( growthType == \lin, {
					sliderPos = value.linlin(
						minVal, maxVal,
						view.bounds.height - borderSize, borderSize )
				}, {
					sliderPos = value.explin(
						minVal, maxVal,
						view.bounds.height - borderSize, borderSize )
				} );
			} );

			if( isFading, {

				var alpha;

				if( growthType == \lin, {
					alpha = value.linlin( minVal, maxVal, 0, 1 )
				}, {
					alpha = value.explin( minVal, maxVal, 0, 1 )
				} );

				Pen.fillColor_(
					Color(
						sliderColor.red,
						sliderColor.green,
						sliderColor.blue,
						alpha
					)
				)
			}, {
				Pen.fillColor_( sliderColor )
			} );

			if( orientation == \vertical, {
				Pen.fillRect(
					Rect(
						0,
						borderSize + ( caseSize * index ) + ( caseSize * ( 1 - sliderWidthRatio / 2 ) ),
						sliderPos,
						caseSize * sliderWidthRatio
					)
				)
			}, {
				Pen.fillRect(
					Rect(
						borderSize + ( caseSize * index ) + ( caseSize * ( 1 - sliderWidthRatio / 2 ) ),
						sliderPos,
						caseSize * sliderWidthRatio,
						view.bounds.height - sliderPos
					)
				)
			} );
		} );

		// Draw the border on top
		Pen.fillColor_( borderColor );
		Pen.fillRect(
			Rect(
				0,
				0,
				borderSize,
				view.bounds.height
			)
		);

		Pen.fillRect(
			Rect(
				0,
				0,
				view.bounds.width,
				borderSize
			)
		);

		Pen.fillRect(
			Rect(
				view.bounds.width - borderSize,
				0,
				borderSize,
				view.bounds.height
			)
		);

		Pen.fillRect(
			Rect(
				0,
				view.bounds.height - borderSize,
				view.bounds.width,
				borderSize
			)
		);
	}; // End of drawFunc

	// Methods
	view.addUniqueMethod( \setSliderColor, { | self, newColor | sliderColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBorderColor, { | self, newColor | borderColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBackgroundColor, { | self, newColor | backgroundColor = newColor; view.refresh } );
	view.addUniqueMethod( \setBorderSize, { | self, newSize | borderSize = newSize; view.refresh } );
	view.addUniqueMethod( \setSliderWidthRatio, { | self, newSize | sliderWidthRatio = newSize; view.refresh } );
	view.addUniqueMethod( \setFading, { | self, bool | isFading = bool; view.refresh } );
	view.addUniqueMethod( \setMin, { | self, newValue |
		minVal = newValue;
		values.do( { | value, index | if( value < minVal, { values[ index ] = minVal } ) } );
		if( maxVal < minVal, { maxVal = minVal } );
		view.refresh } );
	view.addUniqueMethod( \setMax, { | self, newValue |
		maxVal = newValue;
		values.do( { | value, index | if( value > maxVal, { values[ index ] = maxVal } ) } );
		if( minVal > maxVal, { minVal = maxVal } );
		view.refresh } );
	view.addUniqueMethod( \setValues, { | self, newValues |
		values = newValues;
		values.do( { | value, index |
			if( value < minVal, { values[ index ] = minVal } );
			if( value > maxVal, { values[ index ] = maxVal } );
		} );
		view.refresh } );
	view.addUniqueMethod( \setGrowthType, { | self, newType |
		growthType = newType;
		if( (growthType != \lin )&&( growthType != \exp ), {
			growthType = \lin } );
		if( growthType == \exp, {
			if( minVal == 0, {
				view.setMin( 1 )
			} )
		} )
	} );
	view.addUniqueMethod( \bindFunction, { | self, function |
		view.mouseDownAction = { | view, x, y |

			var selectedIndex;

			if( orientation == \horizontal, {
				selectedIndex = x.linlin(
					borderSize, view.bounds.width - ( borderSize * 2 ),
					0, values.size ).asInteger;
			}, {
				selectedIndex = y.linlin(
					borderSize, view.bounds.height - ( borderSize * 2 ),
					0, values.size ).asInteger;
			} );

			// Safety check if user clicked on the right border
			if( selectedIndex == values.size, {
				selectedIndex = selectedIndex - 1 } );

			if( orientation == \vertical, {
				if( growthType == \lin, {
					values[ selectedIndex ] = x.linlin( borderSize, view.bounds.width - borderSize, minVal, maxVal, clip: \minmax )
				}, {
					values[ selectedIndex ] = x.linexp( borderSize, view.bounds.width - borderSize, minVal, maxVal, clip: \minmax )
				} );
			}, {
				if( growthType == \lin, {
					values[ selectedIndex ] = ( view.bounds.height - y ).linlin( borderSize, view.bounds.height - borderSize, minVal, maxVal, borderSize, clip: \minmax )
				}, {
					values[ selectedIndex ] = ( view.bounds.height - y ).linexp( borderSize, view.bounds.height - borderSize, minVal, maxVal, borderSize, clip: \minmax )
				} );
			} );

			function.value( values );
			view.refresh;
		};

		view.mouseMoveAction = view.mouseDownAction;
	} );

	view
}
)