import hxd.App;
import hxd.Event;
import hxd.Res;
import hxd.Window;

class Main extends App {
	public static var instance:Main;

	var currentState:State = null;

	override function init() {
		engine.backgroundColor = Palette.LIGHT;
		Window.getInstance().addEventTarget(windowEventTarget);
		setState(new TitleScreen());
	}

	public function setState(newState:State) {
		currentState = newState;
		setScene2D(newState);
	}

	override function update(dt:Float) {
		super.update(dt);
		if (currentState != null)
			currentState.update(dt);
	}

	function windowEventTarget(event:Event) {
		switch (event.kind) {
			case EKeyDown:
				currentState.keyDown(event.keyCode);
			case EKeyUp:
				currentState.keyUp(event.keyCode);
			case _:
		}
	}

	public function new() {
		instance = this;
		super();
	}

	static function main() {
		Res.initEmbed();
		new Main();
	}
}
