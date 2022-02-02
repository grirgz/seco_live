
(
{ arg
	backgroundColor = ~gm.at( \backgroundColor ),
	borderColor = ~gm.at( \borderColor ),
	borderSize = ~gm.at( \borderSize );

	var view = UserView.new();
	var hSlider = UserView();
	var svSlider = UserView();
	var helper = UserView();

	var bindedFunction = nil;

	var color = Color( 1, 0, 0 );
	var hsv = [ 0, 1, 1 ];

	var margin; // Slider half dead zone

	// HSV to Color function
	var hsvToColor = { | hsv |

		var color = Color( 0, 0, 0 );

		var h = hsv[0];
		var s = hsv[1];
		var v = hsv[2];

		var c = s * v;
		var x = c * ( 1 - ( ( h/60.0 )%2.0 -1 ).abs );
		var m = v - c;

		if( ( h >= 0 ) && ( h < 60 ), {
			color.red = c;
			color.green = x;
			color.blue = 0;
		} );

		if( ( h >= 60 ) && ( h < 120 ), {
			color.red = x;
			color.green = c;
			color.blue = 0;
		} );

		if( ( h >= 120 ) && ( h < 180 ), {
			color.red = 0;
			color.green = c;
			color.blue = x;
		} );

		if( ( h >= 180 ) && ( h < 240 ), {
			color.red = 0;
			color.green = x;
			color.blue = c;
		} );

		if( ( h >= 240 ) && ( h < 300 ), {
			color.red = x;
			color.green = 0;
			color.blue = c;
		} );

		if( ( h >= 300 ) && ( h < 360 ), {
			color.red = c;
			color.green = 0;
			color.blue = x;
		} );

		color.red = color.red + m;
		color.green = color.green + m;
		color.blue = color.blue + m;

		color;
	};

	var colorToHSV = { | color |

		var red = color.red;
		var green = color.green;
		var blue = color.blue;

		var minC = red;
		var maxC = red;

		var v;

		if( minC > green, { minC = green } );
		if( minC > blue, { minC = blue } );

		if( maxC < green, { maxC = green } );
		if( maxC < blue, { maxC = blue } );

		v = maxC;

		if( ( minC == maxC ), {
			hsv = [ 0, 0, v ];
		}, {
			var h;
			var s = (maxC-minC) / maxC;
			var rc = (maxC-red) / (maxC-minC);
			var gc = (maxC-green) / (maxC-minC);
			var bc = (maxC-blue) / (maxC-minC);

			if( red == maxC, { h = bc-gc } );
			if( green == maxC, { h = 2.0+rc-bc } );
			if( blue == maxC, { h = h = 4.0+gc-rc } );

			h = (h/6.0) % 1.0;
			h = h * 360;
			hsv = [ h, s, v ];
		} );
	};

	view.drawFunc = { | view |
		Pen.fillColor_( borderColor );
		Pen.fillRect(
			Rect(
				0,
				0,
				view.bounds.width,
				view.bounds.height
			)
		);

		Pen.fillColor_( backgroundColor );
		Pen.fillRect(
			Rect(
				borderSize,
				borderSize,
				view.bounds.width - ( borderSize * 2 ),
				view.bounds.height - ( borderSize * 2 )
			)
		);
	};

	// Resizing adjustments
	view.onResize = { | view |
		margin = ( view.bounds.width * 0.05 );
		hSlider.refresh;
		svSlider.refresh;
	};

	// Hue Slider setup
	hSlider.background_( Color.black );
	hSlider.drawFunc_( { | view |
		Pen.width = 1;
		( view.bounds.height - ( margin * 2 ) ).do( { | index |
			Pen.strokeColor_(
				hsvToColor.value(
					[
						index.linlin(
							0,
							( view.bounds.height - ( margin * 2 ) ),
							0,
							360
						),
						hsv[1],
						hsv[2]
					];
				);
			);

			Pen.moveTo( Point( margin, index + margin ) );
			Pen.lineTo( Point( view.bounds.width - margin, index + margin ) );
			Pen.stroke;
		} );

		Pen.addRect(
			Rect(
				margin / 2,
				margin / 2 + ( view.bounds.height - ( margin * 2 ) * ( hsv[0] / 360 ) ) + margin,
				view.bounds.width - margin,
				margin
			)
		);
		Pen.fillAxialGradient(
			Point( 0, margin / 2 + ( view.bounds.height - ( margin * 2 ) * ( hsv[0] / 360 ) ) + margin ),
			Point( 0, margin / 2 + ( view.bounds.height - ( margin * 2 ) * ( hsv[0] / 360 ) ) + ( margin * 2 ) ),
			Color( 0, 0, 0, 1 ),
			Color( 0, 0, 0, 0 )
		);

		Pen.addRect(
			Rect(
				margin / 2,
				margin / 2 + ( view.bounds.height - ( margin * 2 ) * ( hsv[0] / 360 ) ) - margin,
				view.bounds.width - margin,
				margin
			)
		);
		Pen.fillAxialGradient(
			Point( 0, margin / 2 + ( view.bounds.height - ( margin * 2 ) * ( hsv[0] / 360 ) ) - margin ),
			Point( 0, margin / 2 + ( view.bounds.height - ( margin * 2 ) * ( hsv[0] / 360 ) ) ),
			Color( 0, 0, 0, 0 ),
			Color( 0, 0, 0, 1 )
		);

		Pen.fillColor_( color );
		Pen.fillRect(
			Rect(
				margin / 2,
				margin / 2 + ( view.bounds.height - ( margin * 2 ) * ( hsv[0] / 360 ) ),
				view.bounds.width - margin,
				margin
			)
		)
	} );

	hSlider.mouseDownAction_( { | view, x, y |
		if( y >= margin, {
			if( y <= ( view.bounds.height - margin ), {
				y = y.linlin( margin, view.bounds.height - margin, 0, 360 );
				hsv[0] = y;
				color = hsvToColor.value( hsv );
				if( bindedFunction != nil, { bindedFunction.value( color ) } );
				hSlider.refresh;
				helper.refresh;
				svSlider.refresh;
			} )
		} )
	} );
	hSlider.mouseMoveAction_( hSlider.mouseDownAction );

	// Saturation Slider setup
	svSlider.background_( Color.black );
	svSlider.drawFunc_( { | view |

		( view.bounds.width - ( margin * 2 ) ).do( { | indexX |
			Pen.addRect(
				Rect(
					margin + indexX,
					margin,
					1,
					view.bounds.height - ( margin * 2 )
				)
			);
			Pen.fillAxialGradient(
				Point( 0, margin ),
				Point( 0, view.bounds.height - ( margin * 2 ) ),
				Color.black,
				hsvToColor.value(
					[
						hsv[0],
						indexX.linlin( 0, view.bounds.width, 0, 1 ),
						1
					]
				)
			);
		} );

		Pen.addWedge(
			Point(
				view.bounds.width - ( margin * 2 ) * hsv[1] + margin,
				view.bounds.height - ( margin * 2 ) * hsv[2] + margin,
			),
			margin * 2,
			0,
			360
		);
		Pen.fillRadialGradient(
			Point(
				view.bounds.width - ( margin * 2 ) * hsv[1] + margin,
				view.bounds.height - ( margin * 2 ) * hsv[2] + margin,
			),
			Point(
				view.bounds.width - ( margin * 2 ) * hsv[1] + margin,
				view.bounds.height - ( margin * 2 ) * hsv[2] + margin,
			),
			margin,
			margin * 1.5,
			Color( 0, 0, 0, 1 ),
			Color( 0, 0, 0, 0 )
		);

		Pen.fillColor_( color );
		Pen.addWedge(
			Point(
				view.bounds.width - ( margin * 2 ) * hsv[1] + margin,
				view.bounds.height - ( margin * 2 ) * hsv[2] + margin,
			),
			margin,
			0,
			360
		);
		Pen.fill;
	} );

	svSlider.mouseDownAction_( { | view, x, y |

		case
		{ x < margin } { hsv[1] = 0 }
		{ x > ( view.bounds.width + margin ) } { hsv[1] = 1 }
		{ ( ( x >= margin ) && ( x <= ( view.bounds.width - margin ) ) ) } {
			hsv[1] = x.linlin( margin, view.bounds.width - margin, 0, 1 );
		};

		case
		{ y < margin } { hsv[2] = 0 }
		{ y > ( view.bounds.height + margin ) } { hsv[2] = 1 }
		{ ( ( y >= margin ) && ( y <= ( view.bounds.height - margin ) ) ) } {
			hsv[2] = y.linlin( margin, view.bounds.height - margin, 0, 1 );
		};

		color = hsvToColor.value( hsv );
		if( bindedFunction != nil, { bindedFunction.value( color ) } );
		helper.refresh;
		svSlider.refresh;
		hSlider.refresh;
	} );
	svSlider.mouseMoveAction_( svSlider.mouseDownAction );

	helper.drawFunc_( { | view |
		Pen.fillColor_( color );
		Pen.fillRect(
			Rect(
				0,
				0,
				view.bounds.width,
				view.bounds.height
			)
		)
	} );

	// Background Color
	view.background_( Color.black );
	view.layout_(
		VLayout(
			[ helper, stretch:1 ],
			[ HLayout(
				[ hSlider, stretch: 1 ],
				[ svSlider, stretch: 2 ]
			), stretch:2 ]
		);
	);

	view.addUniqueMethod(
		\loadColor, { | object, inputColor |
			color = inputColor;
			colorToHSV.value( inputColor );
			hSlider.refresh;
			svSlider.refresh;
			helper.refresh;
	} );
	view.addUniqueMethod( \bindFunction, { | object, function | bindedFunction = function } );

	view
}
)