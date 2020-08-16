//////// BALLSHELL ////////
// - BallShell(float x, float y, float hue)
// - void update()
// - void draw()
// - boolean readyToExplode()

class BallShell extends Particle {
  BallShell(PVector _launch_coords, float hue) {
    pos = _launch_coords;
    vel = new PVector(0, random(-12, -6));
    acc = new PVector(0, 0.1);
    c = color(hue, 255, 255);
    isLaunching = true;
  }
  
  void update() {
    pos.add(vel);
    vel.add(acc);
    acc.mult(0);
    
    vel.add((random(-0.1, 0.1)), 0); // randomize a bit of the velocities
    if (isLaunching) ballShellBrightness -= 2;
  }
  
  void draw() {
    if (isLaunching) { // before explode and still going up
      stroke(c, ballShellBrightness); // randomize the strength of the light and draw multiple times for the glow effects
      strokeWeight(random(5, 15));
      point(pos.x+random(-2, 2), pos.y+random(-2, 2));
      strokeWeight(random(4, 8)); 
      point(pos.x+random(-2, 2), pos.y+random(-2, 2));
      strokeWeight(random(2, 4)); 
      point(pos.x+random(-2, 2), pos.y+random(-2, 2));
    }
  }
  
  boolean readyToExplode() {
    return (isLaunching && vel.y > 0);
  }
}
