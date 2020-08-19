import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;
import ddf.minim.*;
//import java.util.Collections;

PostFX fx; // Bloom filter
Minim minim;
AudioSample sound;
PFont font; // to display FPS

PVector gravity;
VirtualVenue v;
ArrayList<Firework> fireworks;
ArrayList<Firework> fireworks_tick; // int < 2147483647 => 9942hr. Enough. Fill all with Null and then add necessary frames.

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
  //sound = minim.loadSample("firework_sound.mp3", 2048);

  // instances
  gravity = new PVector(0.0, 0.1);
  v = new VirtualVenue();
  fireworks = new ArrayList<Firework>();
//  fireworks_tick = Collections.nCopies(8, null);
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
  if (key == '1') {
    for (int i = 1; i < 5; i++) {
      for (int j = 0; j < 6; j++) {
        Firework f = new Firework(v.launch_coords());
        f.add_particles("normal", 50, false, 1, 200)
         .launch_from(width*i/5, height)
         .launch_angle(60+10*j);
        fireworks.add(f);
      }
    }

  }
  else if (key == '2') {
    for (int i = 1; i < 4; i++) {
      for (int j = 0; j < 6; j++) {
        Firework f = new Firework(v.launch_coords());
        f.add_particles("willow", 50, false, 4, 20)
         .add_particles("delayed", 50, false, 5, 100)
         .add_particles("sparkle", 100,  false, 2, 100)
         .launch_from(width*i/4, height);
        fireworks.add(f);
      } //<>//
    }  
  }
  else if (key == '3') {
    Firework f = new Firework(v.launch_coords());
    f.add_particles("normal", random(360), false, 3, 200);
    fireworks.add(f);
  }
  else if (key == '4') {
    Firework f = new Firework(v.launch_coords());
    f.add_particles("normal", random(360), false, 2, 600);
    fireworks.add(f);
  }
  else if (key == '5') {
    Firework f = new Firework(v.launch_coords());
    f.add_particles("normal", random(360), false, 3, 600)
     .add_particles("delayed", 50, false, 3, 600);
    fireworks.add(f);
  } 
  else if (key == '6') {
    Firework f = new Firework(v.launch_coords());
    f.add_particles("normal", random(360), false, 3, 800)
     .add_particles("delayed", 50, true, 3, 600);
    fireworks.add(f);
  }
  else if (key == '7') {
    for (int k = 1; k < 3; k++) {
      for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 10; j++) {
          Firework f = new Firework(v.launch_coords());
          f.launch_from(width * k/3, height)
           .ballshell_hue(random(60 + 20 * j))
           .launch_angle(60 + 6 * j);
          fireworks.add(f);
        }
      }
    }
  }
  else if (key == '8') {
    for (int i = 1; i < 4; i++) {
      Firework f = new Firework(v.launch_coords());
      f.launch_from(width*i/4, height)
       .add_particles_drawing_large("test", 50, false, 3, 600);
      fireworks.add(f);
    }
  }
  else if (key == '9') {
    for (int i = 1; i < 4; i++) {
      Firework f = new Firework(v.launch_coords());
      f.launch_from(width*i/4, height)
       .add_particles_drawing_small("test", 50, false, 3, 600);
      fireworks.add(f);
    }
  }
  else if (key == '0') {
    FireworkZ firework = new FireworkZ(v.launch_coords());
    firework.init_particles(4, 50);
    fireworks.add(firework);
  }
  else if (key == ' ') { // EXPLODE'EM ALL
    for (int i = 0; i < fireworks.size(); i++) {
      Firework firework = fireworks.get(i);
      if (!firework.isExploded) firework.update_explode();
    }
  }
  else if (key == 'a') {
    gravity = new PVector(0.1, 0.1);
  }
  else if (key == 's') {
    gravity = new PVector(0.0, 0.1);
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
