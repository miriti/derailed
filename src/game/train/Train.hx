package game.train;

import game.tiles.RailTile;
import h2d.Object;

class Train extends Object {
	// 0 = locomotive
	public var cars:Array<Car> = [];

	public var speed(default, set):Float = 0;

	function set_speed(value:Float):Float {
		for (car in cars)
			car.speed = value;
		return speed = value;
	}

	public function new(?parent) {
		super(parent);

		for (_ in 0...2) {
			cars.push(new Car(this));
		}
	}

	public function setTrack(track:Array<RailTile>, ?start:Int = 0) {
		for (n in 0...cars.length) {
			cars[n].setTrack(track, start - n * 2);
		}
	}

	public function update(dt:Float) {
		for (car in cars)
			car.update(dt);
	}
}
