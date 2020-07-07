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

local function find(e,xs)
  if (isempty(xs)) then
    return false 
  elseif (e == xs[1]) then
    return true
  else
    return find(e, tail(xs))
  end
end

local function notuniq(xs)
  function dubitr(acc, xs)
    local r 
    if isempty(xs) then
      return acc 
    elseif (find(xs[1], tail(xs)) and not find(xs[1], acc)) then
      r = xs[1]
      return dubitr(table.insert(acc, r), tail(xs))
    else
      return dubitr(acc, tail(xs))
    end
  end
  return dubitr({}, xs)
end

local function uniq(xs)
  local duplicates = notuniq(xs)
  local acc = {}
  function uniqitr(acc, d, xs)
    if (isempty(xs)) then
      return acc
    elseif (find(xs[1],d)) then
      return uniqitr(acc, d, tail(xs))
    else
      table.insert(acc, xs[1])
      return uniqitr(acc, d, tail(xs))
    end
  end
  return uniqitr(acc, duplicates, xs)
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
  find = find,
  uniq = uniq,
  notuniq = notuniq,
  head = head,
  tail = tail,
  isempty = isempty,
  foldr = foldr,
  foldl = foldl,
  map = map,
  filter = filter,
}

return fu

