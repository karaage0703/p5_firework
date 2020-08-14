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
  background(0);

  // audio
  minim = new Minim(this);
  sound = minim.loadSample("firework_sound.mp3", 2048);

  // instances
  gravity = new PVector(0.0, 0.1);
  fireworks = new ArrayList<Firework>();
}

void draw() {
  // refresh graphics
  fill(0, random(20, 50)); // alpha for gradual fading, should be aware of the performance problems
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
      
      if (ballShell.readyToExplode()) {
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

class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  color c;

  float ballShellFade = 100;
  float particleFade = 20;
  float lifeSpan = random(particleFade/50, particleFade/30);
  boolean isLaunching = false; // launching: true or exploded: false
  
  Particle() {
  }

  Particle(PVector _pos, float hue, int fireworkSize) {
    pos = new PVector(_pos.x, _pos.y);
    vel = PVector.random2D().mult(random(random(0.5, 5), 6));
    acc = new PVector(0, 0.1);
    c = color(hue, 255, 255);

    if (fireworkSize == 1) lifeSpan = random(particleFade/50, particleFade/30);
    else if (fireworkSize == 2) lifeSpan = random(particleFade/100, particleFade/60);
    else if (fireworkSize == 3) lifeSpan = random(particleFade/150, particleFade/90);
    else if (fireworkSize == 4) lifeSpan = random(particleFade/200, particleFade/120);
  }

  void run() {
    update();
    draw();
  }
  
  void update() {
    pos.add(vel);
    vel.add(acc);
    acc.mult(0);
    if (!isLaunching) {
      particleFade -= lifeSpan;
      vel.mult(0.98);
    }
  }
  
  void draw() {
    stroke(c, particleFade);
    strokeWeight(random(4, 8)); // randomize the strength of the light
    point(pos.x, pos.y);
  }
  
  void applyForce(PVector force) {
    acc.add(force);
  }
  
  boolean isDead() {
    return (particleFade < 0);
  }

}

//////// BALLSHELL ////////
// - BallShell(float x, float y, float hue)
// - 
// - 
// - boolean readyToExplode()

class BallShell extends Particle {
  BallShell(float x, float y, float hue) {
    pos = new PVector(x, y);
    vel = new PVector(0, random(-12, -6));
    acc = new PVector(0, 0.1);
    c = color(hue, 255, 255);
    isLaunching = true;
  }
  
  void update() {
    pos.add(vel);
    vel.add(acc);
    acc.mult(0);
    if (isLaunching) ballShellFade -= 2;
  }
  
  void draw() {
    if (isLaunching) { // before explode and still going up
      stroke(c, ballShellFade);
      strokeWeight(random(5, 10)); // randomize the strength of the light
      point(pos.x, pos.y);
    }
  }
  
  boolean readyToExplode() {
    return (isLaunching && vel.y > 0);
  }
}
