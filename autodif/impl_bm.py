import math

class Variable:

    def __init__(self, value, adjoint=0.0):
        self.value = value
        self.adjoint = adjoint

    def backward(self, adjoint):
        self.adjoint += adjoint

    def __add__(self, other):
        variable = Variable(self.value + other.value)

        def backward(adjoint):
            variable.adjoint += adjoint
            self_adjoint = adjoint * 1.0
            other_adjoint = adjoint * 1.0
            #
            self.backward(self_adjoint)
            other.backward(other_adjoint)

        variable.backward = backward
        return variable

    def __sub__(self, other):
        variable = Variable(self.value - other.value)

        def backward(adjoint):
            variable.adjoint += adjoint
            self_adjoint = adjoint * 1.0
            other_adjoint = adjoint * -1.0
            #
            self.backward(self_adjoint)
            other.backward(other_adjoint)

        variable.backward = backward
        return variable

    def __mul__(self, other):
        variable = Variable(self.value * other.value)

        def backward(adjoint):
            variable.adjoint += adjoint
            self_adjoint = adjoint * other.value
            other_adjoint = adjoint * self.value
            #
            self.backward(self_adjoint)
            other.backward(other_adjoint)

        variable.backward = backward
        return variable


    def __repr__(self) -> str:
        return f"(value: {self.value}," \
               f" adjoint: {self.adjoint})"


def sin(x):
    variable = Variable(math.sin(x.value))
    
    def backward(adjoint):
        variable.adjoint += adjoint
        x.backward(adjoint * math.cos(x.value))

    variable.backward = backward
    return variable


x1 = Variable(math.pi)
x2 = Variable(2.0)

y = sin(x1) - x1 * x2 + x2
y.backward(1.0)

print(f"{x1 = },\n{x2 = }")
print(f"{y = }")
