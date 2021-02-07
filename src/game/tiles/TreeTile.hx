package game.tiles;

class TreeTile extends CommodityTile {
	public function new(?pos, ?parent) {
		super([
			GameTile.getBmp(4, 0),
			GameTile.getBmp(5, 0),
			GameTile.getBmp(6, 0),
			GameTile.getBmp(7, 0)
		], pos, parent);
	}
}
