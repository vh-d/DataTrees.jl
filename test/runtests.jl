using DataTrees
using Base.Test

@test TreeNode{String, String} <: TreeNode

tree = TreeNode{Int, String}("Tree", 0)
@test isa(tree, TreeNode)
@test isroot(tree)
@test isleaf(tree)
@test get(tree) == tree

for i in 1:3 addchild!(tree, "Child $i", i) end

print(tree)
@test !isnull(tree["Child 1"])
@test !isroot(tree["Child 2"])
@test isleaf(tree["Child 3"])
@test getdepth(tree) == 0

addchild!(tree["Child 1"], TreeNode{Int, String}("Grand child 1", 10))
t = tree["Child 1"]["Grand child 1"]
@test t.data == 10
@test isleaf(t)
@test !isleaf(t.parent)
@test !isroot(t.parent)
@test getdepth(t.parent) == 1
@test getdepth(t) == 2

@test print(tree.parent) == nothing

addsubtree!(tree, ["Child 2", "Foo", "bar"])
@test isleaf(tree[["Child 2", "Foo", "bar"]])

# tree from an array of edges
a = [1 0;
     2 1;
     3 1;
     4 0;
     5 4;
     6 4]
t_from_edges = buildtree(Int64, a)
@test isa(t_from_edges[4], TreeNode{Int,Int})

# tree from tuples with data
treedata = [(1, 0, "data1"), (2, 1, "data2")]
t_with_data = buildtree(treedata)
@test t_with_data[1].data == "data1"
