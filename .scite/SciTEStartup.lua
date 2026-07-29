
-- dofile (props["SciteUserHome"].."/.scite/extman/extman.lua") 
--dofile (props["SciteUserHome"].."/.scite/fold.lua") 


 dofile (props["SciteUserHome"].."/.scite/fold2.lua") -- works without extman 
 dofile (props["SciteUserHome"].."/.scite/t2t_navigator.lua") -- navigation titres txt2tags
 dofile(props["SciteUserHome"] .. "/.scite/snippets.lua") -- snippets and zettelkasten
-- dofile (props["SciteUserHome"].."/.scite/tictactoe.lua") 
-- dofile (props["SciteUserHome"].."/.scite/eliza.lua") 
-- dofile (props["SciteUserHome"].."/.scite/scitefunclist.lua") 
--dofile (props["SciteUserHome"].."/.scite/date.lua") 
dofile(props["SciteUserHome"] .. "/.scite/file_finder.lua")
dofile(props["SciteUserHome"] .. "/.scite/recent_files.lua")
dofile(props["SciteUserHome"] .. "/.scite/t2t_format.lua")
dofile(props["SciteUserHome"] .. "/.scite/sexpr_eval.lua")


function insertDate() 
	MyDate = os.date("\n== %Y-%m-%d ==\n")
    editor:InsertText(-1,MyDate)
end

