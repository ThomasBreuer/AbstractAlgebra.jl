@testset "Generic.Frac.constructors" begin
   S, x = PolynomialRing(ZZ, "x")
   T = FractionField(S)

   @test FractionField(S, cached = true) === FractionField(S, cached = true)
   @test FractionField(S, cached = false) !== FractionField(S, cached = true)

   @test elem_type(T) == Generic.Frac{elem_type(S)}
   @test elem_type(Generic.FracField{elem_type(S)}) == Generic.Frac{elem_type(S)}
   @test parent_type(Generic.Frac{elem_type(S)}) == Generic.FracField{elem_type(S)}

   @test isa(T, Generic.FracField)

   @test isa(T(3), Generic.Frac)

   @test isa(T(BigInt(7)), Generic.Frac)

   @test isa(T(x + 2), Generic.Frac)

   @test isa(T(3, 7), Generic.Frac)

   @test isa(T(x + 2, x + 1), Generic.Frac)

   @test isa(T(x + 2, 4), Generic.Frac)

   @test isa(T(3, x + 1), Generic.Frac)

   @test isa(T(T(x + 2)), Generic.Frac)

   @test isa(T(), Generic.Frac)

   @test isa((x + 3)//(x^2 + 2), Generic.Frac)

   @test isa((x + 3)//12, Generic.Frac)

   @test isa(12//(x + 2), Generic.Frac)

   @test isa((x + 1)//T(x + 2, x + 1), Generic.Frac)

   @test isa(T(x + 2, x + 1)//(x + 1), Generic.Frac)

   @test isa(T(x + 2, x + 1)//T(x, x + 2), Generic.Frac)

   TT = FractionField(PolynomialRing(QQ, "x")[1])
   a = TT(1)
   b = T(2)

   @test a in [a, b]
   @test a in [b, a]
   @test !(a in [b])
   @test a in keys(Dict(a => 1))
   @test !(b in keys(Dict(a => 1)))
end

@testset "Generic.Frac.printing" begin
   S, (x, y, z) = PolynomialRing(QQ, ["x", "y", "z"])

   @test string((x+y)//z) == "(x + y)//z"
   @test string(x//y//z) == "x//(y*z)"
end


@testset "Generic.Frac.rand" begin
   S, x = PolynomialRing(ZZ, "x")
   K = FractionField(S)

   test_rand(K, -1:3, -3:3)
end

@testset "Generic.Frac.manipulation" begin
   R = FractionField(ZZ)
   S, x = PolynomialRing(ZZ, "x")

   @test denominator((x + 1)//(-x^2 + 1)) == x - 1

   @test numerator((x + 1)//(-x^2 + 1)) == -1

   @test iszero(zero(R))

   @test isone(one(S))

   @test canonical_unit((x + 1)//(-x^2 + 1)) == -1//(x-1)

   @test is_unit((x + 1)//(-x^2 + 1))

   @test !is_zero_divisor((x + 1)//(-x^2 + 1))

   @test deepcopy((x + 1)//(-x^2 + 1)) == (x + 1)//(-x^2 + 1)

   @test characteristic(R) == 0
end

@testset "Generic.Frac.unary_ops" begin
   S, x = PolynomialRing(ZZ, "x")

   @test -((x + 1)//(-x^2 + 1)) == 1//(x - 1)
end

@testset "Generic.Frac.binary_ops" begin
   S, x = PolynomialRing(ZZ, "x")
   K = FractionField(S)

   for iter = 1:100
      a = rand(K, -1:3, -3:3)
      b = rand(K, -1:3, -3:3)
      c = rand(K, -1:3, -3:3)

      @test a + b - b == a
      @test c*(a + b) == c*a + c*b
      @test c*(a - b) == c*(a - b)
      @test a - b == -(b - a)
   end
end

@testset "Generic.Frac.adhoc_binary" begin
   S, x = PolynomialRing(ZZ, "x")

   a = (-x + 1)//(2x^2 + 3)
   b = (x + 1)//(-x^2 + 1)

   @test a + 2 == (4*x^2-x+7)//(2*x^2+3)

   @test a - 2 == (-4*x^2-x-5)//(2*x^2+3)

   @test 3 + a == (6*x^2-x+10)//(2*x^2+3)

   @test 3 - a == (6*x^2+x+8)//(2*x^2+3)

   @test b*(x + 1) == (-x-1)//(x-1)

   @test (x + 1)*b == (-x-1)//(x-1)

   @test a + 2//3 == (4*x^2 - 3*x + 9)//(6*x^2 + 9)

   @test 2//3 + a == (4*x^2 - 3*x + 9)//(6*x^2 + 9)

   @test a - 2//3 == (-4*x^2 - 3*x - 3)//(6*x^2 + 9)

   @test 2//3 - a == (4*x^2 + 3*x + 3)//(6*x^2 + 9)

   @test a*(2//3) == (-2*x + 2)//(6*x^2 + 9)

   @test (2//3)*a == (-2*x + 2)//(6*x^2 + 9)
end

@testset "Generic.Frac.comparison" begin
   S, x = PolynomialRing(ZZ, "x")

   a = -((x + 1)//(-x^2 + 1))

   @test a == 1//(x - 1)

   @test isequal(a, 1//(x - 1))
end

@testset "Generic.Frac.adhoc_comparison" begin
   S, x = PolynomialRing(ZZ, "x")

   a = 1//(x - 1)

   @test 1//a == x - 1

   @test x - 1 == 1//a

   @test one(S) == 1

   @test 1 == one(S)

   @test  S(2)//3 == 2//3

   @test 2//3 == S(2)//3
end

@testset "Generic.Frac.powering" begin
   S, x = PolynomialRing(ZZ, "x")

   a = (x + 1)//(-x^2 + 1)

   @test a^-12 == x^12-12*x^11+66*x^10-220*x^9+495*x^8-792*x^7+924*x^6-792*x^5+495*x^4-220*x^3+66*x^2-12*x+1
end

@testset "Generic.Frac.inversion" begin
   S, x = PolynomialRing(ZZ, "x")

   a = (x + 1)//(-x^2 + 1)

   @test inv(a) == -x + 1
end

@testset "Generic.Frac.exact_division" begin
   S, x = PolynomialRing(ZZ, "x")
   K = FractionField(S)

   for iter = 1:100
      a = K(); b = K(); c = K()

      while a == 0
         a = rand(K, -1:3, -3:3)
      end
      while b == 0
         b = rand(K, -1:3, -3:3)
      end
      while c == 0
         c = rand(K, -1:3, -3:3)
      end

      @test divexact(a*b, b) == a
      @test divexact((a + b)*c, c) == divexact(a*c, c) + divexact(b*c, c)
   end
end

@testset "Generic.Frac.adhoc_exact_division" begin
   S, x = PolynomialRing(ZZ, "x")

   a = (-x + 1)//(2x^2 + 3)
   b = (x + 1)//(-x^2 + 1)

   @test a//5 == (-x+1)//(10*x^2+15)

   @test a//(x + 1) == (-x+1)//(2*x^3+2*x^2+3*x+3)

   @test (x + 1)//b == -x^2+1

   @test 5//a == (-10*x^2-15)//(x-1)
end

@testset "Generic.Frac.divides" begin
   R, x = PolynomialRing(ZZ, "x")
   S = FractionField(R)

   for i in 1:1000
     a = rand(S, -1:5, -10:10)
     b = rand(S, 0:5, -10:10)

     d, q = divides(a, b)

     if d
       @test b * q == a
     end
   end
end

@testset "Generic.Frac.evaluate" begin
   R = ResidueRing(ZZ, 5)
   S, x = PolynomialRing(R, "x")

   f = (x^2 + 2)//(x + 1)

   @test evaluate(f, 1) == R(4)
   @test evaluate(f, R(1)) == R(4)

   R, (x, y) = PolynomialRing(ZZ, ["x", "y"])

   f = (x^2 + y)//(y + 2)

   @test evaluate(f, [1, 2]) == ZZ(3)//ZZ(4)
   @test evaluate(f, [ZZ(1), ZZ(2)]) == ZZ(3)//ZZ(4)
end

@testset "Generic.Frac.derivative" begin
   R, x = PolynomialRing(QQ, "x")

   f = (x^2 + 1)//2x

   @test derivative(f) == (x^2 - 1)//2x^2

   R, (x, ) = PolynomialRing(QQ, ["x"])

   f = (x^2 + 1)//2x

   @test derivative(f, x) == (x^2 - 1)//2x^2

   R, (x, y) = PolynomialRing(QQ, ["x", "y"])

   f = (x^2 + x*y + y^2)//(x + y)

   @test derivative(f, x) == (x^2 + 2x*y)//(x^2 + 2x*y + y^2)

   @test derivative(f, 2) == (2x*y + y^2)//(x^2 + 2x*y + y^2)
end

@testset "Generic.Frac.square_root" begin
   R, x = PolynomialRing(QQ, "x")
   S = FractionField(R)

   for i = 1:100
      a = rand(S, -1:5, -10:10)

      g = a^2

      @test is_square(g)

      @test sqrt(g)^2 == g

      f1, s1 = is_square_with_sqrt(g)

      @test f1 && s1^2 == g
   end

   f = (3x^2 + 2x + 1)^2//(x + 4)

   f1, s1 = is_square_with_sqrt(f)

   @test !f1

   f = (3x^2 + 2x + 1)//(x + 4)^2

   f2, s2 = is_square_with_sqrt(f)

   @test !f2   
end

@testset "Generic.Frac.gcd" begin
   S, x = PolynomialRing(ZZ, "x")

   a = (x + 1)//(-x^2 + 1) - x//(2x + 1)

   @test gcd(a, (x + 1)//(x - 1)) == 1//(2*x^2-x-1)
end

if @isdefined fmpq
    @testset "Generic.Frac.remove_valuation" begin
        a = fmpq(2, 3)

        @test remove(a, BigInt(2)) == (1, fmpq(1, 3))
        @test valuation(a, BigInt(2)) == 1

        @test remove(a, BigInt(3)) == (-1, fmpq(2, 1))
        @test valuation(a, BigInt(3)) == -1
    end
end

@testset "Generic.Frac.promotion" begin
   S, x = PolynomialRing(QQ, "x")
   F = FractionField(S)
   T = elem_type(F)
   @test AbstractAlgebra.promote_rule(T, T) == T
end
