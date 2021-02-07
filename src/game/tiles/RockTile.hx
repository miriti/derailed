package game.tiles;

class RockTile extends CommodityTile {
	public function new(?pos, ?parent) {
		super([
			GameTile.getBmp(4, 1),
			GameTile.getBmp(5, 1),
			GameTile.getBmp(6, 1),
			GameTile.getBmp(7, 1)
		], pos, parent);
	}
}
