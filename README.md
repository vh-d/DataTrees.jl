# DataTrees.jl

***Package for convenient work with hierarchical data in Julia.***

***Highly experimental version!***


## Examples

### Building a tree

#### Manually

```julia
julia> using DataTrees

julia> tree = TreeNode{Int, String}("Tree", 0)

julia> for i in 1:5 addchild!(tree, "Child $i", i) end

julia> print(tree)
Tree
├─ Child 2
├─ Child 3
├─ Child 4
├─ Child 1
└─ Child 5
```


```julia
addchild!(tree["Child 1"], "Grandchild 1", 100)

julia> print(tree)
Tree
├─ Child 2
├─ Child 3
├─ Child 4
├─ Child 1
│  └─ Grandchild 1
└─ Child 5
```


#### From other data structures

A csv table of paths:

```julia
using DataFrames
using Requests
using DataTrees

url = "https://datahub.io/core/world-cities/r/world-cities.csv"
csvfile = get(url)
countries = readtable(IOBuffer(csvfile.data))
countries[ismissing.(countries[:subcountry]), :subcountry] = "" # fill-in missing values

countries_tree =
 buildtree("Countries",
           Array{String}(
                sort(countries[[:country, :subcountry, :name]], cols = [:country, :subcountry])
           ))
```

### Printing
```julia
print(countries_tree["Czech Republic"])
```


```
Czech Republic
├─ Ústecký
│  ├─ Kadaň
│  ├─ Klášterec nad Ohří
│  ├─ Bílina
│  ├─ Litvínov
│  ├─ Litoměřice
│  ├─ Žatec
│  ├─ Děčín
│  ├─ Most
│  ├─ Louny
│  ├─ Ústí nad Labem
│  ├─ Teplice
│  ├─ Varnsdorf
│  ├─ Bílina Kyselka
│  ├─ Chomutov
│  └─ Jirkov
├─ Central Bohemia
│  ├─ Kutná Hora
│  ├─ Mladá Boleslav
│  ├─ Slaný
│  ├─ Kladno
│  ├─ Kolín
│  ├─ Brandýs nad Labem-Stará Boleslav
│  ├─ Benešov
│  ├─ Příbram
│  ├─ Neratovice
│  ├─ Kralupy nad Vltavou
│  ├─ Beroun
│  ├─ Rakovník
│  └─ Mělník
├─ Královéhradecký
│  ├─ Náchod
│  ├─ Dvůr Králové nad Labem
│  ├─ Trutnov
│  ├─ Hradec Králové
│  └─ Jičín
├─ Karlovarský
│  ├─ Sokolov
│  ├─ Cheb
│  ├─ Ostrov
│  └─ Karlovy Vary
├─ Praha
│  ├─ Prosek
│  ├─ Modřany
│  ├─ Černý Most
│  ├─ Libeň
│  ├─ Braník
│  ├─ Prague
│  └─ Letňany

...
```

### Indexing a tree

```julia
print(countries_tree["Czech Republic"])
print(countries_tree["Czech Republic"]["Praha"]) # chaining
print(countries_tree[["Czech Republic", "Praha"]]) # or using a path vector
map(x -> print(countries_tree["Portugal"][x]), ["Faro", "Lisbon"])
```


### Traversing a tree

```julia
julia>function printdata(n)
        print("$(n.id): $(n.data)\n")
      end

julia> traverse(tree, printdata)
Tree: 0
Child 2: 2
Child 7: 7
Child 6: 6
Child 10: 10
Child 3: 3
Child 8: 8
Child 4: 4
Child 9: 9
Child 1: 1
Grandchild 1: 100
Child 5: 5

julia> function addone!(x)
           x.data += 1
       end

julia> traverse(tree, addone!)

julia> traverse(tree, printdata)
Tree: 1
Child 2: 3
Child 7: 8
Child 6: 7
Child 10: 11
Child 3: 4
Child 8: 9
Child 4: 5
Child 9: 10
Child 1: 2
Grandchild 1: 101
Child 5: 6
```


## Features

* [x] indexing
* [x] import from an edge-list array or vector of tuples
* [x] import from array of paths
* [ ] import from xml
* [ ] import from json
* [x] nice printing
* [ ] filtering / prunning
* [ ] printing with concise preview of data
* [ ] plotting
* [ ] documentation
