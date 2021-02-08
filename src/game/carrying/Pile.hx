package game.carrying;

import game.tiles.GameTile;

using Std;

class Pile extends Carry {
	public var of:GameTile;
	public var quantity:Int;
	public var capacity:Int;

	public var ofClass:Class<GameTile>;

	public function new(of:GameTile, quantity:Int = 1, capacity:Int = 3) {
		if (of != null) {
			image = of.image;
			ofClass = Type.getClass(of);
		}
		this.of = of;
		this.quantity = quantity;
		this.capacity = capacity;
	}

	public function add(carry:Carry):Bool {
		if (quantity < capacity && carry != null && carry.is(Pile)) {
			var pile:Pile = cast carry;

			var maxAddQuantity:Int = capacity - quantity;

			if (pile.ofClass == ofClass) {
				var toAdd:Int = Math.min(maxAddQuantity, pile.quantity).int();

				quantity += toAdd;
				pile.quantity -= toAdd;
				return true;
			}
		}

		return false;
	}
}
