# Expressor
 A structural scripting language for Haxe.

## Roadmap
This is just a concept, but the idea is straight-forward.

The idea is to use YAML-like syntax to efficiently create code off the back of HScript.

    // This is a comment
    
    bitmap = new Bitmap(Assets.getBitmapData("img/haxe-logo.png"))
    
    sample = new Sprite()
        x = 30
        y = 30
        addChild(bitmap)
        graphics
            beginFill(0xFF0000)
            drawRect(0, 0, 50, 50)

Everything is considered a variable on the right side of the equals sign without using "var".

    text = "Hello, this is some text."
    
    data = {}
        message = text

And that should convert to:

    text = "Hello, this is some text.";
    data = {};
    data.message = text;

So what has been done so far?

You can pass in variables, pass a script, and execute it.

Things that currently cannot be done:

* Function handling
* Macro-based code generation (including the ability to import)
* Import-like functionality for the HScript-side.