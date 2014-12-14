(function () {
    if (typeof Asteroids === "undefined") {
        window.Asteroids = {};
    };

    var Ship = Asteroids.Ship = function (params) {
        params.radius = 15;
        params.vel = params.vel || [0, 0];
        params.color = "#FFFFFF";
        params.imgSrc = Ship.IMAGESRC;
        params.angle = 0;
        
        Asteroids.MovingObject.call(this, params)
    };

    Ship.IMAGESRC = "./images/ship.png";

    Asteroids.Util.inherits(Ship, Asteroids.MovingObject);

    Ship.prototype.relocate = function () {
        this.pos = this.game.randomPosition();
        this.vel = [0, 0];
    };

    Ship.prototype.power = function (impulse) {
        if (this.vel[0] * impulse[0] > 0) {
            factor = (100.0 - (this.vel[0] * this.vel[0])) / 100.0;
            this.vel[0] += impulse[0] * factor;
        } else {
            this.vel[0] += impulse[0];
        }
        if (this.vel[1] * impulse[1] > 0) {
            factor = (100.0 - (this.vel[1] * this.vel[1])) / 100.0;
            this.vel[1] += impulse[1] * factor;
        } else {
            this.vel[1] += impulse[1];
        }
    };
    
    Ship.prototype.bulletVel = function () {
        var direction = Asteroids.Util.dir(this.vel);
        var relativeVel = Asteroids.Util.scale(direction, 15);
        var bulletVelX = relativeVel[0] + this.vel[0];
        var bulletVelY = relativeVel[1] + this.vel[1];
        return [bulletVelX, bulletVelY];
    };
    
    Ship.prototype.fireBullet = function () {
        var bullet = new Asteroids.Bullet({
            vel: this.bulletVel(),
            pos: this.pos,
            game: this.game
        });
        if (this.game.bullets.length < 15) {
            this.game.bullets.push(bullet);
        }
    }
})();
