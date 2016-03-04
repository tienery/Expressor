package expressor;

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
    private var _eval:Dynamic;
    
    /** 
     * Create a new Data-Oriented YAML parser
     */
    public function new()
    {
        _interp = new Interp();
        _hparser = new HParser();
        
        _hparser.allowJSON = false;
        _hparser.allowTypes = false;
        
        _script = "";
    }
    
    /**
     * Parses a YAML-like data oriented file and generates a script to be executed later.
     * @param file  The file containing the text to parse.
     * @return      Returns a boolean that identifies if the parse was successful. If unsuccessful, you can trace the `error` string variable.
     */
    public function parse(file:String):Bool
    {
        try
        {
            var levels = new Array<String>();
            var spaceCount = 0;
            var previousSpaceCount = 0;
            
            var content:String = File.getContent(file);
            
            var line:String = "";
            
            var keyValueRegex = ~/([^=]+)=([^=]+)/;
            
            var lines = content.split("\n");
            
            for (i in 0...lines.length)
            {
                var l:String = lines[i];
                
                if (StringTools.isSpace(l, 0))
                {
                    spaceCount = countSpaces(l);
                    if (spaceCount < previousSpaceCount)
                        levels.splice(levels.length - 1, 1);
                }
                else
                    levels = [];
                
                previousSpaceCount = spaceCount;
                
                if (keyValueRegex.match(l)) //It's a variable assignment
                {
                    if (levels.length > 0 && StringTools.isSpace(l, 0)) //The variable is part of another
                    {
                        line = fullVariable(levels) + StringTools.rtrim(keyValueRegex.matched(0)) + ";";
                    }
                    else //If not, paste the entire line
                    {
                        levels.push(StringTools.rtrim(keyValueRegex.matched(1)));
                        line = StringTools.rtrim(keyValueRegex.matched(0)) + ";";
                    }
                }
                else
                {
                    if (l.indexOf("(") == -1 && StringTools.isSpace(l, 0)) //It's a sub-variable
                    {
                        levels.push(StringTools.rtrim(l));
                        continue;
                    }
                    else //It's a function
                    {   
                        line = fullVariable(levels) + StringTools.rtrim(l) + ";";
                    }
                }
                
                _script += line + "\n";
            }
            
            #if log
            File.saveContent("script.log", _script);
            #end
            
            _eval = _hparser.parseString(_script);
            
            return true;
        }
        catch (msg:String)
        {
            error = _hparser.line + ": " + msg;
            return false;
        }
    }
    
    /**
     * Execute the evaluated script.
     */
    public function execute()
    {
        try
        {
            _interp.execute(_eval);
        }
        catch (msg:String)
        {
            _error = msg;
        }
    }
    
    private function countSpaces(line:String):Int
    {
        var count = 0;
        for (i in 0...line.length)
        {
            if (StringTools.isSpace(line.charAt(i), 0))
                count++;
            else
                break;
        }
        return count;
    }
    
    private function fullVariable(levels:Array<String>):String
    {
        var result = "";
        for (item in levels) result += item + ".";
        
        return result;
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