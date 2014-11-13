(function () {
    if (typeof TTT === "undefined") {
        window.TTT = {};
    }

    var View = TTT.View = function (game, $canvas) {
        this.game = game;
        this.$grid = $canvas;
        this.currentPlayer = this.game.currentPlayer; 
    };
    
    View.prototype.start = function () {
        this.setupBoard();
        this.bindEvents();
    };
    
    View.prototype.bindEvents = function () {
        this.$grid.on("click", ".tile", this.makeMove.bind(this));
    };

    View.prototype.makeMove = function (event) {
        //change color of tile
        var $tile = $(event.currentTarget);
        $tile.off("click");
        var pos = $tile.data("pos");  
        
        try {
            this.game.playMove(pos);
        }
        catch(err) {
            alert("Invalid move");
        }
             
        if (this.game.currentPlayer === "o")
        {
            $tile.addClass("x");
            $tile.html("<div class='mark'>X</div>");
        } else {
            $tile.addClass("o");
            $tile.html("<div class='mark'>O</div>");
        }
        
        if (this.game.winner() !== null) 
        {
            alert(this.game.winner() + " wins!");
        }
        
    };

    View.prototype.setupBoard = function () {
        var megaString = ""; 
        
        for (var i = 0; i < 3; i++){
            for (var j = 0; j < 3; j++){
                // var pos = [i, j].join(", ")
                megaString += ["<div class='tile' data-pos=[", i,",", j, "] ></div>"]
                .join("");
            };
        };
        
        // _.times(9, function (){
        //     megaString += "<div class='tile' data-pos=[i,j] ></div>"
        // });
                  
        this.$grid.html(megaString); 
    };
})();
