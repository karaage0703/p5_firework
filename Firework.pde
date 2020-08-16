//////// FIREWORK ////////
// - Firework(float _x, float _y, int _fireworkCategory, int _fadeDecrement, int _particleNum)
// - void run()
// - boolean done()

class Firework {
  BallShell ballShell;
  ArrayList<Particle> particles;
  float hue;
  int fireworkCategory;
  int particleNum;
  int fadeDecrement;

  Firework(float _x, float _y, int _fireworkCategory, int _fadeDecrement, int _particleNum) {
    float ballShellHue = random(40, 60);
    fireworkCategory = _fireworkCategory;
    particleNum = _particleNum;
    fadeDecrement = _fadeDecrement;

    ballShell = new BallShell(_x, _y, ballShellHue);
    particles = new ArrayList<Particle>();

    sound.trigger();
  }

  void run() {
    // BALL SHELL'S LIFE
    if (ballShell != null) {
      ballShell.applyForce(gravity);
      ballShell.update();
      ballShell.draw();

      // BALL SHELL EXPLODES!!!
      if (ballShell.readyToExplode()) {
        // color variations and limitations by fireworkCategory(s)
        boolean withRandomMove = false;
        float seedParticleHue = random(360);
        if (fireworkCategory == 1 ) seedParticleHue = random(40, 60);
        else if (fireworkCategory == 4 ) seedParticleHue = random(40, 60);
        else if (fireworkCategory == 5 ) withRandomMove = true;

        float particleHue = seedParticleHue;
        boolean isSpecialColors = (random(0,10) < 0.2); // rottery

        for (int i = 0; i < particleNum; i++) {
          if (isSpecialColors) seedParticleHue = random(360);
          particleHue = seedParticleHue + random(-10, 10);
          if (fireworkCategory == 6 && i > (particleNum / 2)) {
            particles.add(new Particle(ballShell.pos, random(40, 60), fadeDecrement, withRandomMove, false));
          } else {
            particles.add(new Particle(ballShell.pos, particleHue, fadeDecrement, withRandomMove, true));
          }
        }
        ballShell = null; // a ball shell ends its life
      }
    }

    // PARTICLE(S)' LIFE
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
