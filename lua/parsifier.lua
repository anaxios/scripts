#!/usr/local/bin/luajit
table = require "std.table"
fu = require "./fu"

function main()
  local mylist = {3,1,3,4,5,4,7,8,3,4,7,6,4,8,6,9,6,4,3,2,4,4}
  -- for i=1, 100 do
  --   mylist[i] = 1
  -- end

  print(table.concat(fu.notuniq(mylist)))
  print(table.concat(fu.uniq(mylist)))
  print(fu.find(8,mylist))
end
main()
