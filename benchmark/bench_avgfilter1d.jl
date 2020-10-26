module BenchAvgFilter1D

import Random
using BenchmarkTools
using TapirBenchmarks

Random.seed!(1234)

const SUITE = BenchmarkGroup()

for n in [2^25, 2^27]
    SUITE[:n=>n] = s0 = BenchmarkGroup()
    ys0, xs = avgfilter1d_setup(n)
    s0[:impl=>:seq] = @benchmarkable avgfilter1d_seq!($(copy(ys0)), $xs)
    s0[:impl=>:threads] = @benchmarkable avgfilter1d_threads!($(copy(ys0)), $xs)
    s0[:impl=>:tapir_dac] = @benchmarkable avgfilter1d_tapir_dac!($(copy(ys0)), $xs)
    # s0[:impl=>:tapir_seq] = @benchmarkable avgfilter1d_tapir_seq!($(copy(ys0)), $xs)
end

end
BenchAvgFilter1D.SUITE
