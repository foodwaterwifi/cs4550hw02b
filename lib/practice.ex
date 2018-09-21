defmodule Practice do
  @moduledoc """
  Practice keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def double(x) do
    2 * x
  end

  def calc(expr) do
    # This is more complex, delegate to lib/practice/calc.ex
    Practice.Calc.calc(expr)
  end

  # Takes an integer, a starting factor, and a list. Increments the starting factor to factorize remaining and adds factors to factors.
  defp factorize(remaining, f, factors) do
    if (f > remaining) do
      factors
    else
      if (rem(remaining, f) == 0) do
        factorize(div(remaining, f), f, [f | factors])
      else
        factorize(remaining, f + 1, factors)
      end
    end
  end

  # Returns a list of the prime factors of an integer
  defp factorize(num) do
    factorize(abs(num), 2, [])
  end

  def factor(x) do
    Enum.reverse(factorize(x))
  end

  def palindrome(str) do
    (str == String.reverse(str))
  end
end
