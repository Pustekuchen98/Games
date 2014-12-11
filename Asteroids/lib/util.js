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
    
})();

// Asteroids.Util.inherits()