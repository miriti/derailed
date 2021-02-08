package game.carrying;

import game.tiles.CommodityTile;
import h2d.Tile;

class Tool extends Carry {
	public var commodityClass:Class<CommodityTile>;
	public var actionImage:Tile;
}
