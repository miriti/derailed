package game.mobs;

import game.tiles.TileMap;
import game.types.TilePos;

class Mob extends GameObject {
	public var maps:Array<TileMap>;

	public var tileX(default, set):Float;

	function set_tileX(value:Float):Float {
		fx = value * 6 + 3;
		return tileX = value;
	}

	public var tileY(default, set):Float;

	function set_tileY(value:Float):Float {
		fy = value * 6 + 3;
		return tileY = value;
	}

	public var tilePos(get, set):TilePos;

	function get_tilePos():TilePos {
		return {
			tileX: Math.floor(tileX),
			tileY: Math.floor(tileY)
		};
	}

	function set_tilePos(value:TilePos) {
		tileX = value.tileX;
		tileY = value.tileY;
		return tilePos;
	}

	public var map:GameMap;

	public function moveTile(tx:Float, ty:Float) {
		var toTile:TilePos = {tileX: Math.floor(tileX + tx), tileY: Math.floor(tileY + ty)};
		var tile = map.getTilePos(toTile);
		if (tile == null || tile.passable) {
			tileX += tx;
			tileY += ty;
		}
	}

	public function new(?parent) {
		super(parent);
	}
}
