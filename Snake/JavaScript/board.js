// Following Tutorial at http://snake-tutorial.zeespencer.com/

var BOARD = {
  canvasWidth: 800,
  canvasHeight: 600,
  pixelSize: 40,
  KEY_MAPPING: {
    39: "right",
    40: "down",
    37: "left",
    38: "up"
  },
  attrs: {},
  gameHeight: function() {
    return this.attrs.gameHeight || (this.attrs.gameHeight = this.canvasHeight / this.pixelSize);
  },
  gameWidth: function() {
    return this.attrs.gameWidth || (this.attrs.gameWidth = this.canvasWidth / this.pixelSize);
  },
  canvas: function() {
    if (BOARD.context) { return BOARD.context; }
    var canvas = document.getElementById("board-game");
    BOARD.context = canvas.getContext("2d");
    return BOARD.context;
  },
  executeNTimesPerSecond: function(tickCallback, gameSpeed) {
    tickCallback();
    BOARD.processID = setInterval(function() {
      tickCallback();
    }, 1000 / gameSpeed);
  },
  onArrowKey: function(callback) {
    document.addEventListener('keydown', function(e) {
      if (BOARD.KEY_MAPPING[e.which]) {
        callback(BOARD.KEY_MAPPING[e.which]);
      }
    });
  },
  endGame: function() {
    clearInterval(BOARD.processID);
  },
  draw: function(objects) {
   BOARD.clear();
   BOARD.drawObjects(objects);
  },
  clear: function() {
    BOARD.canvas().clearRect(0, 0, BOARD.canvasWidth, BOARD.canvasHeight);
  },
  drawObjects: function(objects) {
    var ui = this;
    objects.forEach(function(object) {
      object.pixels.forEach(function(pixel) {
        ui.drawPixel(object.color, pixel);
      });
    });
  },
  drawPixel: function(color, pixel) {
    BOARD.canvas().fillStyle = color;
    var translatedPixel = BOARD.translatePixel(pixel);
    BOARD.context.fillRect(translatedPixel.left, translatedPixel.top, BOARD.pixelSize, BOARD.pixelSize);
  },
  translatePixel: function(pixel) {
    return { left: pixel.left * BOARD.pixelSize,
             top: pixel.top * BOARD.pixelSize }
  },
  gameBoundaries: function() {
    if (this.attrs.boundaries) { return this.attrs.boundaries; }
    this.attrs.boundaries = [];
    for (var top = -1; top <= BOARD.gameHeight(); top++) {
      this.attrs.boundaries.push({ top: top, left: -1});
      this.attrs.boundaries.push({ top: top, left: this.gameWidth() + 1});
    }
    for (var left = -1; left <= BOARD.gameWidth(); left++) {
      this.attrs.boundaries.push({ top: -1, left: left});
      this.attrs.boundaries.push({ top: this.gameHeight() + 1, left: left });
    }
    return this.attrs.boundaries;
  },
  detectCollisionBetween: function(objectA, objectB) {
    return objectA.some(function(pixelA) {
      return objectB.some(function(pixelB) {
        return pixelB.top === pixelA.top && pixelB.left === pixelA.left;
      });
    });
  },
  randomLocation: function() {
    return {
      top: Math.floor(Math.random()*BOARD.gameHeight()),
      left: Math.floor(Math.random()*BOARD.gameWidth()),
    }
  },
  flashMessage: function(message) {
    var canvas = document.getElementById("board-game");
    var context = canvas.getContext('2d');
    context.font = '20pt Calibri';
    context.fillStyle = 'yellow';
    context.fillText(message, 275, 100);
  }
}
