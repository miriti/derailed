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
	var image:Bitmap;

	var prev:RailTile = null;
	var next(default, set):RailTile = null;

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

	public var variation(default, set):RailTileVariation;

	function set_variation(value:RailTileVariation):RailTileVariation {
		if (value != variation) {
			image.tile = switch (value) {
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

		this.prev = prev;

		image = new Bitmap();
		addChild(image);

		if (prev != null) {
			if (pos.tileY == prev.pos.tileY) {
				variation = HORIZONTAL;
			} else {
				variation = VERTICAL;
			}

			prev.next = this;
		} else
			variation = HORIZONTAL;
	}
}
