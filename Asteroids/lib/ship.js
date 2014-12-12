(function () {
    if (typeof Asteroids === "undefined") {
        window.Asteroids = {};
    }

    var Ship = Asteroids.Ship = function (params) {
        params.radius = 15;
        params.vel = params.vel || [0, 0];
        params.color = "#FFFFFF"
        
        Asteroids.MovingObject.call(this, params)
    }

    Asteroids.Util.inherits(Ship, Asteroids.MovingObject);

})();
