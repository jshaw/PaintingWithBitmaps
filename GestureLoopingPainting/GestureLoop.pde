
class GesturePoint {

  GesturePoint( float x, float y, long time ) {

    this.point = new PVector(x, y);
    this.time = time;
  }

  PVector point;
  long time;
}

class GestureLoop {

  GestureLoop() {

    points = new ArrayList<GesturePoint>();
    loopPoints = new ArrayList<Integer>();
    isDrawing = false;
    loopLengthMs = 2000;
  }

  void draw() {

    if ( isDrawing ) {

      drawDebug();
      
    } else if ( isLooping ) {

      drawLoop();

      int nPts = points.size();

      if ( points.size() > 0 ) {

        fill(0);

        //ellipse( points.get(currentPos).point.x, points.get(currentPos).point.y, 5, 5);

        long now = millis();
        long elapsed = (long)(1.0 * (now - loopStartMs));

        //println("elapsed " + elapsed);
        //println("test " + points.get(currentPos+1).time);

        if ( currentPos < nPts -2 && elapsed >= points.get(currentPos+1).time ) {

          currentPos++;
          loopPoints.add( currentPos );

          //println("up | currentPos " + currentPos);
        } 

        if ( loopPoints.size() > 0 ) {

          long headTime = elapsed;
          long pointTime = points.get(loopPoints.get(0)).time;

          //println( headTime - pointTime + " vs " + loopLengthMs);
          // println( gestureDurMs );

          if ( headTime - pointTime > loopLengthMs ) {

            loopPoints.remove(0);
          }

          if ( loopPoints.size() == 0) {

            loop();
          }
        }
      }
    }
  }
  
  ArrayList<PVector> getPoints(){
   
      ArrayList<PVector> pts = new ArrayList<PVector>();
      
      for ( Integer lp : loopPoints ) {

          GesturePoint g = points.get(lp);

          pts.add( new PVector(g.point.x, g.point.y) );
     
      }
    
     return pts;
  }

  void drawDebug() {

    noFill();
    stroke(0);

    beginShape();

    for ( GesturePoint p : points ) {
      vertex( p.point.x, p.point.y );
    }

    endShape();
  }

  void drawLoop() {

    noFill();
    stroke(0);

/*
    beginShape();

    for ( Integer lp : loopPoints ) {

      GesturePoint g = points.get(lp);

      vertex( g.point.x, g.point.y );
    }

    endShape();
    */
  }

  void start(float x, float y) {

    points.clear();

    points.add( new GesturePoint(x, y, 0) );

    gestureStartMs = millis();
    isDrawing = true;
  }

  void addPoint( float x, float y) {

    long elapsed = millis() - gestureStartMs;

    points.add( new GesturePoint(x, y, elapsed) );
  }

  void stop() {

    gestureDurMs = millis() - gestureStartMs;
    isDrawing = false;
  }

  void loop() {

    isLooping = true;
    loopStartMs = millis();
    currentPos = 0;

    loopPoints.clear();
    loopPoints.add( currentPos );
  }

  ArrayList<GesturePoint> points;
  ArrayList<Integer> loopPoints;

  long gestureDurMs;
  long gestureStartMs;
  int currentPos;

  long loopStartMs;
  long loopLengthMs;

  boolean isDrawing;
  boolean isLooping;
}