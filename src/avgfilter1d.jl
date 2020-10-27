function avgfilter1d_setup(n, w = 3)
    xs = rand(SVector{w,Int32}, n)
    ys = zero(xs)
    return (; ys, xs)
end

function avgfilter1d_seq!(ys, xs)
    @assert axes(ys) == axes(xs)
    n = length(xs) - 2
    for i0 in 0:n-1
        i = firstindex(xs) + i0 + 1
        @inbounds ys[i] = (xs[i-1] .+ xs[i] .+ xs[i+1]) .÷ 3
    end
    return ys
end

function avgfilter1d_threads!(ys, xs)
    @assert axes(ys) == axes(xs)
    n = length(xs) - 2
    Threads.@threads for i0 in 0:n-1
        i = firstindex(xs) + i0 + 1
        @inbounds ys[i] = (xs[i-1] .+ xs[i] .+ xs[i+1]) .÷ 3
    end
    return ys
end

function avgfilter1d_tapir_dac!(ys, xs)
    @assert axes(ys) == axes(xs)
    n = length(xs) - 2
    GC.@preserve ys xs begin  # TODO: don't use preserve
        Tapir.@par for i0 in 0:n-1
            i = firstindex(xs) + i0 + 1
            @inbounds ys[i] = (xs[i-1] .+ xs[i] .+ xs[i+1]) .÷ 3
            @grainsize 131072
        end
    end
    return ys
end

# This function should work; but it segfaults ATM
function avgfilter1d_tapir_dac_nopreserve!(ys, xs)
    @assert axes(ys) == axes(xs)
    n = length(xs) - 2
    begin
        Tapir.@par for i0 in 0:n-1
            i = firstindex(xs) + i0 + 1
            @inbounds ys[i] = (xs[i-1] .+ xs[i] .+ xs[i+1]) .÷ 3
            @grainsize 131072
        end
    end
    return ys
end

function avgfilter1d_tapir_seq!(ys, xs)
    @assert axes(ys) == axes(xs)
    n = length(xs) - 2
    GC.@preserve ys xs begin  # TODO: don't use preserve
        Tapir.@par seq for i0 in 0:n-1
            i = firstindex(xs) + i0 + 1
            @inbounds ys[i] = (xs[i-1] .+ xs[i] .+ xs[i+1]) .÷ 3
            @grainsize 131072
        end
    end
    return ys
end
