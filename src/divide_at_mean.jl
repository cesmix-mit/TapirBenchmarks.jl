function divide_at_mean_seq(xs)
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

function divide_at_mean_tapir(xs)
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

function divide_at_mean_threads(xs)
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
