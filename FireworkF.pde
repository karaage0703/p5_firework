class FireworkF extends Firework {
  FireworkF(PVector _launch_coords) {
    ballShell = new BallShell(_launch_coords, ballShellHue());
    particles = new ArrayList<Particle>();
  }

  void update_explode() {
    float particleHue;

    for (int i = 0; i < particleNum; i++) {
      particleHue = seedParticleHue + random(-10, 10);

      if (i > (particleNum / 2)) {
        particles.add(new ParticleWillow(ballShell.pos, random(40, 60), fadeDecrement, false, false));
      } else {
        particles.add(new ParticleWillow(ballShell.pos, particleHue, fadeDecrement, false, true));
      }
    }
    isExploded = true;

  }
}
