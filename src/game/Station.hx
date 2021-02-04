package game;

import game.tiles.GameTile;
import game.types.TilePos;
import hxd.Res;

class Station extends GameTile {
	public function new(?pos:TilePos, ?parent) {
		super(Res.tiles.toTile().sub(24, 24, 18, 12), pos, parent);
	}
}
