package game.train;

import game.tiles.GameTile;
import game.types.TilePos;
import h2d.Bitmap;
import hxd.Res;

class Car extends GameObject {
	public var speed:Float = 0.0;
	public var tilePos(default, set):Float;

	function set_tilePos(value:Float):Float {
		while (value > 1) {
			value -= 1;
			trackTile++;

			if (trackTile == track.length) {
				// crush

				return tilePos;
			}
		}

		var fromPos = track[trackTile];
		var toPos:TilePos = trackTile < track.length - 1 ? track[trackTile + 1] : {tileX: fromPos.tileX + 1, tileY: fromPos.tileY};

		if (fromPos.tileY == toPos.tileY) {
			rotation = 0;
		} else {
			rotation = Math.PI / 2;
		}

		var fromX = fromPos.tileX * GameTile.SIZE + GameTile.SIZE / 2;
		var fromY = fromPos.tileY * GameTile.SIZE + GameTile.SIZE / 2;

		var toX = toPos.tileX * GameTile.SIZE + GameTile.SIZE / 2;
		var toY = toPos.tileY * GameTile.SIZE + GameTile.SIZE / 2;

		fx = fromX + (toX - fromX) * value;
		fy = fromY + (toY - fromY) * value;

		return tilePos = value;
	}

	var track:Array<TilePos>;

	var trackTile:Int;

	var image:Bitmap;

	public function new(?parent) {
		super(parent);

		image = new Bitmap(Res.tiles.toTile().sub(0, 6 * GameTile.SIZE, 12, 6), this);
		image.x = -image.getBounds().width / 2;
		image.y = -image.getBounds().height / 2;
	}

	public function setTrack(track:Array<TilePos>, ?start:Int = 0) {
		this.track = track;
		this.trackTile = start;

		tilePos = 0;
	}

	override function update(dt:Float) {
		tilePos += speed * dt;
	}
}
