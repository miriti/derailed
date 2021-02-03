package game.tiles;

import h2d.Object;
import game.types.TilePos;
import h2d.Bitmap;
import h2d.Tile;
import hxd.Res;

class GameTile extends Object {
	public var pos:TilePos;

	public static final SIZE:Int = 6;

	public static function getBmp(tx:Int, ty:Int):Tile {
		return Res.tiles.toTile().sub(tx * SIZE, ty * SIZE, SIZE, SIZE);
	}

	public static function get(tx:Int, ty:Int, ?parent):GameTile {
		return new GameTile(getBmp(tx, ty), parent);
	}

	public function new(tile:h2d.Tile, ?pos:TilePos, ?parent) {
		super(parent);

		this.pos = pos;

		if (tile != null)
			new Bitmap(tile, this);
	}
}
