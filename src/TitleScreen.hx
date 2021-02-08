import h2d.Anim;
import h2d.Tile;
import game.Game;
import h2d.Bitmap;
import hxd.Key;
import hxd.Res;

class TitleScreen extends State {
	public function new() {
		super();
		new Bitmap(Tile.fromColor(Palette.DARK, 84, 48), this);

		new Bitmap(Res.title.logo.toTile(), this);
		new Bitmap(Res.title.subtitle.toTile(), this);

		new Anim([Res.title.start.toTile(), Tile.fromColor(Palette.DARK, 1, 1)], 1, this);
	}

	override function keyDown(keyCode:Int) {
		if (keyCode == Key.SPACE) {
			Main.instance.setState(new Game());
		}
	}
}
