package game;

import hxd.Res;
import h2d.Text;

class Font {
	public static function get(text:String, ?dark:Bool = true, ?parent):Text {
		var tf = new Text(Res.font.nokia.toFont(), parent);
		tf.text = text;
		tf.textColor = dark ? Palette.DARK : Palette.LIGHT;
		return tf;
	}
}
