package game.tiles;

import game.types.TilePos;
import h2d.Bitmap;
import h2d.Object;
import hxd.BitmapData;
import hxd.Res;

using Std;

class TileMap extends Object {
	public var startX:Int;
	public var startY:Int;
	public var sizeX:Int;
	public var sizeY:Int;

	var tiles:Map<Int, Map<Int, GameTile>>;

	public var trackStart:RailTile = null;

	public var stationPos:TilePos = null;

	public inline function inRangePos(pos:TilePos):Bool {
		return inRange(pos.tileX, pos.tileY);
	}

	public inline function inRange(tx:Int, ty:Int):Bool {
		return tx >= startX && ty >= startY && tx < startX + sizeX && ty < startY + sizeY;
	}

	public function setTile(tx:Int, ty:Int, tile:GameTile, ?setPos:Bool = true) {
		if (getTile(tx, ty) != null)
			getTile(tx, ty).remove();

		tile.map = this;

		if (setPos) {
			tile.pos = {
				tileX: tx,
				tileY: ty
			};
		}

		tiles[ty][tx] = tile;

		if (trackStart == null && stationPos == null && tile.is(Station)) {
			stationPos = {tileX: tx, tileY: ty};
		}

		if (tile != null) {
			tile.setPosition((tx - startX) * 6, (ty - startY) * 6);
			addChild(tile);
		}
	}

	public function initStation() {
		if (stationPos != null) {
			var tx = stationPos.tileX;
			var ty = stationPos.tileY;

			trackStart = new RailTile();
			setTile(tx, ty + 2, trackStart);

			trackStart.next = new RailTile(trackStart);
			var next = trackStart.next;
			setTile(tx + 1, ty + 2, next);

			next.next = new RailTile(next);
			next = next.next;
			setTile(tx + 2, ty + 2, next);

			next.next = new RailTile(next);
			next = next.next;
			setTile(tx + 3, ty + 2, next);

			next.next = new RailTile(next);
			next = next.next;
			setTile(tx + 4, ty + 2, next);
		}
	}

	public function setTilePos(pos:TilePos, tile:GameTile, ?setPos:Bool = true) {
		setTile(pos.tileX, pos.tileY, tile, setPos);
	}

	public function getTile(tx:Int, ty:Int):GameTile {
		return inRange(tx, ty) ? tiles[ty][tx] : null;
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

		tiles = [
			for (row in startY...startY + sizeY)
				row => [
					for (col in startX...startX + sizeX)
						col => null
				]
		];
	}

	public function getTrack():Array<RailTile> {
		var result = [];

		var next = trackStart;

		while (next != null) {
			result.push(next);
			next = next.next;
		}

		return result;
	}

	public static function fromSegment(segment:BitmapData, ?startX:Int = 0, ?startY:Int = 0, ?parent, ?onTile:GameTile->Bool):TileMap {
		var map = new TileMap(startX, startY, segment.width, segment.height, parent);

		segment.lock();
		for (px in 0...segment.width) {
			for (py in 0...segment.height) {
				var tile = GameTile.colorFactory(segment.getPixel(px, py));

				var tx = startX + px;
				var ty = startY + py;

				if (tile != null) {
					tile.pos = {tileX: tx, tileY: ty};
					if (onTile != null) {
						if (onTile(tile)) {
							map.setTile(tx, ty, tile);
						}
					} else {
						map.setTile(tx, ty, tile);
					}
				}
			}
		}
		segment.unlock();

		map.initStation();

		return map;
	}
}
