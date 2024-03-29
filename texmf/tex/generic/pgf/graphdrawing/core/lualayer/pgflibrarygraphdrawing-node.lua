-- Copyright 2010 by Renée Ahrens, Olof Frahm, Jens Kluttig, Matthias Schulz, Stephan Schuster
-- Copyright 2011 by Jannis Pohlmann
--
-- This file may be distributed an/or modified
--
-- 1. under the LaTeX Project Public License and/or
-- 2. under the GNU Public License
--
-- See the file doc/generic/pgf/licenses/LICENSE for more information

-- @release $Header: /home/mojca/cron/mojca/github/cvs/pgf/pgf/generic/pgf/graphdrawing/core/lualayer/pgflibrarygraphdrawing-node.lua,v 1.5 2011/07/20 21:00:58 jannis-pohlmann Exp $

-- This file defines a node class, used in the graph representation.

pgf.module("pgf.graphdrawing")



Node = Box:new{}
Node.__index = Node



--- Creates a new node.
--
-- @param values  Values to override default node settings.
--                The following parameters can be set:\par
--                |name|: The name of the node. It is obligatory to define this.\par
--                |tex|:  Information about the corresponding \TeX\ node.\par
--                |edges|: Edges adjacent to the node.\par
--                |pos|: Initial position of the node.\par
--                |options|: A table of node options passed over from \tikzname.
--
-- @return A newly allocated node.
--
function Node:new(values)
  local defaults = {
    name = "node",
    tex = { 
      texNode = nil,
      maxX = 0,
      minX = 0,
      maxY = 0,
      minY = 0 
    },
    edges = {},
    pos = Vector:new(2),
    options = {},
  }
  setmetatable(defaults, Node)
  local result = table.custom_merge(values, defaults)
  return result
end



--- Sets the node option \meta{name} to \meta{value}.
--
-- @param name Name of the node option to be changed.
-- @param value New value for the node option \meta{name}.
--
function Node:setOption(name, value)
  self.options[name] = value
end



--- Returns the value of the node option \meta{name}.
--
-- @param name Name of the node option.
--
-- @return The value of the node option \meta{name} or |nil|.
--
function Node:getOption(name)
   return self.options[name] or Interface.defaultGraphParameters[name]
end



--- Computes the width of the node.
--
-- @return Width of the node.
--
function Node:getTexWidth()
	return math.abs(self.tex.maxX - self.tex.minX)
end



--- Computes the heigth of the node.
--
-- @return Height of the node.
--
function Node:getTexHeight()
  return math.abs(self.tex.maxY - self.tex.minY)
end



--- Adds new edge to the node.
--
-- @param edge The edge to be added.
--
function Node:addEdge(edge)
  --if not table.find(self.edges, function (other) return other == edge end) then
    table.insert(self.edges, edge)
  --end
end



--- Removes an edge from the node.
--
-- @param edge The edge to remove.
--
function Node:removeEdge(edge)
  table.remove_values(self.edges, function (other) return other == edge end)
end



--- Counts the adjacent edges of the node.
--
-- @return The number of adjacent edges of the node.
--
function Node:getDegree()
	return table.count_pairs(self.edges)
end



--- Returns all edges of the node.
--
-- Instead of calling |node:getEdges()| the edges can alternatively be 
-- accessed directly with |node.edges|.
--
-- @return All edges of the node.
--
function Node:getEdges()
  return self.edges
end



--- Returns the incoming edges of the node. Undefined result for hyperedges.
--
-- @param ignore_reversed Optional parameter to consider reversed edges not 
--                        reversed for this method call. Defaults to |false|.
--
-- @return Incoming edges of the node. This includes undirected edges
--         and directed edges pointing to the node.
--
function Node:getIncomingEdges(ignore_reversed)
  return table.filter_values(self.edges, function (edge) 
    return edge:isHead(self, ignore_reversed)
  end)
end



--- Returns the outgoing edges of the node. Undefined result for hyperedges.
--
-- @param ignore_reversed Optional parameter to consider reversed edges not 
--                        reversed for this method call. Defaults to |false|.
--
-- @return Outgoing edges of the node. This includes undirected edges
--         and directed edges leaving the node.
--
function Node:getOutgoingEdges(ignore_reversed)
  return table.filter_values(self.edges, function (edge)
    return edge:isTail(self, ignore_reversed)
  end)
end



--- Returns the number of incoming edges of the node.
--
-- @see Node:getIncomingEdges(reversed)
--
-- @param ignore_reversed Optional parameter to consider reversed edges not 
--                        reversed for this method call. Defaults to |false|.
--
-- @return The number of incoming edges of the node.
--
function Node:getInDegree(ignore_reversed)
  return table.count_pairs(self:getIncomingEdges(ignore_reversed))
end



--- Returns the number of edges starting at the node.
--
-- @see Node:getOutgoingEdges()
--
-- @param ignore_reversed Optional parameter to consider reversed edges not 
--                        reversed for this method call. Defaults to |false|.
--
-- @return The number of outgoing edges of the node.
--
function Node:getOutDegree(ignore_reversed)
  return table.count_pairs(self:getOutgoingEdges(ignore_reversed))
end



--- Creates a shallow copy of the node. 
--
-- Most notably, the edges adjacent are not preserved in the copy.
--
-- @return Copy of the node.
--
function Node:copy()
  local result = table.custom_copy(self, Node:new())
  result.edges = {}
  return result
end



--- Compares two nodes by their name.
--
-- @ignore This should not appear in the documentation.
--
-- @param other Another node to compare with.
--
-- @return |true| if both nodes have the same name. |false| otherwise.
--
function Node:__eq(object)
  return self.name == object.name
end



--- Returns a formated string representation of the node.
--
-- @ignore This should not appear in the documentation.
--
-- @return String represenation of the node.
--
function Node:__tostring()
  local tmp = Node.__tostring
  Node.__tostring = nil
  local result = "Node<" .. tostring(self) .. ">(" .. self.name .. ")"
  Node.__tostring = tmp
  return result
end
