


"""
Creates a new child and push it to node's children
"""
function addchild!{T,S}(
  parent::TreeNode{T,S},
  childid::S)

  newnode = TreeNode{T,S}(childid)
  newnode.parent = parent
  push!(parent.children, newnode.id => newnode)
end



function addchild!{T,S}(
  parent::TreeNode{T,S},
  childid::S,
  data::T)

  newnode = TreeNode{T,S}(childid, data)
  newnode.parent = parent
  push!(parent.children, newnode.id => newnode)
end


function addchild!{T,S}(
    parent::TreeNode{T,S},
    child::TreeNode{T,S})

    child.parent = parent
    push!(parent.children, child.id => child)
end


# TODO: undefined data!
"""
Adds node(s) defined by path to a tree.
"""
function addsubtree!{T, S}(tn::TreeNode{T, S}, path::Vector{S})

    path_array = copy(path)

    next_level::S = shift!(path_array)

    if !haskey(tn.children, next_level)
        addchild!(tn, next_level)
    end

    if !isempty(path_array)
        addsubtree!(tn[next_level], path_array)
    end
end



"""
Build a tree from various data structures.
"""
function buildtree{S}(id::S, T::Type, paths::Vector{String}, sepsymbol = "/")

    splitpath(string)::Array{S, 1} = split(string, sepsymbol, keep = false)

    splitted::Array{Array{S, 1}} = broadcast(splitpath, paths)

    tree = TreeNode{T, S}(id)

    for path in splitted
        addsubtree!(tree, path)
    end

    return tree
end

# array where each row is a vector of paths
function buildtree{S}(id::S, T::Type, paths::Array{S, 2})

    tree = TreeNode{T, S}(id)

    for i in 1:size(paths)[1]
        addsubtree!(tree, paths[i, :])
    end

    return tree
end


# build a tree from and array of edges (tuples)
# TODO: check for multiple parents
function buildtree{S}(T::Type, edges::Array{Tuple{S, S}, 1})
    # tree = TreeNode{T, S}(name)

    existing = Dict{S, TreeNode{T, S}}()
    # push!(existing, name => tree)

    for (child_node, parent_node) in edges
        if !haskey(existing, child_node)  existing[child_node]  = TreeNode{T, S}(child_node) end
        if !haskey(existing, parent_node) existing[parent_node] = TreeNode{T, S}(parent_node) end

        addchild!(existing[parent_node], existing[child_node])
    end

    getroot(existing[edges[1][1]])
end


# build a tree from and 2-dim array of edges
# TODO: handle duplicate edges (which would not pass the assert test)
function buildtree{S}(T::Type, edges::Array{S, 2})::TreeNode{T, S}
    # check that each node has only one parent
    assert(unique(edges[:, 1]) == edges[:, 1])

    existing = Dict{S, TreeNode{T, S}}()
    # push!(existing, name => tree)

    for i in 1:size(edges)[1]
        child_node  = edges[i, 1]
        parent_node = edges[i, 2]

        if !haskey(existing, child_node)  existing[child_node]  = TreeNode{T, S}(child_node) end
        if !haskey(existing, parent_node) existing[parent_node] = TreeNode{T, S}(parent_node) end

        addchild!(existing[parent_node], existing[child_node])
    end

    getroot(existing[edges[1, 1]])
end

# build a tree from and array of edges and dictionary of data
function buildtree{T, S}(data::Dict{S, T}, edges::Vector{Tuple{S, S}})::TreeNode{T, S}
    # tree = TreeNode{T, S}(name)

    existing = Dict{S, TreeNode{T, S}}()
    # push!(existing, name => tree)

    for (child_node, parent_node) in edges
        if !haskey(existing, child_node)  existing[child_node]  = TreeNode{T, S}(child_node, data[child_node]) end
        if !haskey(existing, parent_node) existing[parent_node] = TreeNode{T, S}(parent_node, data[parent_node]) end

        addchild!(existing[parent_node], existing[child_node], data[child_node])
    end

    getroot(existing[edges[1][1]])
end

function buildtree{T, S}(nodes::Vector{Tuple{S, S, T}})::TreeNode{T, S}
    # tree = TreeNode{T, S}(name)

    existing = Dict{S, TreeNode{T, S}}()
    # push!(existing, name => tree)

    for (child_node, parent_node, data) in nodes
        if !haskey(existing, child_node)  existing[child_node]  = TreeNode{T, S}(child_node, data) end
        if !haskey(existing, parent_node) existing[parent_node] = TreeNode{T, S}(parent_node, data) end

        addchild!(existing[parent_node], existing[child_node])
    end

    getroot(existing[nodes[1][1]])
end
