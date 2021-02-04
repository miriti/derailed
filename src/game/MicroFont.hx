package game;

import h2d.TileGroup;
import h3d.Vector;
import hxd.Res;

class MicroFont extends TileGroup {
	public var text(default, set):String = '';

	function set_text(value:String):String {
		clear();

		for (cn in 0...value.length) {
			var char = value.charAt(cn);

			if (chars.exists(char)) {
				add(cn * 4, 0, tile.sub(chars[char].cx, chars[char].cy, 3, 5));
			}
		}

		return text = value;
	}

	var chars:Map<String, {cx:Int, cy:Int}> = [];

	public function new(?parent) {
		super(Res.font.micro.toTile(), parent);

		var allChars = '*+./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ';

		for (n in 0...allChars.length) {
			chars[allChars.charAt(n)] = {cx: n * 3, cy: 0};
		}

		color = Vector.fromColor(Palette.DARK);
	}
}
