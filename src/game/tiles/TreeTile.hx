package game.tiles;

class TreeTile extends GameTile {
	public function new(?parent) {
		super(GameTile.getBmp(4, 0), parent);
	}
}
