(function () {
    if (typeof Asteroids === "undefined") {
        window.Asteroids = {};
    }
    
    var Game = Asteroids.Game = function (xDim, yDim) {
        this.xDim = xDim;        
        this.yDim = yDim;
        this.asteroids = this.addAsteroids(xDim, yDim);
        this.bullets = this.bullets || [];
    };
    
    Game.prototype.makeShip = function () {
        this.ship = new Asteroids.Ship({
            pos: this.randomPosition(),
            game: this
        }) 
        return this.ship;
    };

    Game.prototype.allObjects = function () {
        return [].concat(this.asteroids).concat(this.bullets).concat([this.ship])
    };

    Game.prototype.step = function () {
        this.moveObjects();
        this.checkCollisions();
    };

    Game.prototype.addAsteroids = function (xDim, yDim) {
        var asteroids = [];
        var game = this; 
        for (var i = 0; i < 7; i++) {
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
        x = pos[0];
        y = pos[1];
        
        if (pos[0] < 0) { x = this.xDim; }
        else if (pos[0] > this.xDim) { x = 0; }

        if (pos[1] < 0) { y = this.yDim; }
        else if (pos[1] > this.yDim) { y = 0; }
        
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
                    if (obj2 instanceof Asteroids.Ship && obj1 instanceof Asteroids.Asteroid) {
                        clearInterval(this.game.id);
                        document.getElementById('death').className = "alert show";
                        document.addEventListener('keydown', restart);

                        obj2.relocate();
                        
                    } else if (obj1 instanceof Asteroids.Bullet) {
                        obj1.collideWith(obj2);
                    } else if (obj2 instanceof Asteroids.Bullet) {
                        obj2.collideWith(obj1);
                    } else {
                        console.log("oops!!!");
                        game.remove(obj1);
                        game.remove(obj2);
                    }
                }
            })
        }) 
    };

    Game.prototype.remove = function (obj) {
        if (obj instanceof Asteroids.Asteroid) {
            var xDim = this.xDim;
            var yDim = this.yDim;
            var game = this;
            var index = this.asteroids.indexOf(obj);
            this.asteroids[index] = new Asteroids.Asteroid.randomAsteroid(xDim, yDim, game);
        } else if (obj instanceof Asteroids.Bullet) {
            var index = this.bullets.indexOf(obj);
            this.bullets.splice(index, 1);
        }
    };

    Game.prototype.randomPosition = function () {
        var x = Math.random() * this.xDim;
        var y = Math.random() * this.yDim;
        return [x, y]
    }

})();
