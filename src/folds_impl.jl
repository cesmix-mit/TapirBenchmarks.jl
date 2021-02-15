fold(op::OP, xs; kw...) where {OP} = mapfold(identity, op, xs; kw...)

function mapfold(
    f::F,
    op::OP,
    xs::AbstractArray;
    basesize = cld(length(xs), Threads.nthreads()),
) where {F,OP}
    basesize = max(3, basesize)  # for length(left) + length(right) >= 4
    if length(xs) < basesize
        return mapfoldl(f, op, xs)
    end
    return _mapfold(f, op, xs, basesize)
end

function _mapfold(f::F, op::OP, xs, basesize) where {F,OP}
    if length(xs) <= basesize
        acc = @inbounds op(f(xs[begin]), f(xs[begin+1]))
        @simd for i in eachindex(xs)[3:end]
            acc = op(acc, f(@inbounds xs[i]))
        end
        return acc
    else
        left = @inbounds @view xs[begin:(end-begin+1)÷2]
        right = @inbounds @view xs[(end-begin+1)÷2+1:end]
        local y, z
        Tapir.@sync begin
            Tapir.@spawn z = _mapfold(f, op, right, basesize)
            y = _mapfold(f, op, left, basesize)
        end
        return op(y, z)
    end
end

function append!!(a, b)
    ys::Vector = a isa Vector ? a : collect(a)
    if eltype(b) <: eltype(ys)
        zs = append!(ys, b)
    else
        zs = similar(ys, promote_type(eltype(ys), eltype(b)), (length(ys) + length(b)))
        copyto!(zs, 1, ys, 1, length(ys))
        zs[length(ys)+1:end] .= b
    end
    return zs
end

function tmap(f::F, xs; kw...) where {F}
    ys = mapfold(tuple ∘ f, append!!, xs; kw...)
    if ys isa Tuple
        return collect(ys)
    else
        return ys
    end
end

function tforeach(f::F, xs; kw...) where {F}
    mapfold(f, (_, _) -> nothing, xs; kw...)
    return
end


sum(f::F, xs) where {F} = mapfold(f, +, xs)
sum(xs) = sum(identity, xs)
mean(f::F, xs) where {F} = sum(f, xs) / length(xs)
mean(xs) = mean(identity, xs)
