fu = {}

local function head(xs)
  return xs[1]
end

local function tail(xs)
  local ys = table.clone(xs)
  table.remove(ys, 1)
  return ys
  -- table.remove(xs, 1)
  -- return xs
end

local function isempty(s)
  return s == nil or s == '' or #s <= 0
end

local function foldl(f, acc, xs)
  if isempty(xs)  then
    return acc
  else
    return foldl(f, f(acc, head(xs)), tail(xs))
  end
end

local function foldr(f, acc, xs)
  if isempty(xs)  then
    return acc
  else
    return f(head(xs), foldr(f, acc, tail(xs)))
  end
end

local function map(f, xs)
  if isempty(xs) then
    return {} 
  else
    return foldl(function(acc, x) table.insert(acc, f(x)) return acc  end, {}, xs)
  end
end

local function filter(f, xs)
  if isempty(xs) then
    return {}
  else
    return foldl(function(acc, x) if f(x) then return table.insert(acc, x) else return acc end end, {}, xs)
  end
end


fu = {
  tail = tail,
  isempty = isempty,
  foldr = foldr,
  foldl = foldl,
  map = map,
  filter = filter,
}

return fu

