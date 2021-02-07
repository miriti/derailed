package game.carrying;

import game.tiles.GameTile;
import game.tiles.TreeTile;
import h2d.Bitmap;

class Axe extends Tool {
	public function new() {
		image = new Bitmap(GameTile.getBmp(0, 9));
		actionImage = GameTile.getBmp(1, 9);
		commodityClass = TreeTile;
		name = 'Axe';
	}
}
