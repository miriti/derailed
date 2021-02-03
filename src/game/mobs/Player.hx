package game.mobs;

import game.tiles.GameTile;
import game.types.Dir;
import h2d.Bitmap;

class Player extends Mob {
	static final FRAME_TIME:Float = 0.1;
	static final MOVE_SPEED:Float = 20;

	public var moveDirection:Dir;

	var animFrames:Array<Bitmap>;

	var frameTime:Float;

	var currentAnimFrame(default, set):Int = 0;

	var idle:Bool = true;

	function set_currentAnimFrame(value:Int):Int {
		currentAnimFrame = value;

		if (currentAnimFrame >= animFrames.length)
			currentAnimFrame = 0;

		for (i in 0...animFrames.length)
			animFrames[i].visible = i == currentAnimFrame;

		return currentAnimFrame;
	}

	public function new(?parent) {
		super(parent);

		animFrames = [
			new Bitmap(GameTile.getBmp(0, 4), this),
			new Bitmap(GameTile.getBmp(1, 4), this),
			new Bitmap(GameTile.getBmp(2, 4), this),
		];

		currentAnimFrame = 0;
	}

	override function update(dt:Float) {
		if (moveDirection.dx != 0 || moveDirection.dy != 0) {
			idle = false;
			fx += moveDirection.dx * MOVE_SPEED * dt;
			fy += moveDirection.dy * MOVE_SPEED * dt;

			frameTime += dt;

			if (frameTime > FRAME_TIME) {
				currentAnimFrame++;

				if (currentAnimFrame == 0)
					currentAnimFrame = 1;
				frameTime = frameTime - FRAME_TIME;
			}
		} else if (!idle) {
			currentAnimFrame = 0;
			idle = true;
		}
	}
}
