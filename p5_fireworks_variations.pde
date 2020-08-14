import ddf.minim.*;

Minim minim;
AudioSample sound;
PVector gravity;
ArrayList<Firework> fireworks;

//////// MAIN /////////
// - setup()
// - draw()
// - keyPressed()
// - stop()

void setup() {
  // graphics
  size(1600, 800);
  colorMode(HSB, 360, 100, 100, 100);
  smooth();
  background(20);

  // audio
  minim = new Minim(this);
  sound = minim.loadSample("firework_sound.mp3", 2048);

  // instances
  gravity = new PVector(0.0, 0.1);
  fireworks = new ArrayList<Firework>();
}

void draw() {
  // refresh graphics
  fill(20);
  noStroke();
  rect(0, 0, width, height);

  // draw each Firework by loop
  for (int i = 0; i < fireworks.size(); i++) {
    Firework firework = fireworks.get(i);
    firework.run();
    if (firework.done()) {
      fireworks.remove(firework);
    }
  }
}

void keyPressed() {
  // trigger Firework(s)
  if (key == '1')      fireworks.add(new Firework(1));
  else if (key == '2') fireworks.add(new Firework(2));
  else if (key == '3') fireworks.add(new Firework(3));
  else if (key == '4') fireworks.add(new Firework(4));
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

//////// FIREWORK ////////
// - Firework(int _fireworkSize)
// - void run()
// - boolean done()

class Firework {
  BallShell ballShell;
  ArrayList<Particle> particles;

  float hue;
  int fireworkSize;
  int particleNum;

  Firework(int _fireworkSize) {
    float ballShellHue = 50.0;
    fireworkSize = _fireworkSize;
    
    // define number of particles
    if (_fireworkSize == 1 )      particleNum = 100;
    else if (_fireworkSize == 2 ) particleNum = 200;
    else if (_fireworkSize == 3 ) particleNum = 300;
    else if (_fireworkSize == 4 ) particleNum = 400;
    
    ballShell = new BallShell(random(width), height, ballShellHue);
    particles = new ArrayList<Particle>();

    sound.trigger();
  }

  void run() {
    if (ballShell != null) {
      ballShell.applyForce(gravity);
      ballShell.update();
      ballShell.draw();
      
      if (ballShell.explode()) {
        float seedParticleHue = random(360);
        float particleHue = seedParticleHue;
        boolean isSpecialColors = (random(0,10) < 0.2); // rottery
        
        for (int i = 0; i < particleNum; i++) {
          if (isSpecialColors) seedParticleHue = random(360);
          particleHue = seedParticleHue + random(-10, 10);
          particles.add(new Particle(ballShell.pos, particleHue, fireworkSize));
        }
        ballShell = null;
      }
    }

    for (int i = 0; i < particles.size(); i++) {
      Particle child = particles.get(i);
      child.applyForce(gravity);
      child.run();
      if (child.isDead()) particles.remove(child);
    }
  }
    
  boolean done() { // removed if
    return (ballShell == null && particles.isEmpty());
  }

}

//////// PARTICLE ////////
// - Particle(float x, float y, float hue)
// - Particle(PVector _pos, float hue, int fireworkSize)
// - void run()
// - void update()
// - void draw()
// - void applyForce(PVector force)
// - boolean isDead()
// - boolean explode()

class Particle {
  PVector pos;
  PVector vel;
  PVector acc;

  float particleLife = 100;
  float fireworkLife = 100;
  float lifeSpan = random(fireworkLife/50, fireworkLife/30);
  boolean isLaunching = false; // launching: true or exploded: false
  color c;
  
  Particle() {
  }


  Particle(PVector _pos, float hue, int fireworkSize) {
    pos = new PVector(_pos.x, _pos.y);
    vel = PVector.random2D();
    vel.mult(random(3, 6));
    acc = new PVector(0, 0.1);
    c = color(hue, 255, 255);

    if (fireworkSize == 1) lifeSpan = random(fireworkLife/50, fireworkLife/30);
    else if (fireworkSize == 2) lifeSpan = random(fireworkLife/100, fireworkLife/60);
    else if (fireworkSize == 3) lifeSpan = random(fireworkLife/200, fireworkLife/120);
    else if (fireworkSize == 4) lifeSpan = random(fireworkLife/400, fireworkLife/240);
  }

  void run() {
    update();
    draw();
  }
  
  void update() {
    pos.add(vel);
    vel.add(acc);
    if (isLaunching) {
      particleLife -= 1;
    } else {
      fireworkLife -= lifeSpan;
      vel.mult(0.98);
    }
    acc.mult(0);
  }
  
  void draw() {
    stroke(c, fireworkLife);
    strokeWeight(8);
    point(pos.x, pos.y);
  }
  
  void applyForce(PVector force) {
    acc.add(force);
  }
  
  boolean isDead() {
    return (fireworkLife < 0);
  }

  boolean explode() {
    if (isLaunching && vel.y > 0) {
      lifeSpan = 0;
      return true;
    }
    return false;
  }
}

//////// BALLSHELL ////////
// - BallShell(float x, float y, float hue)

class BallShell extends Particle {
  BallShell(float x, float y, float hue) {
    pos = new PVector(x, y);
    vel = new PVector(0, random(-12, -6));
    acc = new PVector(0, 0.1);
    c = color(hue, 255, 255);
    isLaunching = true;
  }
  
  void draw() {
    if (isLaunching) {
      stroke(c, particleLife);
      strokeWeight(10);
    }
    point(pos.x, pos.y);
  }
}
