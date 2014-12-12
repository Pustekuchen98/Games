(function () {
    if (typeof Asteroids === "undefined") {
        window.Asteroids = {};
    }
    
    var Game = Asteroids.Game = function (xDim, yDim) {
        this.xDim = xDim;        
        this.yDim = yDim;
        this.asteroids = this.addAsteroids(xDim, yDim);
        this.ship = new Asteroids.Ship({
            pos: [200, 200],
            game: this
        }) 
    };
    
    Game.prototype.allObjects = function () {
        return [].concat(this.asteroids).concat([this.ship])
    };

    Game.prototype.step = function () {
        this.moveObjects();
        this.checkCollisions();
    };

    Game.prototype.addAsteroids = function (xDim, yDim) {
        var asteroids = [];
        var game = this; 
        for (var i = 0; i < 5; i++) {
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
        
        this.allObjects().forEach(function (asteroid) {
            asteroid.draw(ctx);
        });
        
    };
    
    Game.prototype.moveObjects = function () {
        // console.log(this.asteroids);
        this.allObjects().forEach(function (asteroid) {
            asteroid.move();
        });
    };
    
    Game.prototype.wrap = function (pos) {
        var x, y;
        x = this.xDim;
        y = this.yDim;
        if (pos[0] < 0) {
            x = this.xDim;
            y = Math.abs(pos[1]-this.yDim);
        } else if (pos[0] > this.xDim) {
            x = 0;
            y = Math.abs(pos[1]-this.yDim);
        } else if (pos[1] < 0) {
            x = Math.abs(pos[0] - this.xDim);
            y = this.yDim;
        } else if (pos[1] > this.yDim) {
            x = Math.abs(pos[0] - this.xDim);
            y = 0;
        } else {
            x = pos[0];
            y = pos[1];
        }
        return [x, y];
    };

    Game.prototype.checkCollisions = function () {
        var game = this;
        game.allObjects().forEach(function (obj1) {
            game.allObjects().forEach(function (obj2) {
                if (obj1 == obj2) {
                    return;
                }

                if (obj1.isCollidedWith(obj2)) {
                    if (obj2 instanceof Asteroids.Ship) {
                        obj2.relocate();
                    } else {
                        console.log("oops!!!")
                        game.remove(obj1);
                        game.remove(obj2);
                    }
                }
            })
        }) 
    };

    Game.prototype.remove = function (asteroid) {
        var xDim = this.xDim;
        var yDim = this.yDim;
        var game = this;
        var index = this.asteroids.indexOf(asteroid);
        this.asteroids[index] = new Asteroids.Asteroid.randomAsteroid(xDim, yDim, game);
    };

    Game.prototype.randomPosition = function () {
        var x = Math.random() * this.xDim;
        var y = Math.random() * this.yDim;
        return [x, y]
    }

})();
