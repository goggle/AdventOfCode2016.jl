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

@testset "Day 4" begin
    @test AdventOfCode2016.Day04.is_real("aaaaa-bbb-z-y-x-123[abxyz]") == true
    @test AdventOfCode2016.Day04.is_real("a-b-c-d-e-f-g-h-987[abcde]") == true
    @test AdventOfCode2016.Day04.is_real("not-a-real-room-404[oarel]") == true
    @test AdventOfCode2016.Day04.is_real("totally-real-room-200[decoy]") == false
    @test AdventOfCode2016.Day04.decrypt("qzmt-zixmtkozy-ivhz", 343) == "very encrypted name"
    @test AdventOfCode2016.Day04.day04() == [185371, 984]
end

@testset "Day 5" begin
    @test AdventOfCode2016.Day05.day05() == ["4543c154", "1050cbbd"]
end