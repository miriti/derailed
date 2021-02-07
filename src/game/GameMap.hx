package game;

import game.types.TilePos;
import game.tiles.GameTile;
import game.tiles.TileMap;
import h2d.Object;

class GameMap extends Object {
	var chunks:Array<TileMap> = [];

	public var nextStartX(get, never):Int;

	function get_nextStartX() {
		return chunks.length > 0 ? chunks[chunks.length - 1].startX + chunks[chunks.length - 1].sizeX : 0;
	}

	public var nextStartY(get, never):Int;

	function get_nextStartY() {
		return 0;
	}

	public function new(?parent) {
		super(parent);
	}

	public function pushTileMap(tileMap:TileMap) {
		chunks.push(tileMap);

		tileMap.setPosition(tileMap.startX * 6, 0);

		addChild(tileMap);
	}

	public function getChunk(tx:Int, ty:Int):TileMap {
		for (chunk in chunks) {
			if (chunk.inRange(tx, ty))
				return chunk;
		}

		return null;
	}

	public function getTilePos(pos:TilePos) {
		return getTile(pos.tileX, pos.tileY);
	}

	public function getTile(tx:Int, ty:Int):GameTile {
		var chunk = getChunk(tx, ty);

		if (chunk != null) {
			return chunk.getTile(tx, ty);
		}

		return null;
	}

	public function setTilePos(pos:TilePos, tile:GameTile, ?setPos:Bool = true) {
		var chunk = getChunk(pos.tileX, pos.tileY);

		if (chunk != null)
			chunk.setTilePos(pos, tile, setPos);
	}

	public function setTile(tx:Int, ty:Int, tile:GameTile, ?setPos:Bool = true) {
		var chunk = getChunk(tx, ty);

		if (chunk != null)
			chunk.setTile(tx, ty, tile, setPos);
	}
}
