package;

import expressor.Parser;

class Main
{

    public static function main()
    {
        var parser = new Parser();
        if (!parser.parse("info/test.doe"))
            trace(parser.error);
        
        Sys.getChar(false);
    }
    
}