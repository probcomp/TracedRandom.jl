module TracedRandom

using Random

export rand!, randn!, randexp, randexp!,
       bitrand, randstring, randsubseq, randsubseq!,
       shuffle, shuffle!, randperm, randperm!, randcycle, randcycle!

const Address = Union{Symbol,Pair{Symbol}}

Base.rand(::Address, fn::Function, args...) = fn(args...)
Base.rand(::AbstractRNG, ::Address, fn::Function, args...) = fn(args...)

Base.rand(::Address, args...) = rand(args...)
Base.rand(rng::AbstractRNG, ::Address, args...) = rand(rng, args...)

Base.randn(::Address, args...) = randn(args...)
Base.randn(rng::AbstractRNG, ::Address, args...) = randn(rng, args...)

for fn in (:rand!, :randn!, :randexp, :randexp!, :bitrand, :randstring,
           :randsubseq, :randsubseq!, :shuffle, :shuffle!,
           :randperm, :randperm!, :randcycle, :randcycle!)
    fn = GlobalRef(Random, fn)
    @eval $fn(::Address, args...) = $fn(args...)
    @eval $fn(rng::AbstractRNG, ::Address, args...) = $fn(rng, args...)
end

end
