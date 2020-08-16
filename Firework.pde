//////// FIREWORK ////////
// - Firework(float _x, float _y, int _fireworkCategory, int _fadeDecrement, int _particleNum)
// - void run()
// - boolean done()

class Firework {
  // Firework consists of:
  BallShell ballShell;
  ArrayList<Particle> particles;
  
  // Firework with properties of:
  boolean isExploded = false;
  boolean withRandomMove = false;
  int particleNum = 200;
  int fadeDecrement = 3;
  float seedParticleHue = random(360);
  
  Firework() {
  }
  
  Firework(PVector _launch_coords) {
    ballShell = new BallShell(_launch_coords, ballShellHue());
    particles = new ArrayList<Particle>();
//    sound.trigger();
  }

  void run() {
    if (!isExploded) {
      update_ballshell();
      // TODO: why update_explode ends with errors when called here run()
    } else { 
      update_particles();
    }
  }
  
  void update_ballshell() {
    ballShell.applyForce(gravity);
    ballShell.update();
    ballShell.draw();
    if (ballShell.readyToExplode()) update_explode();
  }
  
  void update_explode() {
    boolean withRandomMove = false;
    float particleHue;
    boolean isSpecialColors = (random(0,10) < 0.2); // rottery
    
    for (int i = 0; i < particleNum; i++) {
      if (isSpecialColors) seedParticleHue = random(360);
      particleHue = seedParticleHue + random(-10, 10);
      particles.add(new Particle(ballShell.pos, particleHue, fadeDecrement, withRandomMove, true));
    }
    isExploded = true;
  }

  void update_particles() {
    for (int i = 0; i < particles.size(); i++) {
      Particle particle = particles.get(i);
      particle.applyForce(gravity);
      particle.run();
      if (particle.isDead()) {
        particles.remove(particle);
      }
    }
  }
    
  void init_particles(int _fadeDecrement, int _particleNum) {
    particleNum = _particleNum;
    fadeDecrement = _fadeDecrement;
  }
  
  boolean done() {
    return (isExploded && particles.isEmpty());
  }
}
