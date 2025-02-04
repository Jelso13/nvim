# pyright_test.py

# 1. Missing type annotation
def add_numbers(a, b):  # Should warn about missing type annotations
    return a + b

# 2. Incorrect type assignment
x: int = "hello"  # Type error: assigning a string to an int variable

# 3. Function with missing return type annotation
def greet(name):  # Should warn about missing return type annotation
    print(f"Hello, {name}")

# 4. Unused import
import math  # Should warn about unused import

# 5. Unused variable
def calculate_area(radius: float):
    area = 3.14 * radius ** 2  # Should warn about unused variable 'area'

# 6. Unused function argument
def subtract(a: int, b: int):
    return a - 1  # Should warn about unused argument 'b'

# 7. Using 'Any' type explicitly (depending on your settings)
from typing import Any

def process_data(data: Any):  # Should warn about explicit 'Any' usage
    return data

# 8. Calling a function with incorrect argument types
def multiply(a: int, b: int) -> int:
    return a * b

result = multiply(2, "3")  # Type error: string passed instead of int

# 9. Attempting to access a non-existent attribute
class Person:
    def __init__(self, name: str):
        self.name = name

person = Person("Alice")
age = person.age  # Type error: 'Person' has no attribute 'age'

# 10. Redundant cast
from typing import cast

value: int = cast(int, 42)  # Redundant cast, as 42 is already an int

# 11. Unreachable code
def check_even(n: int) -> bool:
    if n % 2 == 0:
        return True
    else:
        return False
        print("This will never run")  # Unreachable code warning

# 12. Missing Type Stubs for external packages (if 'reportMissingTypeStubs' is enabled)
try:
    import numpy as np  # If no stubs, should report missing type stubs
except ImportError:
    pass

# 13. Circular Import (simulated)
# Assume you create another file called `module_b.py` importing `pyright_test.py`
# from module_b import foo  # Circular import warning if the other file imports this back

# 14. Optional without proper handling
from typing import Optional

def get_username(user_id: Optional[int]) -> str:
    if user_id:
        return f"User-{user_id}"
    return None  # Should warn about returning None where str is expected

# 15. Type narrowing issue
def check_type(value: int | str):
    if isinstance(value, int):
        print(value + 1)  # Correct usage
    else:
        print(value + 1)  # Type error: can't add int to str

