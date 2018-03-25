# Printing -----------------------------

function printpath{T, S}(tn::TreeNode{T, S}, path::Vector{S} = Vector{S}(); sep = "/", io::IO = STDOUT)

    push!(path, tn.id)

    println(io, join(path, sep))

    if !isleaf(tn)
        for (key, chnode) in tn.children
            printpath(chnode, path; sep = sep, io = io)
        end
    end

    pop!(path)

    nothing
end

function printpath{T, S}(tn::TreeNode{T, S}; sep = "/", io::IO = STDOUT)
    
    path = Vector{S}()

    printpath(tn, path; sep = sep, io = io)
end


"""
# Usage
Prints an UTF-8 formatted representation of the `tree`.
# Examples

```julia
julia> print(tree)
```
"""
function print{T, S}(tn::TreeNode{T, S}; leading::AbstractString = "", io::IO = STDOUT)

    println(io, tn.id)

    if !isleaf(tn)
        last = length(tn.children)
        i::Int = 0
        for (key, chnode) in tn.children
            i += 1
            if (i != last)
                to_print    = leading * "\u251C\u2500 " # ├─
                new_leading = leading * "\u2502  " # │
            else
                to_print    = leading * "\u2514\u2500 " # └─
                new_leading = leading * "   "
            end

            print(io, to_print)
            print(chnode; leading = new_leading, io = io)
        end
    end
end

function print{T, S}(tn::Nullable{TreeNode{T, S}}; args...)
    isnull(tn) ? nothing : print(get(tn); args...)
end
