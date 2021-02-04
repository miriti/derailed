package game;

import h2d.Object;

class HUD extends Object {
	var speedText:MicroFont;
	var itemText:MicroFont;

	public var speed(default, set):Float = 0;

	function set_speed(value:Float) {
		speedText.text = 'V=$value';
		return speed = value;
	}

	public function new(?parent) {
		super(parent);

		speedText = new MicroFont(this);
		speedText.x = speedText.y = 1;

		speed = 0;

		itemText = new MicroFont(this);
		itemText.y = 48 - 6;
		itemText.text = 'ITEM: RAILS';
	}
}
