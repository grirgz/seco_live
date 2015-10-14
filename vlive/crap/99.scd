(
// todo: multiple balls
var paddlePositions = [0.5,0.5]; // Paddle position from 0 (left) to 1 (right)
var paddleWidths = [100, 100];
var paddleSpeed = 0.005;
var paddleMaxSpeed = 0.02;
var paddleMovements = [0,0];
var friction = 1.15;
var width = 800, height = 700;
var ballPosition = Point(width/2, height/2);
var ballSize = 10;
var ballXMovement = rand2(1.5);
var ballYMovement = 3.0*((rand(2)*2)-1);
var ballMaxSpeed = 30;
var scores = [0,0];
var notes = Scale.phrygian.degrees+60;

k = Set[]; // keep track of held keys

// SynthDef
SynthDef(\bounce, {
  |out=0, gain=0.5, length=1, freq=200, depth=20|
  var bounce, freqenv, ampenv;
  freqenv = EnvGen.kr(Env.perc(0.01,length,depth));
  ampenv = EnvGen.kr(Env.perc(0.01,length,1.0),doneAction:2);
  bounce = SinOsc.ar(freq+freqenv)!2 * ampenv * gain;
  bounce = Limiter.ar(bounce, gain, 0.001);
  Out.ar(out,bounce);
}).add;

// GUI
w = Window("Pong", Rect((Window.screenBounds.width/2)-(width/2), (Window.screenBounds.height/2)-(height/2), width, height), false).front;
u = UserView(w, Rect(0, 0, width, height));
u.background = Color.white;
u.animate = true;
u.frameRate = 60;
u.drawFunc = {
  // update paddle position
  2.do{|i|
    if(paddleMovements[i]<0,{
      //  left bounds
      // if holding left, increase left speed
      if(  (paddleMovements[i].abs < paddleMaxSpeed)
        && (k.includes(i*123)),{
          paddleMovements[i] = paddleMovements[i]-0.001;
      });
      if((paddlePositions[i]*width - paddleWidths[i]) >= 40,
        {
          paddlePositions[i] = paddlePositions[i] + paddleMovements[i];
        }
      );
    },{
      // right bounds
      // if holding right, increase right speed
      if(  (paddleMovements[i].abs < paddleMaxSpeed)
        && (k.includes(i*122+2)),{
          paddleMovements[i] = paddleMovements[i]+0.001;
      });
      if((paddlePositions[i]*width + paddleWidths[i]) <= (width-40),
        {
          paddlePositions[i] = paddlePositions[i] + paddleMovements[i];
        }
      );
    });
  };
  if((k.includes(0) || (k.includes(2))).not,
    {
      paddleMovements[0] = paddleMovements[0] / friction;
  });
  if((k.includes(123) || (k.includes(124))).not,
    {
      paddleMovements[1] = paddleMovements[1] / friction;
  });
  // update ball position
  ballPosition.x = ballPosition.x + ballXMovement;
  ballPosition.y = ballPosition.y + ballYMovement;
  // collision detection
  // top
  if ((ballPosition.y < 45) && (ballPosition.y > (35-(ballYMovement.abs))),
    {
      if(  (ballPosition.x > (paddlePositions[0]*width-paddleWidths[0]))
        && (ballPosition.x < (paddlePositions[0]*width+paddleWidths[0])),
        {
          var ballRelPos = (ballPosition.x / width)-0.5;
          Synth(\bounce, [\freq, notes.choose.midicps]);
          ballYMovement = ballYMovement.abs;
          if (ballYMovement <= ballMaxSpeed,
            {ballYMovement = ballYMovement * (1.1);}
          );
          ballXMovement = ballXMovement + (ballRelPos*4);
        }
      );
    }
  );
  // bottom
  if ((ballPosition.y > (height-45)) && (ballPosition.y < (height-35+ballYMovement.abs)),
    {
      if(  (ballPosition.x > (paddlePositions[1]*width-paddleWidths[1]))
        && (ballPosition.x < (paddlePositions[1]*width+paddleWidths[1])),
        {
          var ballRelPos = (ballPosition.x / width)-0.5;
          Synth(\bounce, [\freq, notes.choose.midicps]);
          ballYMovement = ballYMovement.abs * (-1);
          if (ballYMovement.abs <= ballMaxSpeed,
            {ballYMovement = ballYMovement * (1.1);}
          );
          ballXMovement = ballXMovement + (ballRelPos*4);
        }
      );
    }
  );

  // wall bounce
  if (ballPosition.x > (width-40),
    {
      Synth(\bounce, [\freq, notes.choose.midicps]);
      ballXMovement = ballXMovement.abs * (-1);
    }
  );
  if (ballPosition.x < 40,
    {
      Synth(\bounce, [\freq, notes.choose.midicps]);
      ballXMovement = ballXMovement.abs;
    }
  );

  // out detection
  // out top
  if (ballPosition.y < (0-ballYMovement.abs),
    {
      scores[1] = scores[1]+1;
      Synth(\bounce, [\freq, 10, \length, (4), \depth, 100]);
      ballPosition = Point(width/2, height/2);
      ballXMovement = rand2(1.5);
      ballYMovement = 3.0;
    }
  );
  // out bottom
  if (ballPosition.y > (height+(ballYMovement.abs)),
    {
      scores[0] = scores[0]+1;
      Synth(\bounce, [\freq, 10, \length, (4), \depth, 100]);
      ballPosition = Point(width/2, height/2);
      ballXMovement = rand2(1.5);
      ballYMovement = -3.0;
    }
  );
  Pen.use {
    // draw bounds
    Pen.line(Point(40,40),Point(40,height-40));
    Pen.line(Point(width-40,40),Point(width-40,height-40));
    Pen.strokeColor = Color.green;
    Pen.width = 3;
    Pen.stroke;
    // draw paddles
    Pen.line(
      Point(paddlePositions[0]*width-paddleWidths[0], 40),
      Point(paddlePositions[0]*width+paddleWidths[0], 40)
    );
    Pen.line(
      Point(paddlePositions[1]*width-paddleWidths[1], (height-40)),
      Point(paddlePositions[1]*width+paddleWidths[1], (height-40))
    );
    Pen.strokeColor = Color.black;
    Pen.width = 5;
    Pen.stroke;
    // draw ball
    Pen.fillOval(Rect(ballPosition.x-(ballSize/2),ballPosition.y-(ballSize/2),ballSize,ballSize));
    // Draw score
    (scores[0]+"").drawAtPoint(
              Point(width/2,height/2-100),
              Font("Courier", 30),
              Color.blue(0.3, 0.5));
    (scores[1]+"").drawAtPoint(
              Point(width/2,height/2+100),
              Font("Courier", 30),
              Color.blue(0.3, 0.5));
  };
};

w.view.keyDownAction = {
  arg view, char, modifiers, unicode, keycode, key;
  if(k.includes(key).not,{
    k.add(keycode); // add keystroke to list of keys being held
    switch(keycode,
      0, {paddleMovements[0] = paddleSpeed*(-1)},  // left player 0
      2, {paddleMovements[0] = paddleSpeed},  // right player 0
      123, {paddleMovements[1] = paddleSpeed*(-1)},  // left player 1
      124, {paddleMovements[1] = paddleSpeed}  // right player 1
    );
  });
};
w.view.keyUpAction_({
  arg view, char, mod, uni, keycode, key;
  switch(keycode,
    0, {if(k.includes(2),{paddleMovements[0] = paddleSpeed})},  // left
    2, {if(k.includes(0),{paddleMovements[0] = paddleSpeed*(-1)})},  // right
    123, {if(k.includes(124),{paddleMovements[1] = paddleSpeed})},  // left
    124, {if(k.includes(123),{paddleMovements[1] = paddleSpeed*(-1)})},  // right
  );
  k.remove(keycode); // remove keystroke from list of keys being held
});
)
