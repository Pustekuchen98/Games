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
    }

    //Bullet.prototype.collideWith = function (obj) {
        //if (obj instanceof Asteroids.Asteroid) {
            //this.game.remove(this);
            //this.game.remove(obj);
        //}
    //};

    //Bullet.prototype.isWrappable = false;
})();
