package game.tiles;

import game.types.TilePos;
import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;
import hxd.Res;

class GameTile extends Object {
	public var map:TileMap;
	public var pos:TilePos;

	public var passable:Bool = true;

	public var image(get, never):Bitmap;

	function get_image():Bitmap
		return null;

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

	public static function colorFactory(color:Int):GameTile {
		switch (color) {
			case 0xff0000ff:
				return new RailTile();
			case 0xffffff00:
				return new Station();
			case 0xff00ff00:
				return new TreeTile();
			case 0xff000000:
				return new RockTile();
		}

		return new EmptyTile();
	}
}
