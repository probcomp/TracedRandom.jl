module TracedRandom

using Random

export here, rand!, randn!, randexp, randexp!,
       bitrand, randstring, randsubseq, randsubseq!,
       shuffle, shuffle!, randperm, randperm!, randcycle, randcycle!

const Address = Union{Symbol,Pair{Symbol}}

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

for fn in (:rand, :rand!, :randn!, :randexp, :randexp!, :bitrand, :randstring,
           :randsubseq, :randsubseq!, :shuffle, :shuffle!,
           :randperm, :randperm!, :randcycle, :randcycle!)
    @eval begin
    @doc """
        $($fn)([rng=GLOBAL_RNG,] addr::Address, args...)

    Traced execution of `$($fn)`, where `addr` specifies the name / address of
    the random choice. By default, the address `addr` is ignored, but it can
    be intercepted to support inference in a probabilistic programming system.
    An `Address` is either a `Symbol`, or a `Pair` that begins with a `Symbol`.
    """
    $fn
    end
end

"Singleton type for the special [`here`](@ref) address."
struct Here end

"""
    here

Special address that refers to the address namespace of the calling context.
Supported when [`rand`](@ref) is called on a non-primitive stochastic function,
causing all named random variables sampled by that function to be spliced into
the address namespace of the calling context.
"""
const here = Here()

"""
    rand([rng=GLOBAL_RNG,] addr::Union{Here,Address}, fn::Function, args...)

Traced execution of a stochastic function `fn`, where `addr` specifies the
address namespace for any primitive random choices made within the call to `fn`.
By default, the address `addr` is ignored, but it can be intercepted to support
inference in a probabilistic programming system.

An `Address` is either a `Symbol`, or a `Pair` that begins with a `Symbol`.
Alternatively, if the special address [`here`](@ref) is specified, then all
traced random choices made by `fn` will be spliced into the namespace of the
calling context.
"""
Base.rand(::Here, fn::Function, args...) = fn(args...)
Base.rand(::AbstractRNG, ::Here, fn::Function, args...) = fn(args...)

Base.rand(::Address, fn::Function, args...) = fn(args...)
Base.rand(::AbstractRNG, ::Address, fn::Function, args...) = fn(args...)

end
