(function () {
    if (typeof Asteroids === "undefined") {
        window.Asteroids = {};
    }

    var Bullet = Asteroids.Bullet = function (options) {
        options.radius = 2;
        options.color = "#FF0000";

        Asteroids.MovingObject.call(this, options);
    };

    Asteroids.Util.inherits(Bullet, Asteroids.MovingObject);

    Bullet.prototype.collideWith = function (obj) {
        if (obj instanceof Asteroids.Asteroid) {
            this.game.remove(this);
            this.game.remove(obj);
        }
    };

    //Bullet.prototype.isWrappable = false;
})();
