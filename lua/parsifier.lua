#!/usr/local/bin/luajit
table = require "std.table"
fu = require "./fu"

function find(e,xs)
  if (fu.isempty(xs)) then
    return false 
    elseif (e == xs[1]) then
    return true
    else
      return find(e, fu.tail(xs))
  end
end

function uniq(xs)
  local duplicates = notuniq(xs)
  local acc = {}
  function uniqitr(acc, d, xs)
    if (fu.isempty(xs)) then
      return acc
    elseif (find(xs[1],d)) then
      return uniqitr(acc, d, fu.tail(xs))
    else
      table.insert(acc, xs[1])
      return uniqitr(acc, d, fu.tail(xs))
    end
  end
  return uniqitr(acc, duplicates, xs)
end

function notuniq(xs)
local function compareFirst(x)
    return function(y) 
      return x == y
    end
  end
  function dubitr(acc, xs)
    local r 
    if fu.isempty(xs) then
      return acc 
    elseif (#(fu.filter(compareFirst(xs[1]),fu.tail(xs))) > 0) then
      r = xs[1]
      return dubitr(table.insert(acc, r), fu.tail(xs))
    else
      return dubitr(acc, fu.tail(xs))
    end
  end
  return dubitr({}, xs)
end

function main()
  local mylist = {3,1,3,4,5,4,7,8,3,4,7,6,4,8,6,9,6,4,3,2,4,4}
  -- for i=1, 100 do
  --   mylist[i] = 1
  -- end

  print(table.concat(notuniq(mylist)))
  print(table.concat(uniq(mylist)))
  print(find(8,mylist))
end
main()
