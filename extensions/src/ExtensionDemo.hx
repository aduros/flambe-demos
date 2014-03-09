import flambe.Entity;

class ExtensionDemo
{
    public var name (default, null) :String;

    private function new (name :String)
    {
        this.name = name;
    }

    /** Called at application start to init this extension. */
    public function init ()
    {
        // See subclasses
    }

    public function createScene (ctx :AppContext) :Entity
    {
        return new Entity(); // See subclasses
    }
}
