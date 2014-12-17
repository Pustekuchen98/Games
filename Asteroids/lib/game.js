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
            pos: [300,200],
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
        for (var i = 0; i < 5; i++) {
            asteroids.push(
                Asteroids.Asteroid.randomAsteroid(xDim, yDim, game)
            );
        }
        
        return asteroids;
    };
    
    Game.prototype.draw = function (ctx) {
        ctx.clearRect(0, 0, this.xDim, this.yDim);

        ctx.drawImage(background,0,0,this.xDim,this.yDim);   
        this.allObjects().forEach(function (obj) {
            obj.draw(ctx);
        });
        
    };
    
    Game.prototype.moveObjects = function () {
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
        for (var i = 0; i < game.allObjects().length; i++) {
            obj1 = game.allObjects()[i]
                for (var j = i + 1; j < game.allObjects().length; j++) {
                    obj2 = game.allObjects()[j];
                    if (obj1.isCollidedWith(obj2)) {
                        if (obj2 instanceof Asteroids.Ship && obj1 instanceof Asteroids.Asteroid) {
                            clearInterval(this.id);
                            document.getElementById('death').className = "alert show";
                            document.addEventListener('keydown', restart);
                        } else if (obj2 instanceof Asteroids.Bullet && obj1 instanceof Asteroids.Asteroid) {
                            obj1.gotHitBy(obj2);
                        } else if (obj1 instanceof Asteroids.Bullet && obj2 instanceof Asteroids.Ship) {
                            return; 
                        } else if (obj1 instanceof Asteroids.Bullet && obj2 instanceof Asteroids.Bullet) {
                            return; 
                        } else {
                            obj1.collide(obj2);
                        }
                    }
                }
            }
        }
    
    Game.prototype.randomPosition = function () {
        var x = Math.random() * this.xDim;
        var y = Math.random() * this.yDim;
        return [x, y]
    }

})();
