module BenchDivideAtMeanWithMap
using Random
using BenchmarkTools
using TapirBenchmarks

Random.seed!(1234)

const SUITE = BenchmarkGroup()

@inline square(x) = x^2

for f in [sin, square]
    n = 2^20
    SUITE[:f=>Symbol(f)] = s0 = BenchmarkGroup()
    xs = rand(n)
    s0[:impl=>:seq] = @benchmarkable divide_at_mean_seq($f, $xs)
    s0[:impl=>:threads] = @benchmarkable divide_at_mean_threads($f, $xs)
    s0[:impl=>:tapir] = @benchmarkable divide_at_mean_tapir($f, $xs)
end

end
BenchDivideAtMeanWithMap.SUITE
