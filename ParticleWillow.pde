//////// PARTICLE ////////
// - Particle(float x, float y, float hue)
// - Particle(PVector _pos, float hue, int fireworkCategory)
// - void run()
// - void update()
// - void draw()
// - void applyForce(PVector force)
// - boolean isDead()

// TODO: Implementing Willow-style Particles
class ParticleWillow extends Particle {
  ParticleWillow(PVector _pos, float _particleHue, int _fadeDecrement, boolean _withRandomMove, boolean _visible) {
    fadeDecrement = _fadeDecrement;
    withRandomMove = _withRandomMove;
    visible = _visible;

    //pos = new PVector(_pos.x, _pos.y);
    pos = _pos;
    exCoords = new ArrayList<PVector>();
    exCoords.add(pos);

    // vel defines the shape
    //vel = PVector.random2D().mult(random(random(0.5, 5), 6));
    vel = new PVector(random(-0.5,1), random(-0.5,1)).mult(random(random(0.5, 5), 6)); //experiments
    acc = new PVector(0, 0.1);
    c = color(_particleHue, 255, 255);

    particleBrightnessDecrement = particleBrightness/random(fadeDecrement * 8, fadeDecrement * 15);
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

    exCoords.add(new PVector(pos.x, pos.y));
  }

  void draw() {
    for (int i = 0; i < exCoords.size(); i++) {
      PVector pos = exCoords.get(i);
      strokeWeight(3 + random(i/3,i/3+2)); 
      stroke(c, particleBrightness/4);
      point(pos.x+random(-1, 1), pos.y+random(-1, 1));
      strokeWeight(3);
      stroke(c, particleBrightness/2);
      point(pos.x+random(-1, 1), pos.y+random(-1, 1));
    }
    if (exCoords.size() > 25) {
      exCoords.remove(0);
    }
  }

  void applyForce(PVector force) {
    acc.add(force);
  }

  boolean isDead() {
    return (particleBrightness < 0);
  }
}
