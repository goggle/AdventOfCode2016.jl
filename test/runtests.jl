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
    sample = "abc"
    @test AdventOfCode2016.Day05.part1(sample, len=2) == "18"
    @test AdventOfCode2016.Day05.part2(sample, len=2) == "05"
end

@testset "Day 6" begin
    sample = "eedadn\n" *
             "drvtee\n" *
             "eandsr\n" *
             "raavrd\n" *
             "atevrs\n" *
             "tsrnev\n" *
             "sdttsa\n" *
             "rasrtv\n" *
             "nssdts\n" *
             "ntnada\n" *
             "svetve\n" *
             "tesnvt\n" *
             "vntsnd\n" *
             "vrdear\n" *
             "dvrsen\n" *
             "enarar\n"
    @test AdventOfCode2016.Day06.day06(sample) == ["easter", "advent"]
    @test AdventOfCode2016.Day06.day06() == ["umcvzsmw", "rwqoacfz"]
end

@testset "Day 7" begin
    @test AdventOfCode2016.Day07.supports_tls("abba[mnop]qrst") == true
    @test AdventOfCode2016.Day07.supports_tls("abcd[bddb]xyyx") == false
    @test AdventOfCode2016.Day07.supports_tls("aaaa[qwer]tyui") == false
    @test AdventOfCode2016.Day07.supports_tls("ioxxoj[asdfgh]zxcvbn") == true

    @test AdventOfCode2016.Day07.supports_ssl("aba[bab]xyz") == true
    @test AdventOfCode2016.Day07.supports_ssl("xyx[xyx]xyx") == false
    @test AdventOfCode2016.Day07.supports_ssl("aaa[kek]eke") == true
    @test AdventOfCode2016.Day07.supports_ssl("zazbz[bzb]cdb") == true

    @test AdventOfCode2016.Day07.day07() == [110, 242]
end