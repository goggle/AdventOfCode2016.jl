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

@testset "Day 8" begin
    screen = zeros(Bool, 3, 7)
    res1 = [1 1 1 0 0 0 0;
            1 1 1 0 0 0 0;
            0 0 0 0 0 0 0]
    AdventOfCode2016.Day08.rect!(screen, 3, 2)
    @test screen == res1
    res2 = [1 0 1 0 0 0 0;
            1 1 1 0 0 0 0;
            0 1 0 0 0 0 0]
    AdventOfCode2016.Day08.rotd!(screen, 1+1, 1)
    @test screen == res2
    res3 = [0 0 0 0 1 0 1;
            1 1 1 0 0 0 0;
            0 1 0 0 0 0 0]
    AdventOfCode2016.Day08.rotr!(screen, 0+1, 4)
    @test screen == res3
    res4 = [0 1 0 0 1 0 1;
            1 0 1 0 0 0 0;
            0 1 0 0 0 0 0]
    AdventOfCode2016.Day08.rotd!(screen, 1+1, 1)
    @test screen == res4
    image = " ██  ████ █    ████ █     ██  █   █████  ██   ███ \n" *
            "█  █ █    █    █    █    █  █ █   ██    █  █ █    \n" *
            "█    ███  █    ███  █    █  █  █ █ ███  █    █    \n" *
            "█    █    █    █    █    █  █   █  █    █     ██  \n" *
            "█  █ █    █    █    █    █  █   █  █    █  █    █ \n" *
            " ██  █    ████ ████ ████  ██    █  █     ██  ███  \n"
    @test AdventOfCode2016.Day08.day08() == [106, image]
end

@testset "Day 9" begin
    @test AdventOfCode2016.Day09.part1("ADVENT") == 6
    @test AdventOfCode2016.Day09.part1("A(1x5)BC") == 7
    @test AdventOfCode2016.Day09.part1("(3x3)XYZ") == 9
    @test AdventOfCode2016.Day09.part1("A(2x2)BCD(2x2)EFG") == 11
    @test AdventOfCode2016.Day09.part1("(6x1)(1x3)A") == 6
    @test AdventOfCode2016.Day09.part1("X(8x2)(3x3)ABCY") == 18

    @test AdventOfCode2016.Day09.part2("(3x3)XYZ") == 9
    @test AdventOfCode2016.Day09.part2("X(8x2)(3x3)ABCY") == 20
    @test AdventOfCode2016.Day09.part2("(27x12)(20x12)(13x14)(7x10)(1x12)A") == 241920
    @test AdventOfCode2016.Day09.part2("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN") == 445

    @test AdventOfCode2016.Day09.day09() == [107035, 11451628995]
end

@testset "Day 10" begin
    @test AdventOfCode2016.Day10.day10() == [181, 12567]
end