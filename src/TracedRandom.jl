module TracedRandom

using Random

export here, rand!, randn!, randexp, randexp!,
       bitrand, randstring, randsubseq, randsubseq!,
       shuffle, shuffle!, randperm, randperm!, randcycle, randcycle!

const Address = Union{Symbol,Pair{Symbol}}

struct Here end

"""
    here

Special address that refers to the address namespace of the calling context.
Supported when [`rand`](@ref) is called on a non-primitive stochastic function,
causing all named random variables sampled by that function to be spliced into
the address namespace of the calling context. 
"""
const here = Here()

Base.rand(::Here, fn::Function, args...) = fn(args...)
Base.rand(::AbstractRNG, ::Here, fn::Function, args...) = fn(args...)

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
