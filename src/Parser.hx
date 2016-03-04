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
     * Parses a YAML-like data oriented file and generates a script to be executed later.
     * @param file  The file containing the text to parse.
     * @return      Returns a boolean that identifies if the parse was successful. If unsuccessful, you can trace the `error` string variable.
     */
    public function parse(file:String):Bool
    {
        var level:Int = 0;
        
        var content:String = File.getContent(file);
        
        var variable:String = "";
        
        var line:String = "";
        
        var lines = content.split("\n");
        
        for (i in 0...lines.length)
        {
            var l:String = lines[i];
            if (StringTools.startsWith(l, "#"))
                continue;
            else
            {
                var left = l.substring(0, l.indexOf(":"));
                
                //The left-side of the colon is empty, probably a member of a variable
                if (StringTools.rtrim(left) == "" || removeTrailingTabs(left) == "")
                {
                    //The right-side has something there, check if it's a function, an object or member variable
                    var right = l.substring(l.indexOf(":"));
                    if (right.length > 0)
                    {
                        //It's a function/constructor
                        if (right.indexOf("(") > -1)
                        {
                            var expr = right.substring(0, right.indexOf("("));
                            if (isUpperCase(expr, 0)) //Probably a constructor, assuming the first character of a function is lower case
                                line += variable + " = new " + expr;
                            else
                                line += variable + " = " + expr;
                        }
                        else //it's a member variable
                        {
                            variable += right.substring(1);
                            continue;
                        }
                    }
                    
                    line += ";\n";
                    _script += line;
                    continue;
                }
                else
                {
                    if (right.indexOf(" ") > -1 || right.indexOf("\t") > -1)
                    {
                        if (right.indexOf(" "))
                        {
                            level = Std.int(right.length / 4);
                        }
                        else if (right.indexOf("\t"))
                        {
                            level = right.length;
                        }
                    }
                    
                }
            }
        }
        
        
        
        return false;
    }
    
    private function removeTrailingTabs(str:String):String
    {
        var result = "";
        var differentChar = -1;
        
        for (i in 0...str.length)
        {
            var char = str.charAt(i);
            if (char != "\t" && differentChar == -1)
                differentChar = i;
            else if (differentChar > -1)
                result += char;
        }
        
        return result;
    }
    
    private function isUpperCase(char:String, index:Int)
    {
        return (char.charCodeAt(index) >= 65 || char.charCodeAt(index) < 91);
    }
    
    private function typeExists(type:String)
    {
        return variables.exists(type);
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