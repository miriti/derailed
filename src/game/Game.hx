package game;

import game.carrying.Axe;
import game.carrying.Carry;
import game.carrying.Pickaxe;
import game.carrying.Pile;
import game.carrying.Tool;
import game.mobs.Player;
import game.tiles.CommodityTile;
import game.tiles.EmptyTile;
import game.tiles.RailTile;
import game.tiles.TileMap;
import game.train.Train;
import game.types.Dir;
import game.types.TilePos;
import h2d.Bitmap;
import h2d.Tile;
import hxd.Key;
import hxd.Res;

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
	var map:GameMap;

	var gameLayerWrap:GameObject;
	var gameLayer:GameObject;

	var frontLayer:GameObject;

	public var hud:HUD;

	var playerDebug:Bitmap;
	var playerSelectionDebug:Bitmap;

	var playerSelection:Selection;

	public function new() {
		super();

		gameLayerWrap = new GameObject(this);
		gameLayerWrap.y = 1;

		gameLayer = new GameObject(gameLayerWrap);
		frontLayer = new GameObject();

		map = new GameMap(gameLayer);

		var initialChunk = TileMap.fromSegment(Res.segments.initial.toBitmap());

		map.pushTileMap(initialChunk);

		track = initialChunk.getTrack();
		playerDebug = new Bitmap(Tile.fromColor(0xff0000, 6, 6, 0.3), gameLayer);
		playerDebug.visible = false;

		playerSelectionDebug = new Bitmap(Tile.fromColor(0x00ff00, 6, 6, 0.3), gameLayer);
		playerSelectionDebug.visible = false;

		playerSelection = new Selection(frontLayer);
		playerSelection.visible = false;

		player = new Player(gameLayer);
		player.map = map;
		player.tileX = 6;
		player.tileY = 6;

		drop(5, 5, new Axe());
		drop(6, 5, new Pile(new RailTile(), 3, 3));
		drop(7, 5, new Pickaxe());

		train = new Train(gameLayer);
		train.onCrush = () -> {
			shake(4);
		};
		train.setTrack(track, 5);

		gameLayer.addChild(frontLayer);

		hud = new HUD(this);

		var countdown = new Countdown(this);
		countdown.x = 34;
		countdown.y = 16;
		countdown.onAnimEnd = () -> {
			countdown.remove();
		};
	}

	public function getNextEmptyTile(tx:Int, ty:Int, backtrack:Map<Int, Map<Int, Bool>> = null):EmptyTile {
		if (backtrack == null)
			backtrack = [];

		var tile = map.getTile(tx, ty);

		if (tile.is(EmptyTile) && cast(tile, EmptyTile).toCarry == null)
			return cast tile;

		for (p in [[-1, 0], [0, -1], [1, 0], [0, 1]]) {
			var tile = map.getTile(tx + p[0], ty + p[1]);

			if (tile.is(EmptyTile) && cast(tile, EmptyTile).toCarry == null)
				return cast tile;
		}

		return null;
	}

	public function drop(atX:Int, atY:Int, carry:Carry) {
		var tile = map.getTile(atX, atY);

		if (tile.is(EmptyTile)) {
			var emptyTile:EmptyTile = cast tile;
			emptyTile.toCarry = carry;
		} else
			trace('not empty tile $atX $atY');
	}

	public function addTrack(atX:Int, atY:Int) {
		var pos:TilePos = {tileX: atX, tileY: atY};

		if (Std.is(map.getTilePos(pos), EmptyTile)) {
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
			return (map.getTilePos(p) == null || Std.is(map.getTilePos(p), EmptyTile) || map.getTilePos(p).passable);
		});
	}

	override function keyDown(keyCode:Int) {
		super.keyDown(keyCode);

		if (keyCode == Key.SPACE) {
			var actionTilePos:TilePos = player.actionTilePos;

			var tile = map.getTilePos(actionTilePos);

			if (tile != null && tile.is(EmptyTile)) {
				var emptyTile:EmptyTile = cast tile;

				if (player.carrying != null && player.carrying.is(Pile)) {
					var pile:Pile = cast player.carrying;

					if (pile.of.is(RailTile)) {
						var avail = availableForTrack();

						var added:Bool = false;

						for (p in avail) {
							if (p.tileX == player.actionTilePos.tileX && p.tileY == player.actionTilePos.tileY) {
								var toTile:EmptyTile = cast map.getTilePos(p);

								if (toTile.toCarry != null) {
									var nextEmpty = getNextEmptyTile(p.tileX, p.tileY);

									if (nextEmpty != null)
										nextEmpty.toCarry = toTile.toCarry;
								}

								addTrack(player.actionTilePos.tileX, player.actionTilePos.tileY);
								Res.sound.track.play();
								added = true;
								pile.quantity--;

								if (pile.quantity == 0) {
									player.carrying = null;
								}

								break;
							}
						}

						if (!added) {
							emptyTile.toCarry = pile;
							player.carrying = null;
						}
					} else if (pile.of.is(CommodityTile)
						&& emptyTile.toCarry.is(Pile)
						&& cast(emptyTile.toCarry, Pile).of.is(CommodityTile) && cast(emptyTile.toCarry, Pile).ofClass != pile.ofClass) {
						emptyTile.toCarry = new Pile(new RailTile(), 3, 3);
						Res.sound.crafted.play();
						player.carrying = null;
					} else {
						emptyTile.toCarry = pile;
						player.carrying = null;
					}
				} else if (player.carrying != null && emptyTile.toCarry != null) {
					if (player.carrying.is(Pile) && emptyTile.toCarry.is(Pile)) {
						if (cast(player.carrying, Pile).add(emptyTile.toCarry)) {}
					}
				} else if (player.carrying != null && emptyTile.toCarry == null) {
					emptyTile.toCarry = player.carrying;
					player.carrying = null;
				} else if (player.carrying == null && emptyTile.toCarry != null) {
					player.carrying = emptyTile.toCarry;
					emptyTile.toCarry = null;
				}
			}
		}
	}

	override function keyUp(keyCode:Int) {
		super.keyUp(keyCode);
	}

	var startTime:Null<Float> = 5;

	var nextChunkDistance:Float = 0;

	var gameOverTimer:Float = 2;

	override function update(dt:Float) {
		if (startTime != null) {
			if (startTime <= 0) {
				startTime = null;
				train.start();
			} else
				startTime -= dt;
		}

		player.moveDirection = getKeyDirection();
		player.update(dt);

		var tile = map.getTilePos(player.actionTilePos);

		if (player.carrying != null) {
			if (player.carrying.is(Pile)) {
				var pile:Pile = cast player.carrying;

				if (pile.of.is(RailTile)) {
					var avail = availableForTrack();

					var hasAvail:Bool = false;

					for (t in avail) {
						if (t.tileX == player.actionTilePos.tileX && t.tileY == player.actionTilePos.tileY) {
							hasAvail = true;
							player.carryingDisplaySnap = t;
							playerSelection.visible = true;
							break;
						}
					}

					if (!hasAvail) {
						player.carryingDisplaySnap = null;
						playerSelection.visible = false;
					}
				} else if (pile.of.is(CommodityTile)
					&& tile.is(EmptyTile)
					&& cast(tile, EmptyTile).toCarry.is(Pile)
						&& pile.ofClass != cast(cast(tile, EmptyTile).toCarry, Pile).ofClass
							&& !cast(cast(tile, EmptyTile).toCarry, Pile).of.is(RailTile)) {
					player.carryingDisplaySnap = player.actionTilePos;
					playerSelection.visible = true;
				} else {
					player.carryingDisplaySnap = null;
					playerSelection.visible = false;
				}
			} else if (player.carrying.is(Tool)) {
				var tool:Tool = cast player.carrying;

				player.carryingDisplaySnap = null;

				if (tile != null && tile.is(tool.commodityClass)) {
					playerSelection.visible = true;
				} else
					playerSelection.visible = false;
			} else
				playerSelection.visible = false;
		} else if (player.carrying == null) {
			var actionTile = map.getTilePos(player.actionTilePos);

			if (actionTile != null && actionTile.is(EmptyTile) && cast(actionTile, EmptyTile).toCarry != null) {
				playerSelection.visible = true;
			} else {
				playerSelection.visible = false;
			}
		} else {
			playerSelection.visible = false;
		}

		playerDebug.x = Math.floor(player.tileX) * 6;
		playerDebug.y = Math.floor(player.tileY) * 6;

		playerSelection.x = playerSelectionDebug.x = (player.actionTilePos.tileX) * 6 - 1;
		playerSelection.y = playerSelectionDebug.y = (player.actionTilePos.tileY) * 6 - 1;

		var d = train.distance;
		train.update(dt);

		nextChunkDistance += train.distance - d;

		if (nextChunkDistance >= 80) {
			nextChunk();
			nextChunkDistance = 0;
		}

		if (train.cars.length > 0) {
			hud.distance = train.distance;
			gameLayer.fx = -train.cars[0].x + 30;
		} else {
			if (gameOverTimer <= 0)
				Main.instance.setState(new GameOver(train.distance));
			else
				gameOverTimer -= dt;
		}

		hud.speed = train.speed;

		if (shaking) {
			gameLayerWrap.x = Math.floor(Math.sin(shakePhase) * (shakeAmp * (shakeTimeCurrent / shakeTime)));
			gameLayerWrap.y = Math.floor(Math.cos(shakePhase) * (shakeAmp * (shakeTimeCurrent / shakeTime)));

			if (shakeTimeCurrent == 0)
				shaking = false;
			else {
				shakeTimeCurrent -= dt;
				shakePhase += Math.PI * 2 * Math.random();

				if (shakeTimeCurrent <= 0)
					shakeTimeCurrent = 0;
			}
		}
	}

	var shakeTime:Float = 0;
	var shakeTimeCurrent:Float = 0;
	var shakeAmp:Float = 3;
	var shakePhase:Float = 0;
	var shaking:Bool = false;

	public function shake(amp:Float, time:Float = 1) {
		shakeAmp = amp;
		shakeTime = shakeTimeCurrent = time;
		shaking = true;
	}

	public function nextChunk() {
		var startX = map.nextStartX;
		var startY = map.nextStartY;

		var rndSegments = [
			Res.segments.rnd._00,
			Res.segments.rnd._01,
			Res.segments.rnd._02,
			Res.segments.rnd._03
		];

		var nextChunk = TileMap.fromSegment(rndSegments[Math.floor(Math.random() * rndSegments.length)].toBitmap(), startX, startY);
		map.pushTileMap(nextChunk);
	}
}
