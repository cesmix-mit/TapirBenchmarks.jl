function divide_at_mean_seq(f, xs0)
    xs = similar(xs0)
    for i in eachindex(xs0, xs)
        @inbounds xs[i] = f(xs0[i])
    end
    m = mean(xs)
    larger = Vector{Int}(undef, length(xs))
    smaller = Vector{Int}(undef, length(xs))
    n_larger = 0
    n_smaller = 0
    for (i, x) in enumerate(xs)
        is_larger = x > m
        n_larger += is_larger
        n_smaller += !is_larger
        dest = ifelse(is_larger, larger, smaller)
        n = ifelse(is_larger, n_larger, n_smaller)
        @inbounds dest[n] = i
    end
    return resize!(smaller, n_smaller), resize!(larger, n_larger)
end

function divide_at_mean_threads(f, xs0)
    xs = similar(xs0)
    ThreadsFolds.tforeach(eachindex(xs0, xs)) do i
        @inbounds xs[i] = f(xs0[i])
    end
    m = ThreadsFolds.mean(xs)
    larger = Vector{Int}(undef, length(xs))
    smaller = Vector{Int}(undef, length(xs))
    n_larger = 0
    n_smaller = 0
    for (i, x) in enumerate(xs)
        is_larger = x > m
        n_larger += is_larger
        n_smaller += !is_larger
        dest = ifelse(is_larger, larger, smaller)
        n = ifelse(is_larger, n_larger, n_smaller)
        @inbounds dest[n] = i
    end
    return resize!(smaller, n_smaller), resize!(larger, n_larger)
end

function divide_at_mean_tapir(f, xs0)
    xs = similar(xs0)
    TapirFolds.tforeach(eachindex(xs0, xs)) do i
        @inbounds xs[i] = f(xs0[i])
    end
    m = TapirFolds.mean(xs)
    larger = Vector{Int}(undef, length(xs))
    smaller = Vector{Int}(undef, length(xs))
    n_larger = 0
    n_smaller = 0
    for (i, x) in enumerate(xs)
        is_larger = x > m
        n_larger += is_larger
        n_smaller += !is_larger
        dest = ifelse(is_larger, larger, smaller)
        n = ifelse(is_larger, n_larger, n_smaller)
        @inbounds dest[n] = i
    end
    return resize!(smaller, n_smaller), resize!(larger, n_larger)
end
