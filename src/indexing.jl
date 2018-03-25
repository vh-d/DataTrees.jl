
# Indexing --------------------
function get{T, S}(tn::TreeNode{T, S})
    return tn
end

function getindex{T, S}(tn::TreeNode{T, S}, key::S)
    tn.children[key]
end

function getindex{T, S}(tn::TreeNode{T, S}, key::Vector{S})
    if isempty(key) error("Empty path/key") end

    keys = copy(key)

    current_key = shift!(keys)

    if haskey(tn.children, current_key)
        if length(key) > 0
            return(getindex(tn.children[current_key], keys))
        else
            return(tn.children[current_key])
        end
    else
        KeyError(current_key)
    end
end

"""
Verify that a node is a root node.
"""
function isroot{T, S}(tn::TreeNode{T, S})
    isnull(tn.parent)
end

function isroot{T, S}(tn::Nullable{TreeNode{T, S}})
    isnull(tn) ? Nullable{bool}() : isroot(get(tn))
end


"""
Verify if a node is a leaf (ie does not have children).
"""
function isleaf{T, S}(tn::TreeNode{T, S})
    return length(tn.children) == 0
end

function isleaf{T, S}(tn::Nullable{TreeNode{T, S}})
    return isnull(tn) ? Nullable{Bool}() : length(get(tn).children) == 0
end

"""
Find the root node of a tree.
"""
function getroot{T, S}(tn::TreeNode{T, S})
    if isroot(tn)
        return(tn)
    else
        getroot(get(tn.parent))
    end
end


"""
Compute depth of a node (its distance from root)
"""
function getdepth{T, S}(tn::TreeNode{T, S})
    if isroot(tn)
        return(0)
    else
        return(1 + getdepth(get(tn.parent)))
    end
end

function getdepth{T, S}(tn::Nullable{TreeNode{T, S}})
    if isnull(tn)
        return 0
    else
        return getdepth(get(tn))
    end
end



"""
Get sibilings of a node.
"""
function getsiblings{T, S}(tn::TreeNode{T, S})
    if (!isnull(tn.parent))
        allchildren = copy(get(tn.parent).children)
        delete!(allchildren, tn.id) # remove itself from the result
    else nothing end
end
