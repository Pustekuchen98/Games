(function () {
    if (typeof Asteroids === "undefined") {
        window.Asteroids = {};
    }

    var Bullet = Asteroids.Bullet = function (options) {
        options.radius = 2;
        options.color = "#FFFFFF";

        Asteroids.MovingObject.call(this, options);
    };

    Bullet.SPEED = 15;

    Asteroids.Util.inherits(Bullet, Asteroids.MovingObject);

    Bullet.prototype.collideWith = function (obj) {
        if (obj instanceof Asteroids.Asteroid) {
            this.remove();
            obj.remove();
        }
    };

    Bullet.prototype.isWrappable = false;
})();
