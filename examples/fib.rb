def fib(n)
  if n < 2
    return n
  end

  return fib(n-1) + fib(n-2)
end

n = (ARGV[0] || 30).to_i
fib(n)
