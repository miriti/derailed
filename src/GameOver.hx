import h2d.Object;
import game.Font;
import hxd.Res;
import h2d.Text;

class GameOver extends State {
	public function new(distance:Float) {
		super();

		var gameOver = Font.get('Game Over', this);
		gameOver.x = Math.floor(84 - gameOver.getBounds().width) / 2;
		gameOver.y = 1;

		var score = new Object(this);

		var dist = Font.get('Distance:', score);
		dist.x = Math.floor(-dist.getBounds().width / 2);

		var distVal = Font.get('$distance', score);
		distVal.y = dist.getBounds().height;
		distVal.x = Math.floor(-distVal.getBounds().width / 2);

		score.x = 84 / 2;
		score.y = Math.floor(48 - score.getBounds().height - 1);
	}
}
