
def fib(n):
  '''
  Compute and show first n elements in the fibbonaci sequence
  '''
  a, b = 0, 1
  while b < n:
    print(b)
    a, b = b, a+b
