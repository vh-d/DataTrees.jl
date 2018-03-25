# basic building block is TreeNode
type TreeNode{T, S}
    id::S
    data::T
    parent::Nullable{TreeNode{T,S}}
    children::Dict{S, TreeNode{T,S}}
    # isLeaf::Bool

    # constructors ---------------------------------------
    # with name, but without data
    function TreeNode{T, S}(id::S) where {T, S}
        x = new()
        x.id = id
        x.parent = Nullable{TreeNode{T,S}}()
        x.children = Dict{S, TreeNode{T,S}}()

        return(x)
    end

    # with name and data
    function TreeNode{T, S}(id::S, data::T) where {T, S}
        x = new()
        x.id = id
        x.parent = Nullable{TreeNode{T,S}}()
        x.children = Dict{S, TreeNode{T,S}}()
        x.data = data

        return(x)
    end
end
