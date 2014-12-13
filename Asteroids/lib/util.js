(function () {
    if (typeof Asteroids === "undefined") {
        window.Asteroids = {};
    }

    var Util = Asteroids.Util = {}; //function () {
    // };

    Util.inherits = function (childClass, superClass) {
        function Surrogate() {};
        Surrogate.prototype = superClass.prototype
    childClass.prototype = new Surrogate();
    };

    Util.randomVec = function (len) {
        var x = 2 * (Math.random() - 0.5);
        var y = 2 * (Math.random() - 0.5);
        // x**2 + y**2 === length**2
        var a = Math.sqrt(Math.pow(len, 2) / 
            (Math.pow(x, 2) + Math.pow(y, 2)));
        return [a * x, a * y];
    };

    Util.distance = function(pos1, pos2) {
        return Math.sqrt(
                Math.pow(pos1[0] - pos2[0], 2) + Math.pow(pos1[1] - pos2[1], 2)
                )
    };
    
    // Normalize the length of the vector to 1, maintaining direction.
    Util.dir = function (vec) {
        var norm = Util.norm(vec);
        if (norm === 0) {
            return [0, 1];
        }
        return Util.scale(vec, 1 / norm);
    };

    // Find the length of the vector.
    Util.norm = function (vec) {
        return Util.distance([0, 0], vec);
    };
    
    Util.scale = function (vec, constant) {
        return [vec[0] * constant, vec[1] * constant]
    }

})();


