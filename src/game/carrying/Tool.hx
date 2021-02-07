package game.carrying;

import h2d.Anim;
import h2d.Tile;
import game.tiles.CommodityTile;

class Tool extends Carry {
	public var commodityClass:Class<CommodityTile>;
	public var actionImage:Tile;
}
