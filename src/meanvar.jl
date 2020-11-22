function meanvar_seq(xs)
    m = mean(xs)
    return m, var(xs, mean = m)
end

function meanvar_threads(xs)
    m = ThreadsFolds.mean(xs)
    s = ThreadsFolds.sum(x -> (x - m)^2, xs)
    return m, s / (length(xs) - 1)
end

function meanvar_tapir(xs)
    m = TapirFolds.mean(xs)
    s = TapirFolds.sum(x -> (x - m)^2, xs)
    return m, s / (length(xs) - 1)
end
