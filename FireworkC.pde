//////// FIREWORK ////////
// - Firework(float _x, float _y, int _fireworkCategory, int _fadeDecrement, int _particleNum)
// - void run()
// - boolean done()

class FireworkC extends Firework {
  FireworkC(PVector _launch_coords) {
    ballShell = new BallShell(_launch_coords, ballShellHue());
    particles = new ArrayList<Particle>();
//    sound.trigger();
  }
  
  void update_explode() {
    boolean withRandomMove = true;
    float particleHue;
    
    for (int i = 0; i < particleNum; i++) {
      particleHue = seedParticleHue + random(-10, 10);
      particles.add(new Particle(ballShell.pos, particleHue, fadeDecrement, withRandomMove, true));
    }
    isExploded = true;
  }
}
