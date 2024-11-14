def secant_method(f, x0, x1, error):
    x2 = x1 - f(x1) * (x1 - x0) / float(f(x1) - f(x0))
    if abs(x2 - x1) < error:
        return x2
    return secant_method(f, x1, x2, error)

def f(x):
    return x ** 4 - x ** 3 - 2.5


error = 0.001
while error >= 0.00000001:
    print(f"Корень с точностью {error} равен: {secant_method(f, 1, 2, error)}")
    error /= 10