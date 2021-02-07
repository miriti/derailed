package game.train;

import game.tiles.RailTile;
import h2d.Object;

class Train extends Object {
	public var distance:Float = 0;
	// 0 = locomotive
	public var cars:Array<Car> = [];

	public var speed(default, set):Float = 0;

	var speedIncreaseDistance:Float = 0;

	public dynamic function onCrush() {}

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

	public function start() {
		speed = 0.1;
	}

	public function setTrack(track:Array<RailTile>, ?start:Int = 0) {
		for (n in 0...cars.length) {
			cars[n].setTrack(track, start - n * 2);
		}
	}

	public function update(dt:Float) {
		var dd:Float = 0;

		if (cars.length > 0) {
			dd = cars[0].distance;
		}

		for (car in cars) {
			car.update(dt);
			if (car.crushed) {
				car.remove();
				cars.remove(car);
				onCrush();
			}
		}

		if (cars.length > 0) {
			var d = cars[0].distance - dd;

			speedIncreaseDistance += d;

			if (speedIncreaseDistance >= 30) {
				speed += 0.1;
				speedIncreaseDistance = 0;
			}

			distance = cars[0].distance;
		}
	}
}
