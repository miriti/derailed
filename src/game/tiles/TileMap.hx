package game.tiles;

import game.types.TilePos;
import h2d.Object;

class TileMap extends Object {
	public var startX:Int;
	public var startY:Int;
	public var sizeX:Int;
	public var sizeY:Int;

	var tiles:Array<Array<GameTile>>;

	public function inRange(pos:TilePos):Bool {
		return pos.tileX >= 0 && pos.tileY >= 0 && pos.tileX < sizeX && pos.tileY < sizeY;
	}

	public function setTile(tx:Int, ty:Int, tile:GameTile) {
		if (getTile(tx, ty) != null)
			getTile(tx, ty).remove();

		tile.pos = {
			tileX: tx,
			tileY: ty
		};
		tiles[ty][tx] = tile;

		if (tile != null) {
			tile.setPosition(tx * 6, ty * 6);
			addChild(tile);
		}
	}

	public function setTilePos(pos:TilePos, tile:GameTile) {
		setTile(pos.tileX, pos.tileY, tile);
	}

	public function getTile(tx:Int, ty:Int):GameTile {
		return tiles[ty][tx];
	}

	public function getTilePos(pos:TilePos):GameTile {
		return getTile(pos.tileX, pos.tileY);
	}

	public function new(startX:Int, startY:Int, sizeX:Int, sizeY:Int, ?parent) {
		super(parent);
		this.startX = startX;
		this.startY = startY;

		this.sizeX = sizeX;
		this.sizeY = sizeY;

		tiles = [for (_ in 0...sizeY) [for (_ in 0...sizeX) null]];
	}
}
