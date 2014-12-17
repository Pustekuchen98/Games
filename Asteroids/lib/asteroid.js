(function () {
    if (typeof Asteroids === "undefined") {
        window.Asteroids = {};
    }

    var Asteroid = Asteroids.Asteroid = function (params) {
        Asteroids.MovingObject.call(this, params);
        this.exploding = false;
        this.deactivate();
    };

    Asteroid.IMAGESRC = "./images/asteroid.png";

    Asteroids.Util.inherits(Asteroid, Asteroids.MovingObject);

    Asteroid.prototype.deactivate = function () {
        this.active = false;
        var that = this;
        setTimeout(function() { that.active = true }, 3000);
    };


    Asteroid.prototype.gotHitBy = function (bullet) {
        bullet.remove();
        this.explode();
    };

    Asteroid.prototype.draw = function (ctx) {
        if (!this.exploding) {
            var image = this.image;
            var pos = this.pos;
            var radius = this.radius;
            if (this.active) {
                ctx.drawImage(image, pos[0] - (1.7 * radius), pos[1] - (1.7 *radius), radius * 3.5, radius * 3.5);
            } else {
                ctx.globalAlpha = 0.6;
                ctx.drawImage(image, pos[0] - (1.7 * radius), pos[1] - (1.7 *radius), radius * 3.5, radius * 3.5);
                ctx.globalAlpha = 1;
            }
        } else {
            this.animateSprite();
        }
    };

    Asteroid.prototype.explode = function () {
        this.spriteRadius = this.radius;
        this.vel = [0, 0];
        this.radius = 0;
        this.active = false;
        this.spriteFrame = 1;
        this.spriteInterval = 0;
        this.spriteSX = 0;
        this.spriteSY = 0;
        this.explodeImg = new Image();
        this.explodeImg.src = ("./images/explosion.png");
        this.exploding = true;
        var that = this;
        setTimeout(function(){ that.remove() }, 2000);
    };

    Asteroid.prototype.animateSprite = function() {
        var dx = this.pos[0] - (1.7 * this.spriteRadius);
        var dy = this.pos[1] - (1.7 * this.spriteRadius);
        var dw = this.spriteRadius * 3.5;
        if (this.spriteFrame <= 40) {
            if (this.spriteInterval % 4 === 0) {
                this.spriteSX += 93;

                if (this.spriteFrame % 10 === 0) {
                    this.spriteSX = 0;
                    this.spriteSY += 100;
                }

                this.spriteFrame += 1;
            }
            this.spriteInterval += 1
        }
        ctx.drawImage(this.explodeImg, this.spriteSX, this.spriteSY, 93, 100, dx, dy, dw, dw);
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
