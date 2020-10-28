function avgfilter1d_constprop_setup(n, w = 3)
    xs = rand(SVector{w,UInt8}, n)
    ys = zero(xs)
    return (; ys, xs)
end

@inline function avg_at(xs0, i, N)
    @static if USE_ALIASSCOPE
        xs = Const(xs0)
    else
        xs = xs0
    end
    s = zero(eltype(xs))
    for k in 1:N
        s = s .+ @inbounds xs[i + k - 1]
    end
    return s .÷ N
end

@inline function avgfilter1d_constprop_seq!(ys, xs, N = 4)
    @assert axes(ys) == axes(xs)
    for i0 in 0:length(xs) - N
        i = firstindex(xs) + i0
        @inbounds ys[i] = avg_at(xs, i, N)
    end
    return ys
end

@inline function avgfilter1d_constprop_threads!(ys, xs, N = 4)
    @assert axes(ys) == axes(xs)
    Threads.@threads for i0 in 0:length(xs) - N
        i = firstindex(xs) + i0
        @inbounds ys[i] = avg_at(xs, i, N)
    end
    return ys
end

# Using `@inline` to nudge that the 3-arg method sees the constant 4 set by the
# "outer" 2-arg function.
@inline function avgfilter1d_constprop_tapir_dac!(ys, xs, N = 4)
    @assert axes(ys) == axes(xs)
    GC.@preserve ys xs begin  # TODO: don't use preserve
        Tapir.@par dac for i0 in 0:length(xs) - N
            i = firstindex(xs) + i0
            @inbounds ys[i] = avg_at(xs, i, N)
            @grainsize 131072
        end
    end
    return ys
end

@inline function avgfilter1d_constprop_tapir_dac_nopreserve!(ys, xs, N = 4)
    @assert axes(ys) == axes(xs)
    begin
        Tapir.@par dac for i0 in 0:length(xs) - N
            i = firstindex(xs) + i0
            @inbounds ys[i] = avg_at(xs, i, N)
            @grainsize 131072
        end
    end
    return ys
end

@inline function avgfilter1d_constprop_tapir_seq!(ys, xs, N = 4)
    @assert axes(ys) == axes(xs)
    GC.@preserve ys xs begin  # TODO: don't use preserve
        Tapir.@par seq for i0 in 0:length(xs) - N
            i = firstindex(xs) + i0
            @inbounds ys[i] = avg_at(xs, i, N)
            @grainsize 131072
        end
    end
    return ys
end
