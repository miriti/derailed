package game.tiles;

import game.carrying.Carry;

class EmptyTile extends GameTile {
	public var toCarry(default, set):Carry = null;

	function set_toCarry(value:Carry) {
		if (toCarry != null && toCarry.image != null) {
			removeChild(toCarry.image);
		}

		if (value != null && value.image != null) {
			addChild(value.image);
		}

		return toCarry = value;
	}

	public function new(?toCarry:Carry, ?pos, ?parent) {
		super(null, pos, parent);

		if (toCarry != null) {
			this.toCarry = toCarry;
		}
	}
}
