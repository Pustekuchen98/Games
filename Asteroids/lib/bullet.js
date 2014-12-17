(function () {
    if (typeof Asteroids === "undefined") {
        window.Asteroids = {};
    }

    var Bullet = Asteroids.Bullet = function (options) {
        options.radius = 3;
        options.color = "#FF0000";

        Asteroids.MovingObject.call(this, options);
    };

    Asteroids.Util.inherits(Bullet, Asteroids.MovingObject);

    Bullet.prototype.draw = function (ctx) {
        ctx.fillStyle = this.color;
        ctx.beginPath();

        ctx.arc(
          this.pos[0],
          this.pos[1],
          this.radius,
          0,
          2 * Math.PI
        );

        ctx.fill();
    };

    Bullet.prototype.remove = function () {
        var index = this.game.bullets.indexOf(this);
        this.game.bullets.splice(index, 1);
    };

})();
