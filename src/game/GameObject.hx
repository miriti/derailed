package game;

import h2d.Object;

class GameObject extends Object {
	public var fx(default, set):Float = 0;

	function set_fx(value:Float):Float {
		fx = value;
		x = Math.floor(fx);
		return fx;
	}

	public var fy(default, set):Float = 0;

	function set_fy(value:Float):Float {
		fy = value;
		y = Math.floor(fy);
		return fy;
	}

	public function new(?parent) {
		super(parent);
	}

	public function update(dt:Float) {}
}
