class Firework {
  // Firework consists of:
  BallShell ballShell;
  ArrayList<Particle> particles;

  // Firework with properties of:
  boolean isExploded = false;
  boolean withRandomMove = false;
  String particleType = "normal";
  int particleNum = 200;
  int fadeDecrement = 3;
  boolean isVisible = true;
  float seedParticleHue = random(360);

  Firework() {
  }

  Firework(PVector _launch_coords) {
    ballShell = new BallShell(_launch_coords, ballShellHue());
    particles = new ArrayList<Particle>();
    sound.trigger();
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
    //boolean isSpecialColors = (random(0,10) < 0.2); // rottery
    adjust_particle_coords();
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

  void add_particle_coords() {
    boolean withRandomMove = false;
    float particleHue;
    for (int i = 0; i < particleNum; i++) {
      //if (isSpecialColors) seedParticleHue = random(360);
      particleHue = seedParticleHue + random(-10, 10);
      particles.add(new Particle(ballShell.pos, particleHue, fadeDecrement, withRandomMove, isVisible));
    }
  }

  void adjust_particle_coords() {
    for (int i = 0; i < particles.size(); i++) {
      Particle particle = particles.get(i);
      particle.pos = new PVector(ballShell.pos.x, ballShell.pos.y);
    }
  }

  boolean done() {
    return (isExploded && particles.isEmpty());
  }

  Firework launch_from(float _x,float _y) {
    this.ballShell.pos = new PVector(_x, _y);
    return this;
  }

  Firework launch_angle(float _angle) {
    float _velseed = random(-12, -6);
    this.ballShell.vel = new PVector(_velseed*cos(radians(_angle)), _velseed*sin(radians(_angle)));
    return this;
  }

  Firework ballshell_hue(float _ballShellHue) {
    this.ballShell.c = color(_ballShellHue, 255, 255);
    return this;
  }

  Firework ground() {
    this.ballShell.vel = new PVector(0, 0);
    return this;
  }

  Firework init_particles(int _fadeDecrement, int _particleNum) {
    particleNum = _particleNum;
    fadeDecrement = _fadeDecrement;
    return this;
  }

  Firework add_particles(String _particleType, float _seedParticleHue, boolean _withRandomMove, int _fadeDecrement, int _particleNum) {
    float particleHue;
    float seedParticleHue = _seedParticleHue;
    boolean withRandomMove = _withRandomMove;
    particleType = _particleType;
    particleNum = _particleNum;
    fadeDecrement = _fadeDecrement;

    for (int i = 0; i < particleNum; i++) {
      // affine transformation
      float scale = random(0.5, 1);
      int rotate = (int)random(0,360);

      particleHue = seedParticleHue + random(-10, 10);
      if (particleType == "normal") {
        particles.add(new Particle(new PVector(0, 0), particleHue, fadeDecrement, withRandomMove, isVisible));
      } else if (particleType == "delayed") {
        particles.add(new Particle(new PVector(0, 0), particleHue, fadeDecrement, withRandomMove, false));
      } else if (particleType == "willow") {
        particles.add(new ParticleWillow(new PVector(0, 0), particleHue, fadeDecrement, withRandomMove, isVisible));
      } else if (particleType == "sparkle") {
        particles.add(new ParticleSparkle(new PVector(0, 0), particleHue, fadeDecrement, withRandomMove, isVisible, scale, rotate));
      }
    }
    return this;
  }

  Firework add_particles_drawing_small(String _particleType, float _seedParticleHue, boolean _withRandomMove, int _fadeDecrement, int _particleNum) {
    float seedParticleHue = _seedParticleHue;
    boolean withRandomMove = _withRandomMove;
    particleType = _particleType;
    particleNum = _particleNum;
    fadeDecrement = _fadeDecrement;

    int drawing[][] = {{100,  0,  0,  0,  0,100},
                       {  0, 50,  0,  0, 50,  0},
                       {  0,  0, 50, 50,  0,  0},
                       {  0,  0, 50, 50,  0,  0},
                       {  0, 50,  0,  0, 50,  0},
                       {100,  0,  0,  0,  0,100}};


    // affine transformation
    float scale = random(0.5, 1);
    int rotate = (int)random(0,360);

    for (int i = -3; i < 3; i++) {
      for (int j = -3; j < 3; j++) {
        if (drawing[i+3][j+3] > 0){
          particles.add(new ParticleDrawing(new PVector(0, 0), seedParticleHue, fadeDecrement, withRandomMove, isVisible, scale, rotate, new PVector(i, j)));
        }
      }
    }
    return this;
  }

    Firework add_particles_drawing_large(String _particleType, float _seedParticleHue, boolean _withRandomMove, int _fadeDecrement, int _particleNum) {
    float seedParticleHue = _seedParticleHue;
    boolean withRandomMove = _withRandomMove;
    particleType = _particleType;
    particleNum = _particleNum;
    fadeDecrement = _fadeDecrement;

    int drawing[][] = {{  0,  0,  0,  0, 50,  0,  0, 50, 50, 50,  0,  0, 50,  0,  0},
                       {  0,  0,  0,  0, 50, 50, 50, 50, 50, 50, 50,  0, 50,  0,  0},
                       {  0,  0,  0, 50,  0,  0, 50, 50, 50, 50, 50, 50,  0, 50,  0},
                       {  0,  0,  0, 50,  0,  0, 50, 50, 50, 50, 50, 50,  0, 50,  0},
                       {  0,  0,  0, 50,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 50},
                       {  0,  0,  0, 50,  0, 50, 50,  0,  0,  0,  0, 50, 50,  0, 50},
                       {  0,  0,  0, 50,  0,  0,  0, 50,  0,  0, 50,  0,  0,  0, 50},
                       {  0,  0,  0, 50,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 50},
                       {  0,  0,  0, 50,  0,  0,  0, 50,  0,  0,  0,  0,  0,  0, 50},
                       {  0,  0,  0, 50,  0,  0,  0, 50,  0,  0,  0,  0,  0,  0, 50},
                       {  0,  0,  0, 50,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 50},
                       {  0,  0, 50, 50, 50,  0,  0, 50,  0,  0, 50,  0,  0, 50,  0},
                       {  0,  0, 50, 50, 50, 50, 50,  0, 50, 50,  0,  0, 50,  0,  0},
                       {  0,  0, 50, 50, 50, 50, 50,  0,  0,  0,  0, 50,  0,  0,  0},
                       {  0,  0, 50, 50, 50,  0,  0, 50, 50, 50, 50,  0,  0,  0,  0}};


    // affine transformation
    //float scale = random(0.5, 1);
    float scale = 1.3;
    //int rotate = (int)random(0,360);
    int rotate = (int)random(-30, 30);

    for (int i = 7; i > -8; i--) {
      for (int j = -8; j < 7; j++) {
        if (drawing[j+8][i+7] > 0){
          particles.add(new ParticleDrawing(new PVector(0, 0), seedParticleHue, fadeDecrement, withRandomMove, isVisible, scale, rotate, new PVector(i*0.5, j*0.5)));
        }
      }
    }
    return this;
  }
}
