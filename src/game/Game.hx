package game;

import game.mobs.Player;
import game.tiles.RailTile;
import game.tiles.TileMap;
import game.train.Train;
import game.types.Dir;
import game.types.TilePos;
import hxd.Key;

using Std;

class Game extends State {
	public var player:Player;

	var keyConfig = {
		LEFT: [Key.A, Key.LEFT, Key.NUMPAD_4],
		UP: [Key.W, Key.UP, Key.NUMPAD_8],
		RIGHT: [Key.D, Key.RIGHT, Key.NUMPAD_6],
		DOWN: [Key.S, Key.DOWN, Key.NUMPAD_2],
	};

	public var isLeft(get, never):Bool;

	function get_isLeft():Bool {
		var result = false;
		for (key in keyConfig.LEFT)
			result = result || pressedKeys[key];

		return result;
	}

	public var isUp(get, never):Bool;

	function get_isUp():Bool {
		var result = false;
		for (key in keyConfig.UP)
			result = result || pressedKeys[key];

		return result;
	}

	public var isRight(get, never):Bool;

	function get_isRight():Bool {
		var result = false;
		for (key in keyConfig.RIGHT)
			result = result || pressedKeys[key];

		return result;
	}

	public var isDown(get, never):Bool;

	function get_isDown():Bool {
		var result = false;
		for (key in keyConfig.DOWN)
			result = result || pressedKeys[key];

		return result;
	}

	public var track:Array<RailTile>;

	var train:Train;
	var map:TileMap;

	var gameLayer:GameObject;

	public var hud:HUD;

	public function new() {
		super();

		gameLayer = new GameObject(this);

		map = TileMap.fromSegment(gameLayer);

		track = map.getTrack();

		player = new Player(gameLayer);
		player.fx = 2 * 6;
		player.fy = 6 * 5;

		train = new Train(gameLayer);
		train.setTrack(track, 3);

		hud = new HUD(this);
	}

	public function addTrack(atX:Int, atY:Int) {
		var pos:TilePos = {tileX: atX, tileY: atY};

		if (map.getTilePos(pos) == null) {
			var newRailTile:RailTile = null;

			if (track.length > 0) {
				var prev = track[track.length - 1];
				var prevTile = map.getTilePos(prev.pos);

				if (prevTile.is(RailTile)) {
					newRailTile = new RailTile(null, pos, cast prevTile);
				}
			} else
				newRailTile = new RailTile(pos);

			if (newRailTile != null) {
				map.setTilePos(pos, newRailTile);
				track.push(newRailTile);
			}
		}
	}

	function getKeyDirection():Dir {
		return {
			dx: (isLeft ? -1 : 0) + (isRight ? 1 : 0),
			dy: (isUp ? -1 : 0) + (isDown ? 1 : 0)
		};
	}

	function availableForTrack():Array<TilePos> {
		var last = track[track.length - 1];

		return [
			{
				tileX: last.pos.tileX - 1,
				tileY: last.pos.tileY
			},
			{
				tileX: last.pos.tileX + 1,
				tileY: last.pos.tileY
			},
			{
				tileX: last.pos.tileX,
				tileY: last.pos.tileY - 1
			},
			{
				tileX: last.pos.tileX,
				tileY: last.pos.tileY + 1
			}
		].filter((p:TilePos) -> {
			return map.inRange(p) && map.getTilePos(p) == null;
		});
	}

	override function keyDown(keyCode:Int) {
		super.keyDown(keyCode);

		if (keyCode == Key.SPACE) {
			var pos:TilePos = {
				tileX: Math.floor((player.fx + 3) / 6),
				tileY: Math.floor((player.fy + 3) / 6)
			};

			var avail = availableForTrack();

			for (p in avail) {
				if (p.tileX == pos.tileX && p.tileY == pos.tileY) {
					addTrack(pos.tileX, pos.tileY);
					break;
				}
			}
		}
	}

	override function keyUp(keyCode:Int) {
		super.keyUp(keyCode);
	}

	var startTime:Null<Float> = 3;

	override function update(dt:Float) {
		if (startTime != null) {
			if (startTime <= 0) {
				startTime = null;
				train.speed = hud.speed = 0.25;
			} else
				startTime -= dt;
		}

		player.moveDirection = getKeyDirection();
		player.update(dt);

		train.update(dt);

		gameLayer.fx = -train.cars[0].x + 30;
	}
}
