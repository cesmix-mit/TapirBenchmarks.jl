module TestAvgFilter1D

using TapirBenchmarks
using Test

@testset for n in [3, 5, 100, 2^8]
    ys0, xs = avgfilter1d_setup(n)
    ys1 = avgfilter1d_seq!(copy(ys0), xs)
    @test avgfilter1d_threads!(copy(ys0), xs) == ys1
    @test avgfilter1d_tapir_dac!(copy(ys0), xs) == ys1
    @test avgfilter1d_tapir_seq!(copy(ys0), xs) == ys1
end

end
