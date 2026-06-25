---
name: python-patterns
description: "Python coding patterns and idioms for this project. Covers error handling, control flow, and API design conventions that linters cannot enforce. Use when writing or reviewing Python code, generating Python functions, or refactoring Python modules."
---

# Python Patterns

Apply these rules when writing Python code. This is an extensible ruleset — follow every rule listed below.

## Rules

### 1. Signal failure with exceptions, not return values

**Do:** Raise an exception when an operation fails or encounters an error.

**Don't:** Return `None`, `False`, a status bool, or a tagged union (e.g. `Result[T, E]`) to indicate failure.

**Exceptions to this rule:**
- Boolean predicates (`is_valid()`, `has_permission()`, `exists()`) — these naturally return `bool`
- Lookup functions with a legitimate "not found" path (`dict.get()`, `next(..., default)`) — these may return `None` or a default
- The distinction: if the caller's happy path diverges based on the return value, that's fine. If a falsy/None return means "something went wrong", raise instead.

```python
# Good
def create_user(email: str) -> User:
    if not validate_email(email):
        raise ValueError(f"Invalid email: {email}")
    user = db.insert(User(email=email))
    return user

# Bad
def create_user(email: str) -> User | None:
    if not validate_email(email):
        return None
    ...

# Bad
def create_user(email: str) -> tuple[User | None, str | None]:
    if not validate_email(email):
        return None, "Invalid email"
    ...
```

---

*Add new rules below this line. Number sequentially.*
