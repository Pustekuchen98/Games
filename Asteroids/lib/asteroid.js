(function () {
    if (typeof Asteroids === "undefined") {
        window.Asteroids = {};
    }
    
    var Asteroid = Asteroids.Asteroid = function (params) {
        Asteroids.MovingObject.call(this, params);
    }
    
    Asteroids.Util.inherits(Asteroid, Asteroids.MovingObject);
    
    var HEX_DIGITS = "0123456789ABCDEF"
    Asteroid.randomColor = function () {
      var color = "#";
      for (var i = 0; i < 6; i++) {
        color += HEX_DIGITS[Math.floor((Math.random() * 16))];
      }

      return color;
    };
    
    Asteroid.randomAsteroid = function (maxX, maxY) {
      return new Asteroid({
        pos: [maxX * Math.random(), maxY * Math.random()],
        vel: Asteroids.Util.randomVec(Math.random() * 10),
        radius: Math.random() * 40,
        color: Asteroid.randomColor()
      });
    };
})();