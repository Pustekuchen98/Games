//function Sprite(url, pos, size, speed, frames, dir, once) {
    //this.pos = pos;
    //this.size = size;
    //this.speed = typeof speed === 'number' ? speed : 0;
    //this.frames = frames;
    //this._index = 0;
    //this.url = url;
    //this.dir = dir || 'horizontal';
    //this.once = once;
//}

//Sprite.prototype.update = function(dt) {
    //this._index += this.speed*dt;
//};

//Sprite.prototype.render = function(ctx) {
    //var frame;

    //if(this.speed > 0) {
        //var max = this.frames.length;
        //var idx = Math.floor(this._index);
        //frame = this.frames[idx % max];

        //if(this.once && idx >= max) {
            //this.done = true;
            //return;
        //}
    //}
    //else {
        //frame = 0;
    //}


    //var x = this.pos[0];
    //var y = this.pos[1];

    //if(this.dir == 'vertical') {
        //y += frame * this.size[1];
    //}
    //else {
        //x += frame * this.size[0];
    //}

    //ctx.drawImage(resources.get(this.url),
            //x, y,
            //this.size[0], this.size[1],
            //0, 0,
            //this.size[0], this.size[1]);
//}

function Sprite (options) {
    this.frameIndex = 0;
    this.tickCount = 0;
    this.ticksPerFrame = options.ticksPerFrame || 0;
    this.numberOfFrames = options.numberOfFrames || 1;

    this.context = options.context;
    this.width = options.width;
    this.height = options.height;
    this.image = options.image;
}

Sprite.prototype.update = function () {

        this.tickCount += 1;

        if (this.tickCount > this.ticksPerFrame) {

            this.tickCount = 0;

            // If the current frame index is in range
            if (this.frameIndex < this.numberOfFrames - 1) {	
                // Go to the next frame
                this.frameIndex += 1;
            } else {
                this.frameIndex = 0;
            }
        }
};

Sprite.prototype.render = function () {

        // Clear the canvas
        this.context.clearRect(0, 0, this.width, this.height);

        // Draw the animation
        this.context.drawImage(
                this.image,
                this.frameIndex * this.width / this.numberOfFrames,
                0,
                this.width / this.numberOfFrames,
                this.height,
                0,
                0,
                this.width / this.numberOfFrames,
                this.height);
};

