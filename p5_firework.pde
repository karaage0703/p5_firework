import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;
import ddf.minim.*;

PostFX fx; // Bloom filter
Minim minim;
AudioSample sound;
PFont font; // to display FPS
PVector gravity;
VirtualVenue v;
ArrayList<Firework> fireworks;

//////// MAIN /////////
// - setup()
// - draw()
// - keyPressed()
// - stop()

void setup() {
  // graphics
  fullScreen(P2D);
  frameRate(60);
  smooth();
  colorMode(HSB, 360, 100, 100, 100);
  background(0);
  fx = new PostFX(this);

  // audio
  minim = new Minim(this);
  sound = minim.loadSample("firework_sound.mp3", 2048);

  // instances
  gravity = new PVector(0.0, 0.1);
  v = new VirtualVenue();
  fireworks = new ArrayList<Firework>();
}

void draw() {
  // refresh graphics
  fill(0, random(20, 40)); // alpha for blur effects, should be aware of the performance problems
  noStroke();
  rect(0, 0, width, height);

  // draw each Firework by loop
  for (int i = 0; i < fireworks.size(); i++) {
    Firework firework = fireworks.get(i);
    firework.run();
    if (firework.done()) fireworks.remove(firework);
  }

  fx.render().bloom(0.6, 10, 10).compose();   // add bloom filter
  displayMetrics();
}

void keyPressed() {
  // define and launch firework(s). Args: x, y, category, size, particleNum
  if (key == '1') {
//    FireworkB firework = new FireworkB(v.launch_coords());
//    firework.init_particles(1, 200);
//    fireworks.add(firework);
    FireworkB firework = new FireworkB(new PVector(200, height));
    firework.init_particles(1, 200);
    fireworks.add(firework);
    firework = new FireworkB(new PVector(500, height));
    firework.init_particles(1, 200);
    fireworks.add(firework);
    firework = new FireworkB(new PVector(800, height));
    firework.init_particles(1, 200);
    fireworks.add(firework);
    firework = new FireworkB(new PVector(1100, height));
    firework.init_particles(1, 200);
    fireworks.add(firework);
  }
  else if (key == '2') {
    FireworkA firework = new FireworkA(v.launch_coords());
    firework.init_particles(2, 400);
    fireworks.add(firework);
  }
  else if (key == '3') {
    FireworkA firework = new FireworkA(v.launch_coords());
    firework.init_particles(3, 600);
    fireworks.add(firework);
  }
  else if (key == '4') {
    FireworkB firework = new FireworkB(v.launch_coords());
    firework.init_particles(4, 1000);
    fireworks.add(firework);
  }
  else if (key == '5') {
    FireworkC firework = new FireworkC(v.launch_coords());
    firework.init_particles(3, 600);
    fireworks.add(firework);
  } 
  else if (key == '6') {
    FireworkD firework = new FireworkD(v.launch_coords());
    firework.init_particles(3, 1000);
    fireworks.add(firework);
  }
  else if (key == '7') {
    FireworkE firework = new FireworkE(v.launch_coords());
    firework.init_particles(3, 1000);
    fireworks.add(firework);
  }
  else if (key == '8') {
    FireworkE firework = new FireworkE(v.launch_coords());
    firework.init_particles(3, 2000);
    fireworks.add(firework);
  }
  else if (key == '9') {
//    FireworkF firework = new FireworkF(v.launch_coords());
//    firework.init_particles(2, 80);
//    fireworks.add(firework);
    FireworkF firework = new FireworkF(new PVector(width/3, height));
    firework.init_particles(2, 80);
    fireworks.add(firework);
    firework = new FireworkF(new PVector(width*2/3, height));
    firework.init_particles(2, 80);
    fireworks.add(firework);
  }
  else if (key == '0') {
    FireworkG firework = new FireworkG(v.launch_coords());
    firework.init_particles(4, 150);
    fireworks.add(firework);
  }
}

void stop() {
  sound.close();
  minim.stop();
  super.stop();
}

// UTILITIES
void displayMetrics() {
  fill(200);
  text("FPS", 5, 20);
  text(frameRate, 100, 20); // draw FPS
  text("# of fireworks", 5, 35);
  text(fireworks.size(), 100, 35); // draw the number of active fireworks
}
  
float ballShellHue() {
  return random(40, 60);
}
