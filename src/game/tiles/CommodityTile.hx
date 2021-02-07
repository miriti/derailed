package game.tiles;

import game.carrying.Pile;
import h2d.Bitmap;
import h2d.Tile;

class CommodityTile extends GameTile {
	public var harvested:Bool = false;

	public var displayState:Array<Bitmap>;

	var currentState(default, set):Int;

	function set_currentState(value:Int) {
		for (n in 0...displayState.length) {
			displayState[n].visible = value == n;
		}
		return currentState = value;
	}

	override function get_image():Bitmap {
		return displayState[currentState];
	}

	public function new(states:Array<Tile>, ?pos, ?parent) {
		super(null, pos, parent);

		passable = false;

		displayState = [for (t in states) new Bitmap(t, this)];

		currentState = 0;
	}

	public function hit() {
		if (!harvested) {
			currentState++;

			if (currentState == 3) {
				map.setTilePos(pos, new EmptyTile(new Pile(this, 1)));
				harvested = passable = true;
			}
		}
	}
}
