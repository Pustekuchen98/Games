(function () {
    if (typeof Asteroids === "undefined") {
        window.Asteroids = {};
    }

    var Asteroid = Asteroids.Asteroid = function (params) {
        Asteroids.MovingObject.call(this, params);
        this.exploding = false;
    }

    Asteroid.IMAGESRC = "./images/asteroid.png";

    Asteroids.Util.inherits(Asteroid, Asteroids.MovingObject);

    Asteroid.prototype.gotHitBy = function (bullet) {
        this.game.remove(bullet);
        this.explode();
    };

    Asteroid.prototype.draw = function (ctx) {
        var image = this.image;
        var pos = this.pos;
        var radius = this.radius;
        ctx.drawImage(image, pos[0] - (1.7 * radius), pos[1] - (1.7 *radius), radius * 3.5, radius * 3.5);
    };

    Asteroid.prototype.explode = function () {
        this.radius = "0";
        this.spriteFrame = 1;
        this.spriteInterval = 0;
        this.spriteXDIM = 0;
        this.spriteYDIM = 0;
        this.explodeImg = new Image();
        this.explodeImg.src = ("./images/explosion.png");
        this.exploding = true;
        var that = this;
        setTimeout(function(){ that.remove() }, 2000);
    };

    Asteroid.prototype.remove = function () {
        var game = this.game;
        var xDim = game.xDim;
        var yDim = game.yDim;
        var index = game.asteroids.indexOf(this);
        game.asteroids[index] = new Asteroids.Asteroid.randomAsteroid(xDim, yDim, game);
    };

    Asteroid.prototype.collide = function (anotherAsteroid) {
        var vel = this.vel;
        this.vel = anotherAsteroid.vel;
        anotherAsteroid.vel = vel;
    };

    Asteroid.randomAsteroid = function (maxX, maxY, game) {
        return new Asteroid({
            pos: [maxX * Math.random(), maxY * Math.random()],
               vel: Asteroids.Util.randomVec(Math.random() * 5),
               radius: Math.random() * (50 - 20) + 20,
               color: "#FFFFFF",
               game: game,
               imgSrc: Asteroid.IMAGESRC
        })
    }
})();
