-- Copyright 2011 by Jannis Pohlmann
--
-- This file may be distributed and/or modified
--
-- 1. under the LaTeX Project Public License and/or
-- 2. under the GNU Public License
--
-- See the file doc/generic/pgf/licenses/LICENSE for more information

-- @release $Header: /home/mojca/cron/mojca/github/cvs/pgf/pgf/generic/pgf/graphdrawing/core/lualayer/pgflibrarygraphdrawing-fibonacci-heap.lua,v 1.1 2011/05/12 02:10:37 jannis-pohlmann Exp $

--- This file contains a straightforward implementation of a Fibonacci heap.
--
-- TODO this class needs to be documented.

pgf.module("pgf.graphdrawing")



FibonacciHeapNode = {}
FibonacciHeapNode.__index = FibonacciHeapNode



function FibonacciHeapNode:new(value, root, parent)
  local node = {
    value = value,
    children = {},
    marked = false,
    root = nil,
    parent = nil,
  }
  setmetatable(node, FibonacciHeapNode)

  if root then
    node.root = root
    node.parent = parent
  else
    node.root = node
    node.parent = node
  end

  return node
end



function FibonacciHeapNode:addChild(value)
  local child = FibonacciHeapNode:new(value, self.root, self)
  table.insert(self.children, child)
end



function FibonacciHeapNode:getDegree()
  return #self.children
end



function FibonacciHeapNode:setRoot(root)
  self.root = root

  if root == self then
    self.parent = root
  end

  if #self.children > 0 then
    for _, child in ipairs(self.children) do
      child.root = root
    end
  end
end



function FibonacciHeapNode:isRoot()
  return self.root == self
end



FibonacciHeap = {}
FibonacciHeap.__index = FibonacciHeap



function FibonacciHeap:new()
  local heap = {
    trees = trees or {},
    minimum = nil,
  }
  setmetatable(heap, FibonacciHeap)
  return heap
end



function FibonacciHeap:insert(value)
  local node = FibonacciHeapNode:new(value)
  local heap = FibonacciHeap:new()
  table.insert(heap.trees, node)
  self:merge(heap)
  return node
end



function FibonacciHeap:merge(other)
  for _, tree in ipairs(other.trees) do
    table.insert(self.trees, tree)
  end
  self:updateMinimum()
end



function FibonacciHeap:extractMinimum()
  if self.minimum then
    local minimum = self:removeTableElement(self.trees, self.minimum)

    for _, child in ipairs(minimum.children) do
      child.root = child
      table.insert(self.trees, child)
    end

    local same_degrees_found = true
    while same_degrees_found do
      same_degrees_found = false

      local degrees = {}

      for _, root in ipairs(self.trees) do
        local degree = root:getDegree()

        if degrees[degree] then
          if root.value < degrees[degree].value then
            self:linkRoots(root, degrees[degree])
          else
            self:linkRoots(degrees[degree], root)
          end

          degrees[degree] = nil
          same_degrees_found = true
          break
        else
          degrees[degree] = root
        end
      end
    end

    self:updateMinimum()

    return minimum
  end
end



function FibonacciHeap:updateValue(node, value)
  local old_value = node.value
  local new_value = value

  if new_value <= old_value then
    self:decreaseValue(node, value)
  else
    assert(false, 'FibonacciHeap:increaseValue is not implemented yet')
  end
end



function FibonacciHeap:decreaseValue(node, value)
  assert(value <= node.value)

  node.value = value
  
  if node.value < node.parent.value then
    local parent = node.parent
    self:cutFromParent(node)

    if not parent:isRoot() then
      if parent.marked then
        self:cutFromParent(parent)
      else
        parent.marked = true
      end
    end
  end

  if node.value < self.minimum.value then
    self.minimum = node
  end
end



function FibonacciHeap:delete(node)
  self:decreaseValue(node, -math.huge)
  self:extractMinimum()
end



function FibonacciHeap:linkRoots(root, child)
  child.root = root
  child.parent = root
  
  child = self:removeTableElement(self.trees, child)
  table.insert(root.children, child)

  return root
end



function FibonacciHeap:cutFromParent(node)
  local parent = node.parent

  node.root = node
  node.parent = node
  node.marked = false

  node = self:removeTableElement(parent.children, node)
  table.insert(self.trees, node)
end



function FibonacciHeap:updateMinimum()
  self.minimum = self.trees[1]

  for _, root in ipairs(self.trees) do
    if root.value < self.minimum.value then
      self.minimum = root
    end
  end
end



function FibonacciHeap:removeTableElement(input_table, element)
  for i = 1, #input_table do
    if input_table[i] == element then
      return table.remove(input_table, i)
    end
  end
end
