# you can use Google Collab to run this
# that way, you won't have to install the library

import torch
from torch.func import jacfwd

# function: y = sin(x1) - x1*x2 + x2
def f(x):
    x1, x2 = x
    return torch.sin(x1) - x1 * x2 + x2

# input
x = torch.tensor([torch.pi, 2.0], requires_grad=True)

# FM
jac_fwd = jacfwd(f)(x)

# BM
y = f(x)
y.backward()
grad_rev = x.grad

print("FM:")
print(jac_fwd)

print("\nBM:")
print(grad_rev)
