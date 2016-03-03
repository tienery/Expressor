# Expressor
 A YAML-like parser for conveniently creating data-oriented design and development in Haxe.

## Roadmap
This is just a concept, but the idea is straight-forward (ideally, I could use some help perfecting it).

The idea is to use YAML-like syntax to efficiently create code off the back of HScript.

    # This is a comment
    
    bitmap : Bitmap(Assets.getBitmapData("img/haxe-logo.png"))
    
    sample : Sprite
        x : 30
        y : 30
        :addChild(bitmap)

So the idea behind this is to simply create objects based on their key-value pairs as seen above, using `:` to distinguish between the keys and values.

`sample` in the example above becomes `var sample = new Sprite();`.

Because `x` is tabbed in, the parser should assume that `x` is a member variable of `sample`. So the following is generated: `sample.x = 30;`.

If only a `:` is found at the start of a line, then at whichever the level it's at, it will either assume the following expression is a member of the variable the expression is enclosed in, is part of a constructor, or simply an expression on its own.

We could use either a macro or HScript, so we could generate code both at runtime or compile-time. Perhaps I will put both in.

So, the expression found at the bottom of `sample` generates `sample.addChild(bitmap);`.

Also, `bitmap` turns to `var bitmap = new Bitmap(Assets.getBitmapData("img/haxe-logo.png"));`.

Because everything on the left-side of the colon would be considered an expression by the parser, things like this should be possible:

    text : "Hello, this is some text."
    
    data : {}
        message : text

And that should convert to:

    var text = "Hello, this is some text.";
    var data = {};
    data.message = text;

So what has been done so far? None of it yet...

The project is in early stages, I'm currently fighting with code structure to figure out how I should layout the parse function.
