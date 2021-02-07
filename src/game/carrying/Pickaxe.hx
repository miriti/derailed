package game.carrying;

import game.tiles.GameTile;
import game.tiles.RockTile;
import h2d.Bitmap;

class Pickaxe extends Tool {
	public function new() {
		image = new Bitmap(GameTile.getBmp(0, 8));
		actionImage = GameTile.getBmp(1, 8);
		commodityClass = RockTile;
		name = 'Pickaxe';
	}
}
