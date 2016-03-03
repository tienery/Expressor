package;

import hscript.Parser in HParser;
import hscript.Interp;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class Parser
{

    private var _hparser:HParser;
    private var _interp:Interp;
    private var _script:String;
    
    /**
     * Create a new Data-Oriented YAML parser
     */
    public function new()
    {
        _interp = new Interp();
        _hparser = new HParser();
        
        _hparser.allowJSON = false;
        _hparser.allowTypes = false;
    }
    
    /**
     * Parses a YAML file and generates a script to be executed later.
     * @param file  The file containing the text to parse.
     * @return      Returns a boolean that identifies if the parse was successful. If unsuccessful, you can trace the `error` string variable.
     */
    public function parse(file:String):Bool
    {
        var level:Int = 0;
        
        var content:String = File.getContent(file);
        var isComment:Bool = false;
        var isVariable:Bool = false;
        var isFunction:Bool = false;
        var isStartOfLine:Bool = false;
        
        var line:String = "";
        
        for (i in 0...content.length)
        {
            
        }
    }
    
    private var _error:String;
    /**
     * If an error occurred, it is generated in this variable.
     */
    public var error(get, null):String;
    public function get_error() return _error;
    
    /**
     * Access to the internal HScript interpretor.
     */
    public var variables(get, null):Map<String, Dynamic>;
    private function get_variables() return _interp.variables;
    
}