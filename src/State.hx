import h2d.Scene;

class State extends Scene {
	var pressedKeys:Map<Int, Bool> = [];

	public function new() {
		super();

		scaleMode = Stretch(84, 48);
	}

	public function keyDown(keyCode:Int) {
		pressedKeys[keyCode] = true;
	}

	public function keyUp(keyCode:Int) {
		pressedKeys[keyCode] = false;
	}

	public function update(dt:Float) {}
}
