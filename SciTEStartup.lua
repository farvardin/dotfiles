
-- dofile (props["SciteUserHome"].."/.scite/extman/extman.lua") 
--dofile (props["SciteUserHome"].."/.scite/fold.lua") 


 dofile (props["SciteUserHome"].."/.scite/fold2.lua") -- works without extman 
-- dofile (props["SciteUserHome"].."/.scite/tictactoe.lua") 
-- dofile (props["SciteUserHome"].."/.scite/eliza.lua") 
-- dofile (props["SciteUserHome"].."/.scite/scitefunclist.lua") 
--dofile (props["SciteUserHome"].."/.scite/date.lua") 

function insertDate() 
	MyDate = os.date("\n== %Y-%m-%d ==\n")
    editor:InsertText(-1,MyDate)
end

