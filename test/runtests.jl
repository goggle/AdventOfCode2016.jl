using AdventOfCode2016
using Test

@testset "Day 1" begin
    @test AdventOfCode2016.Day01.day01() == [273, 115]
end

@testset "Day 2" begin
    sample = "ULL\n" *
             "RRDDD\n" *
             "LURDL\n" *
             "UUUUD\n"
    @test AdventOfCode2016.Day02.day02(sample) == [1985, "5DB3"]
    @test AdventOfCode2016.Day02.day02() == [61529, "C2C28"]
end

@testset "Day 3" begin
    @test AdventOfCode2016.Day03.day03() == [1032, 1838]
end