module TestMeanVar

using TapirBenchmarks
using Test

@testset begin
    xs = randn(1000)
    m1, v1 = meanvar_seq(xs)
    m2, v2 = meanvar_threads(xs)
    m3, v3 = meanvar_tapir(xs)
    @test m1 ≈ m2 ≈ m3
    @test v1 ≈ v2 ≈ v3
end

end
