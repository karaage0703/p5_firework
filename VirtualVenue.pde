class VirtualVenue {
  VirtualVenue() {
  }

  PVector launch_coords () {
    float x = random(width*1/10,width*9/10);
    float y = height;
    return (new PVector(x, y));
  }
}
