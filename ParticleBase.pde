class ParticleBase {
  ParticleBase() { // dummy constructor for extended classes
  }

  void run() {
    update();
    draw();
  }

  void update() {
  }

  void draw() {
  }

  void applyForce(PVector force) {
  }

  boolean isDead() {
    return false;
  }
}
