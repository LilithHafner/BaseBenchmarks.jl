module StringBenchmarks

import ..BaseBenchmarks
using ..BenchmarkTrackers

####################
# replace (#12224) #
####################

@track BaseBenchmarks.TRACKER "string replace" begin
    @setup str = join(BaseBenchmarks.samerand('a':'d', 10^4))
    @benchmarks begin
        (:replace,) => replace(str, "a", "b")
    end
    @tags "string" "replace"
end

end # module