package game;

import hxd.Res;
import h2d.Anim;

class Countdown extends Anim {
	public function new(?parent) {
		super([
			for (n in 0...6)
				Res.countdown.toTile().sub(n * 16, 0, 16, 16)
		], 1, parent);
	}
}
