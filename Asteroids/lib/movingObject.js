(function () {
    if (typeof Asteroids === "undefined") {
        window.Asteroids = {};
    }
    
    var MovingObject = Asteroids.MovingObject = function(params) {
        this.pos = params["pos"];
        this.vel = params["vel"];
        this.radius = params["radius"];
        this.color = params["color"];
        this.game = params["game"];
    }
    
    MovingObject.prototype.draw = function (ctx) {
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
    
    MovingObject.prototype.move = function () {
        this.pos[0] += this.vel[0]; 
        this.pos[1] += this.vel[1];
        this.pos = this.game.wrap(this.pos);
    }

    MovingObject.prototype.isCollidedWith = function (otherObject) {
        var sum = this.radius + otherObject.radius;
        var distance = Asteroids.Util.distance(this.pos, otherObject.pos);
        if (distance - sum < 0) {
            return true;
        } else {
            return false;
        }
    }
})();
