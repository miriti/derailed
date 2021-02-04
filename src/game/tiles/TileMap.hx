package game.tiles;

import game.types.TilePos;
import h2d.Object;
import hxd.Res;

using Std;

class TileMap extends Object {
	public var startX:Int;
	public var startY:Int;
	public var sizeX:Int;
	public var sizeY:Int;

	var tiles:Array<Array<GameTile>>;

	var trackStart:RailTile = null;

	public function inRange(pos:TilePos):Bool {
		return pos.tileX >= 0 && pos.tileY >= 0 && pos.tileX < sizeX && pos.tileY < sizeY;
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

		if (trackStart == null && tile.is(Station)) {
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

		if (tile != null) {
			tile.setPosition(tx * 6, ty * 6);
			addChild(tile);
		}
	}

	public function setTilePos(pos:TilePos, tile:GameTile, ?setPos:Bool = true) {
		setTile(pos.tileX, pos.tileY, tile, setPos);
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

	public function getTrack():Array<RailTile> {
		var result = [];

		var next = trackStart;

		while (next != null) {
			result.push(next);
			next = next.next;
		}

		return result;
	}

	public static function fromSegment(?parent, ?onTile:GameTile->Bool):TileMap {
		var segment = Res.segments.segment.toBitmap();

		var map = new TileMap(0, 0, segment.width, segment.height, parent);

		trace('segment size: ', segment.width, segment.height);

		segment.lock();
		for (px in 0...segment.width) {
			for (py in 0...segment.height) {
				var tile = GameTile.colorFactory(segment.getPixel(px, py));

				if (tile != null) {
					tile.pos = {tileX: px, tileY: py};
					if (onTile != null) {
						if (onTile(tile)) {
							map.setTile(px, py, tile);
						}
					} else {
						map.setTile(px, py, tile);
					}
				}
			}
		}
		segment.unlock();

		return map;
	}
}
