using TracedRandom, Random, Test

@testset "Addressed calls with global RNG" begin

for fn in (rand, randn, randexp, bitrand, randstring)
   Random.seed!(0)
   traced = fn(:addr)
   Random.seed!(0)
   untraced = fn()
   @test traced == untraced
end

for fn in (rand!, randn!, randexp!)
   Random.seed!(0)
   traced = fn(:addr, zeros(5))
   Random.seed!(0)
   untraced = fn(zeros(5))
   @test traced == untraced
end

for fn in (randperm, randcycle)
   Random.seed!(0)
   traced = fn(:addr, 5)
   Random.seed!(0)
   untraced = fn(5)
   @test traced == untraced
end

for fn in (randperm!, randcycle!)
   Random.seed!(0)
   traced = fn(:addr, Vector{Int}(undef, 5))
   Random.seed!(0)
   untraced = fn(Vector{Int}(undef, 5))
   @test traced == untraced
end

Random.seed!(0)
traced = shuffle(:addr, [1, 2, 3, 4, 5])
Random.seed!(0)
untraced = shuffle([1, 2, 3, 4, 5])
@test traced == untraced

Random.seed!(0)
traced = shuffle!(:addr, [1, 2, 3, 4, 5])
Random.seed!(0)
untraced = shuffle!([1, 2, 3, 4, 5])
@test traced == untraced

Random.seed!(0)
traced = randsubseq(:addr, [1, 2, 3, 4, 5], 0.2)
Random.seed!(0)
untraced = randsubseq([1, 2, 3, 4, 5], 0.2)
@test traced == untraced

Random.seed!(0)
traced = randsubseq!(:addr, [], [1, 2, 3, 4, 5], 0.2)
Random.seed!(0)
untraced = randsubseq!([], [1, 2, 3, 4, 5], 0.2)
@test traced == untraced

end

@testset "Addressed calls with custom RNG" begin

rng = MersenneTwister()

for fn in (rand, randn, randexp, bitrand, randstring)
   Random.seed!(rng, 42)
   traced = fn(rng, :addr)
   Random.seed!(rng, 42)
   untraced = fn(rng)
   @test traced == untraced
end

for fn in (rand!, randn!, randexp!)
   Random.seed!(rng, 42)
   traced = fn(rng, :addr, zeros(5))
   Random.seed!(rng, 42)
   untraced = fn(rng, zeros(5))
   @test traced == untraced
end

for fn in (randperm, randcycle)
   Random.seed!(rng, 42)
   traced = fn(rng, :addr, 5)
   Random.seed!(rng, 42)
   untraced = fn(rng, 5)
   @test traced == untraced
end

for fn in (randperm!, randcycle!)
   Random.seed!(rng, 42)
   traced = fn(rng, :addr, Vector{Int}(undef, 5))
   Random.seed!(rng, 42)
   untraced = fn(rng, Vector{Int}(undef, 5))
   @test traced == untraced
end

Random.seed!(rng, 42)
traced = shuffle(rng, :addr, [1, 2, 3, 4, 5])
Random.seed!(rng, 42)
untraced = shuffle(rng, [1, 2, 3, 4, 5])
@test traced == untraced

Random.seed!(rng, 42)
traced = shuffle!(rng, :addr, [1, 2, 3, 4, 5])
Random.seed!(rng, 42)
untraced = shuffle!(rng, [1, 2, 3, 4, 5])
@test traced == untraced

Random.seed!(rng, 42)
traced = randsubseq(rng, :addr, [1, 2, 3, 4, 5], 0.2)
Random.seed!(rng, 42)
untraced = randsubseq(rng, [1, 2, 3, 4, 5], 0.2)
@test traced == untraced

Random.seed!(rng, 42)
traced = randsubseq!(rng, :addr, [], [1, 2, 3, 4, 5], 0.2)
Random.seed!(rng, 42)
untraced = randsubseq!(rng, [], [1, 2, 3, 4, 5], 0.2)
@test traced == untraced

end
