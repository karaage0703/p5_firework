//////// PARTICLE ////////
// - Particle(float x, float y, float hue)
// - Particle(PVector _pos, float hue, int fireworkCategory)
// - void run()
// - void update()
// - void draw()
// - void applyForce(PVector force)
// - boolean isDead()

class ParticleSparkle extends Particle {
  ParticleSparkle(PVector _pos, float _particleHue, int _fadeDecrement, boolean _withRandomMove, boolean _visible, float _scale, int _rotate) {  
    fadeDecrement = _fadeDecrement;
    withRandomMove = _withRandomMove;
    visible = _visible;
    pos = new PVector(_pos.x, _pos.y);

    // vel defines the shape
    // TODO: continuous rotations
    if (visible) {
      //vel = PVector.random2D().mult(random(random(0.5, 5), 6));
      float angle = random(0, 360);
      vel = new PVector(cos(radians(angle)), sin(radians(angle))/_scale).rotate(radians(_rotate)); // affine trans.
      vel.mult(random(3, 3.1));
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
    particleLife -= 1;

    // Variations: random particle move
    if (withRandomMove) vel.add(random(-0.4, 0.4), random(-0.4, 0.4));

    if (!isLaunching) {
      particleBrightness = random(0, 100)*(int)(random(0, 1.5))*particleLife/100;
      vel.mult(velocityDecrement);
    }
  }

  void draw() {
    if (visible) { // experimental. toggle refresh on/off
      stroke(color(particleLife*3+random(0, 20), 255, 255), particleBrightness);
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
