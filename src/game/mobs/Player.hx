package game.mobs;

import h2d.Tile;
import game.carrying.Carry;
import game.carrying.Tool;
import game.tiles.CommodityTile;
import game.tiles.GameTile;
import game.tiles.RockTile;
import game.types.Dir;
import game.types.TilePos;
import h2d.Bitmap;

class Player extends Mob {
	static final HARVEST_TIME:Float = 0.5;
	static final FRAME_TIME:Float = 0.1;
	static final MOVE_SPEED:Float = 3.5;

	public var actionDirection:Dir = {dx: 1, dy: 0};
	public var moveDirection(default, set):Dir;

	function set_moveDirection(value:Dir) {
		if (value.dx != 0 || value.dy != 0)
			actionDirection = value;
		return moveDirection = value;
	}

	public var actionTilePos(get, never):TilePos;

	function get_actionTilePos():TilePos {
		return {
			tileX: Math.floor((fx + actionDirection.dx * 5) / 6),
			tileY: Math.floor((fy + actionDirection.dy * 5) / 6)
		};
	}

	var animFrames:Array<Bitmap>;

	var frameTime:Float;

	var currentAnimFrame(default, set):Int = 0;

	var idle:Bool = true;

	public var carrying(default, set):Carry = null;

	var carryingDisplay:Bitmap;

	public var carryingDisplaySnap:TilePos = null;

	function set_carrying(value:Carry) {
		carrying = value;

		if (carrying != null) {
			carryingDisplay.tile = carrying.image.tile;
			carryingDisplay.visible = true;
		} else {
			carryingDisplay.visible = false;
		}

		return carrying;
	}

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

		carryingDisplay = new Bitmap(parent);
		carryingDisplay.visible = false;

		animFrames = [
			new Bitmap(GameTile.getBmp(0, 4), this),
			new Bitmap(GameTile.getBmp(1, 4), this),
			new Bitmap(GameTile.getBmp(2, 4), this),
		];

		for (frame in animFrames) {
			frame.x = -3;
			frame.y = -3;
		}

		currentAnimFrame = 0;

		var centerDebug = new Bitmap(Tile.fromColor(0xff0000, 1, 1), this);
		centerDebug.visible = false;
	}

	var harvestDelay:Float = HARVEST_TIME;

	var toolAnimDelay:Float = 0;
	var toolAnimState:Bool = true;

	override function update(dt:Float) {
		if (moveDirection.dx != 0 || moveDirection.dy != 0) {
			idle = false;

			moveTile(moveDirection.dx * MOVE_SPEED * dt, moveDirection.dy * MOVE_SPEED * dt);

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

		if (carryingDisplaySnap != null) {
			carryingDisplay.x = carryingDisplaySnap.tileX * 6;
			carryingDisplay.y = carryingDisplaySnap.tileY * 6;
		} else {
			carryingDisplay.x = Math.floor(fx + actionDirection.dx * 5 - 3);
			carryingDisplay.y = Math.floor(fy + actionDirection.dy * 5 - 3);
		}

		if (Std.is(carrying, Tool)) {
			var tool:Tool = cast carrying;
			var actTile = map.getTilePos(actionTilePos);

			if (actTile != null && Std.is(actTile, CommodityTile) && Std.is(actTile, tool.commodityClass)) {
				var commodityTile = cast(actTile, CommodityTile);

				if (!commodityTile.harvested) {
					if (toolAnimDelay <= 0) {
						carryingDisplay.tile = toolAnimState ? tool.actionImage : tool.image.tile;
						toolAnimState = !toolAnimState;
						toolAnimDelay = 0.2;
					} else {
						toolAnimDelay -= dt;
						if (toolAnimDelay < 0)
							toolAnimDelay = 0;
					}

					if (harvestDelay <= 0) {
						commodityTile.hit();

						if (Std.is(commodityTile, RockTile)) {
							// Res.sound.pickaxe.play();
						}

						harvestDelay = HARVEST_TIME;
					} else {
						harvestDelay -= dt;
						if (harvestDelay < 0)
							harvestDelay = 0;
					}
				}
			}
		}
	}
}
