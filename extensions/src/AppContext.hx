import flambe.asset.AssetPack;
import flambe.display.Font;
import flambe.scene.Director;

/** Just a bunch of global state and assets that we pass around. */
class AppContext
{
    public var pack (default, null) :AssetPack;

    public var smallFont (default, null) :Font;
    public var bigFont (default, null) :Font;

    public var director (default, null) :Director;

    public function new (pack :AssetPack)
    {
        this.pack = pack;
        smallFont = new Font(pack, "segoe28-white");
        bigFont = new Font(pack, "segoe48-white");
        director = new Director();
    }
}
