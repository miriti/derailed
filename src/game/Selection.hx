package game;

import h2d.Anim;
import h2d.Object;
import hxd.Res;

class Selection extends Object {
	public function new(?parent:Object) {
		super(parent);
		var anim = new Anim([
			for (n in 0...4)
				Res.selection.toTile().sub(0, n * 8, 8, 8)
		], this);
		anim.speed = 12;
	}
}
