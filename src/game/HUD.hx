package game;

import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;

using StringTools;

class HUD extends Object {
	var speedText:MicroFont;
	var distanceText:MicroFont;

	function toFixed(n:Float):String {
		var s = '$n';

		if (s.indexOf('.') != -1) {
			var p = s.split('.');
			var d = '${Std.parseInt(p[1])}'.substr(0, 2);

			var m = p[0];
			var f = '$d'.rpad('0', 2);

			return '$m.$f';
		} else
			return '$s.00';
	}

	public var speed(default, set):Float = 0;

	function set_speed(value:Float) {
		speedText.text = 'V=${toFixed(value)}';
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
