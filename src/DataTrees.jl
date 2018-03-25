VERSION <= v"0.5.0" && __precompile__()

module DataTrees

import Base: start, next, done, get, getindex, print
# import isnull?
export TreeNode, addchild!, addsubtree!, buildtree, print, getroot, getdepth, getindex, getsiblings, isleaf, isroot, traverse

include("TreeNode.jl")
include("indexing.jl")
include("buildtree.jl")
include("printing.jl")
include("traversing.jl")

# interface for AbstractTrees
children(tn::TreeNode) = tn.children
start(tn::TreeNode) = start(tn.children)
next(tn::TreeNode, state) = next(tn.children, state)
done(tn::TreeNode, state) = done(tn.children, state)

# TODO: all relevant methods also for Nullable{TreeNode}?


end # module
