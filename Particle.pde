//////// PARTICLE ////////
// - Particle(float x, float y, float hue)
// - Particle(PVector _pos, float hue, int fireworkCategory)
// - void run()
// - void update()
// - void draw()
// - void applyForce(PVector force)
// - boolean isDead()

class Particle extends ParticleBase {
  PVector pos;
  PVector vel;
  PVector acc;
  color c;

  // default parameters
  int fadeDecrement = 3;
  int particleHue = 50;
  float ballShellBrightness = 100;
  float particleBrightness = 60;
  float velocityDecrement = 0.975;
  float particleBrightnessDecrement;
  boolean isLaunching = false;       // launching: true or exploded: false
  boolean withRandomMove = false;    // random move
  boolean visible = true;            // control deplayed sparkles
  
  Particle() { // dummy constructor for extended classes
  }

  Particle(PVector _pos, float _particleHue, int _fadeDecrement, boolean _withRandomMove, boolean _visible) {
    fadeDecrement = _fadeDecrement;
    withRandomMove = _withRandomMove;
    visible = _visible;
    pos = new PVector(_pos.x, _pos.y);

    if (visible) { 
      vel = PVector.random2D().mult(random(random(0.5, 5), 6));
    } else {
      // special particle (delayed sparkles) 
      vel = PVector.random2D().mult(random(random(0.5, 4), 5));
    }
    
    acc = new PVector(0, 0.1);
    c = color(_particleHue, 255, 255);
    particleBrightnessDecrement = particleBrightness/random(fadeDecrement*20, fadeDecrement*40);
  }

  void run() {
    update();
    draw();
  }
  
  void update() {
    pos.add(vel);
    vel.add(acc);
    acc.mult(0);
    vel.add((random(-0.05, 0.05)), 0); // randomize a bit of the velocities
    
    // Variations: random particle move
    if (withRandomMove) vel.add(random(-0.4, 0.4), random(-0.4, 0.4));

    if (!isLaunching) {
      particleBrightness -= particleBrightnessDecrement;
      vel.mult(velocityDecrement);
    }
    
    if (!visible && particleBrightness < 20) {
      visible = true;
      particleBrightness = 60;
      particleBrightnessDecrement *= 2;
    }
  }
  
  void draw() {
    if (visible) { // experimental. toggle refresh on/off
      stroke(c, particleBrightness);
      strokeWeight(random(5, 10)); 
      point(pos.x+random(-2, 2), pos.y+random(-2, 2));
      strokeWeight(3); 
      point(pos.x+random(-1, 1), pos.y+random(-1, 1));
    }
  }
  
  void applyForce(PVector force) {
    acc.add(force);
  }
  
  boolean isDead() {
    return (particleBrightness < 0);
  }
  
  void setCoords(PVector _pos) {
    pos = _pos;
  }

}
