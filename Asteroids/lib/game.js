(function () {
    if (typeof Asteroids === "undefined") {
        window.Asteroids = {};
    }
    
    var Game = Asteroids.Game = function (xDim, yDim) {
        this.xDim = xDim;        
        this.yDim = yDim;
        // this.asteroids = [];
        this.asteroids = Game.addAsteroids(xDim, yDim);
    };
    
    Game.addAsteroids = function (xDim, yDim) {
        var asteroids = [];
        var game = this; 
        for (var i = 0; i < 100; i++) {
            asteroids.push(
                Asteroids.Asteroid.randomAsteroid(xDim, yDim, game)
            );
        }
        
        return asteroids;
    };
    
    Game.prototype.draw = function (ctx) {
        ctx.clearRect(0, 0, this.xDim, this.yDim);
        ctx.fillStyle = "#000000";
        ctx.fillRect(0,0, canvasEl.width, canvasEl.height);
        
        this.asteroids.forEach(function (asteroid) {
            asteroid.draw(ctx);
        });
        
    };
    
    Game.prototype.moveObjects = function () {
        // console.log(this.asteroids);
        this.asteroids.forEach(function (asteroid) {
            asteroid.move();
        });
    }
    
    Game.prototype.wrap = function (pos) {
        var x, y;
        if (pos[0] === 0) {
            x = this.xDim;
            y = Math.abs(pos[1]-this.yDim);
        } else if (pos[0] === this.xDim) {
            x = 0;
            y = Math.abs(pos[1]-this.yDim);
        } else if (pos[1] === 0) {
            x = Math.abs(pos[0] - this.xDim);
            y = this.yDim;
        } else if (pos[1] === this.yDim) {
            x = Math.abs(pos[0] - this.xDim);
            y = 0;
        } else {
            x = pos[0];
            y = pos[1];
        }
        
        return [x, y];
    }
})();
