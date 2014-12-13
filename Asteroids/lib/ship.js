(function () {
    if (typeof Asteroids === "undefined") {
        window.Asteroids = {};
    };

    var Ship = Asteroids.Ship = function (params) {
        params.radius = 15;
        params.vel = params.vel || [0, 0];
        params.color = "#FFFFFF"
        
        Asteroids.MovingObject.call(this, params)
    };

    Asteroids.Util.inherits(Ship, Asteroids.MovingObject);

    Ship.prototype.relocate = function () {
        this.pos = this.game.randomPosition();
        this.vel = [0, 0];
    };

    Ship.prototype.power = function (impulse) {
        if (this.vel[0] * impulse[0] <= 0 || Math.abs(this.vel[0]) < 10) {
            this.vel[0] += impulse[0];
        }
        if (this.vel[1] * impulse[1] <= 0 || Math.abs(this.vel[1]) < 10) {
            this.vel[1] += impulse[1];
        }
    };
})();
