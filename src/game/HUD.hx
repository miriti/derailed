package game;

import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;

class HUD extends Object {
	var speedText:MicroFont;
	var distanceText:MicroFont;

	public var speed(default, set):Float = 0;

	function set_speed(value:Float) {
		speedText.text = 'V=$value';
		return speed = value;
	}

	public var distance(default, set):Float = 0;

	function set_distance(value:Float) {
		distanceText.text = 'D=$value';
		distanceText.x = 84 - distanceText.getBounds().width - 1;
		return distance = value;
	}

	public function new(?parent) {
		super(parent);

		new Bitmap(Tile.fromColor(Palette.LIGHT, 84, 7), this);

		speedText = new MicroFont(this);
		speedText.x = speedText.y = 1;

		distanceText = new MicroFont(this);
		distanceText.y = 1;

		speed = 0;
		distance = 0;
	}
}
