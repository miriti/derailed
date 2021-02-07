package game.tiles;

import game.types.TilePos;
import h2d.Bitmap;

enum RailTileVariation {
	HORIZONTAL;
	VERTICAL;
	TOP_LEFT;
	TOP_RIGHT;
	BOTTOM_LEFT;
	BOTTOM_RIGHT;
}

class RailTile extends GameTile {
	var railImage:Bitmap;

	var _defaultImage:Bitmap;

	override function get_image():Bitmap {
		return _defaultImage;
	}

	public var next(default, set):RailTile = null;

	function set_next(value:RailTile) {
		if (prev != null) {
			if (value.pos.tileX == pos.tileX) {
				if (prev.pos.tileX < pos.tileX) {
					if (value.pos.tileY > pos.tileY)
						variation = TOP_RIGHT;
					else
						variation = BOTTOM_RIGHT;
				} else if (prev.pos.tileX > pos.tileX) {
					if (value.pos.tileY > pos.tileY)
						variation = TOP_LEFT;
					else
						variation = BOTTOM_LEFT;
				}
			}
			if (value.pos.tileY == pos.tileY) {
				if (prev.pos.tileY < pos.tileY) {
					if (value.pos.tileX > pos.tileX)
						variation = BOTTOM_LEFT;
					else
						variation = BOTTOM_RIGHT;
				} else if (prev.pos.tileY > pos.tileY) {
					if (value.pos.tileX > pos.tileX)
						variation = TOP_LEFT;
					else
						variation = TOP_RIGHT;
				}
			}
		}

		return next = value;
	}

	public var prev(default, set):RailTile;

	function set_prev(value:RailTile) {
		if (value != null) {
			if (pos.tileY == value.pos.tileY) {
				variation = HORIZONTAL;
			} else {
				variation = VERTICAL;
			}

			value.next = this;
		} else
			variation = HORIZONTAL;

		return prev = value;
	}

	public var variation(default, set):RailTileVariation;

	function set_variation(value:RailTileVariation):RailTileVariation {
		if (value != variation) {
			railImage.tile = switch (value) {
				case HORIZONTAL:
					GameTile.getBmp(1, 0);
				case VERTICAL:
					GameTile.getBmp(2, 1);
				case TOP_LEFT:
					GameTile.getBmp(0, 0);
				case TOP_RIGHT:
					GameTile.getBmp(2, 0);
				case BOTTOM_LEFT:
					GameTile.getBmp(0, 2);
				case BOTTOM_RIGHT:
					GameTile.getBmp(2, 2);
			}
		}

		return variation = value;
	}

	public function new(?parent, ?pos:TilePos, ?prev:RailTile) {
		super(null, pos, parent);

		_defaultImage = new Bitmap(GameTile.getBmp(1, 0));

		railImage = new Bitmap();
		addChild(railImage);

		this.prev = prev;
	}
}
