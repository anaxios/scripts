#!/usr/local/bin/luajit

function head(xs)
  return xs[1]
end

function tail(xs)
  local ys = unpack(xs)
  table.remove(ys, 1)
  return ys
end

local function isempty(s)
  return s == nil or s == '' or #s <= 0
end

function foldl(f, acc, xs)
  if isempty(xs)  then
    return acc
  else
    return foldl(f, f(acc, head(xs)), tail(xs))
  end
end

function foldr(f, acc, xs)
  if isempty(xs)  then
    return acc
  else
    return f(head(xs), foldr(f, acc, tail(xs)))
  end
end

function map(f, xs)
  if isempty(xs) then
    return {} 
  else
    return foldl(function(acc, x) table.insert(acc, f(x)) return acc  end, {}, xs)
  end
end


function main()
  local mylist = {1,2,3,4,5,6,7,8}


  print(table.concat(mylist, ","))
  print(table.concat((map(function(x) return 1 + x end, mylist))))
  print((foldl(function(a, x) return a + x end, 0, mylist)))

end
main()
