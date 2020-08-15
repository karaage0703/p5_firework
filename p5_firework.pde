import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;
import ddf.minim.*;

PostFX fx; // Bloom filter
Minim minim;
AudioSample sound;
PVector gravity;
ArrayList<Firework> fireworks;
boolean refresh = true; // experimental: whether to refresh the screen. Toggle by "a" and "z".

//////// MAIN /////////
// - setup()
// - draw()
// - keyPressed()
// - stop()

void setup() {
  // graphics
  //size(1200, 1080);
  //blendMode(ADD);
  fullScreen(P2D);
  colorMode(HSB, 360, 100, 100, 100);
  smooth();
  background(0);
  fx = new PostFX(this);  

  // audio
//  minim = new Minim(this);
//  sound = minim.loadSample("firework_sound.mp3", 2048);

  // instances
  gravity = new PVector(0.0, 0.1);
  fireworks = new ArrayList<Firework>();
}

void draw() {
  // refresh graphics
  if (refresh) {
    fill(0, random(20, 50)); // alpha for blur effects, should be aware of the performance problems
    noStroke();
    rect(0, 0, width, height);
  }

  // draw each Firework by loop
  for (int i = 0; i < fireworks.size(); i++) {
    Firework firework = fireworks.get(i);
    firework.run();
    if (firework.done()) {
      fireworks.remove(firework);
    }
  }
  
  // add bloom filter
  fx.render()
    .bloom(0.6, 10, 10)
    .compose();
}

void keyPressed() {
  // define and launch firework(s). Args: x, y, category, size, particleNum
  if (key == '1')      fireworks.add(new Firework(random(width), height, 1, 1, 200));
  else if (key == '2') fireworks.add(new Firework(random(width), height, 2, 2, 400));
  else if (key == '3') fireworks.add(new Firework(random(width), height, 3, 3, 600));
  else if (key == '4') fireworks.add(new Firework(random(width), height, 4, 4, 1000));
  else if (key == '5') fireworks.add(new Firework(random(width), height, 5, 3, 600));
  else if (key == '6') fireworks.add(new Firework(random(width), height, 6, 3, 1000));

  // experimental: interactiveness
  else if (key == 'a') refresh = false;
  else if (key == 'z') refresh = true;
}

void stop() {
  // terminate audio/graphics
  sound.close();
  minim.stop();
  super.stop();
}

//////// CLASSES /////////
// - Firework: Firework consists of one BallShell and multiple Particle(s).
// - Particle: 
// - BallShell: BallShell extends Particle. 
