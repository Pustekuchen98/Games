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
        if (params.imgSrc) {
            this.image = new Image();
            this.image.src = params.imgSrc;
        }
    }
    
    MovingObject.prototype.draw = function (ctx) {
        if (!this.image) {
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
        } else {
            var image = this.image;
            var pos = this.pos;
            var radius = this.radius;
            var radians = Math.atan2(this.vel[1], this.vel[0]);

            ctx.translate(pos[0], pos[1]);
            ctx.rotate(radians);
            ctx.drawImage(image, -radius, -radius, 60, 60);
            ctx.rotate(-radians);
            ctx.translate(-pos[0], -pos[1]);
        }
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
