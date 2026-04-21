import math

class Variable:

    def __init__(self, value, tangent):
        self.value = value
        self.tangent = tangent

    def __add__(self, other):
        value = self.value + other.value
        tangent = self.tangent + other.tangent
        return Variable(value, tangent)

    def __sub__(self, other):
        value = self.value - other.value
        tangent = self.tangent - other.tangent
        return Variable(value, tangent)

    def __mul__(self, other):
        value = self.value * other.value
        tangent = self.tangent * other.value + \
                  other.tangent * self.value
        return Variable(value, tangent)

    def __repr__(self):
        return f"(value: {self.value}," \
               f" tangent: {self.tangent})"

# only works if x is of type Variable
def sin(x):
    return Variable(
            math.sin(x.value), 
            math.cos(x.value))


x1, x2 = Variable(math.pi, 1.0), Variable(2.0, 0.0)
y = sin(x1) - x1 * x2 + x2

print(f"{x1 = },\n{x2 = }")
print(f"{y = }")
