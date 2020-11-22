module TestDivideAtMean
using Random
using TapirBenchmarks
using Test
using Statistics

tests = [
    (label = "1:10", xs = 1:10, smaller = 1:5, larger = 6:10),
    (label = "10:-1:1", xs = 10:-1:1, smaller = 6:10, larger = 1:5),
    let xs = shuffle(1:10)
        m = mean(xs)
        (
            label = "shuffle(1:10)",
            xs = xs,
            smaller = findall(xs .<= m),
            larger = findall(xs .> m),
        )
    end,
]

@testset "$(t.label)" for t in tests
    @testset for f in [divide_at_mean_seq, divide_at_mean_threads, divide_at_mean_tapir]
        smaller, larger = f(t.xs)
        @test smaller == t.smaller
        @test larger == t.larger
    end
end

end
