

# Traversing -------------------------

function traverse(tn::TreeNode, f::Function, args...)

    if !isempty(args)
        f(tn, args...)
    else
        f(tn)
    end

    if !isleaf(tn)
        for (key, chnode) in tn.children
            traverse(chnode, f, args...)
        end
    end
end

function traverse(tn::Nullable{TreeNode}, args...)
    isnull(tn) ? nothing : traverse(get(tn), args...)
end
