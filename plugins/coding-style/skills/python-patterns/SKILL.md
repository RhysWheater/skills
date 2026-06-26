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

### 2. Config values are mandatory unless explicitly stated otherwise

**Do:** Require all config values at startup. Raise a clear error immediately if a value is missing.

**Don't:** Use `.get(key, default)`, `or fallback`, `if config.get(...)`, or any other pattern that silently substitutes a default for a missing config value.

**Why:** Defensive code around missing config produces subtle, hard-to-diagnose runtime behaviour. A loud failure at startup is always preferable — the operator learns immediately what's missing rather than debugging unexpected defaults in production.

```python
# Good — fail fast at startup
import os

DATABASE_URL = os.environ["DATABASE_URL"]
API_KEY = os.environ["API_KEY"]

# Good — pydantic settings (fields without defaults are mandatory)
from pydantic_settings import BaseSettings

class Config(BaseSettings):
    database_url: str
    api_key: str
    worker_count: int

config = Config()  # raises ValidationError listing all missing fields

# Bad — silent defaults
DATABASE_URL = os.environ.get("DATABASE_URL", "sqlite:///local.db")
API_KEY = os.environ.get("API_KEY", "")

# Bad — conditional logic around missing config
api_key = config.get("api_key")
if api_key:
    client = Client(api_key=api_key)
else:
    client = None  # now every callsite needs to handle None
```

**When a default IS acceptable:** Only when the user/caller explicitly specifies that a config value is optional with a known default. Document it as such.

---

### 3. Extract helpers when a function has multiple distinct responsibilities

**Do:** Split a function into an orchestrator + private helpers when it handles multiple distinct concerns (e.g. validate, fetch, transform, persist) each with their own error handling.

**Don't:** Write monolithic functions where unrelated try/except blocks or distinct logical phases are interleaved.

**Structural signals to extract:**
- Multiple try/except blocks handling different concerns
- Distinct phases (setup → action → cleanup) each with non-trivial logic
- The function name describes a sequence ("create_and_publish", "fetch_then_transform")

**The orchestrator pattern:**
- The orchestrator is short: a sequence of named helper calls with control flow (conditionals, loops)
- The orchestrator owns the control flow — branching on results belongs here, not in helpers
- Each helper has a single responsibility
- Private helpers (`_prefixed`) are fine

```python
# Good — orchestrator with named steps and control flow
def publish_artifact(artifact: Artifact, config: Config) -> str:
    credentials = _assume_publish_role(config.role_arn)
    location = _upload_to_s3(artifact, credentials, config.bucket)
    if artifact.notify_subscribers:
        _post_notification(location, config.notify_url)
    return location

def _assume_publish_role(role_arn: str) -> Credentials:
    try:
        sts = boto3.client("sts")
        response = sts.assume_role(RoleArn=role_arn, RoleSessionName="publish")
        return Credentials.from_response(response)
    except ClientError as e:
        raise PublishError(f"Failed to assume role {role_arn}") from e

# Bad — everything in one function
def publish_artifact(artifact, config):
    try:
        sts = boto3.client("sts")
        response = sts.assume_role(...)
        creds = response["Credentials"]
    except ClientError as e:
        raise PublishError(...) from e
    try:
        s3 = boto3.client("s3", ...)
        s3.put_object(...)
    except ClientError as e:
        raise PublishError(...) from e
    try:
        requests.post(config.notify_url, ...)
    except RequestException as e:
        raise PublishError(...) from e
```

---

### 4. Encapsulate side-effects for testability

**Do:** When a function makes **multiple** side-effectful calls (API requests, DB writes, subprocess runs, file I/O), isolate each behind a dedicated helper. Tests then patch the helper directly.

**Don't:** Mix multiple side-effectful calls in one function such that tests require complex mock routing (conditionals inside `side_effect`, lambda dispatch, multi-service mock objects).

**This rule applies to:** Functions with 2+ distinct side-effectful operations. A function with a single side-effect is already easy to mock — no extraction needed purely for testability.

**Encapsulation depth:** Patching the helper is sufficient — you don't need DI purely for encapsulation. DI is still a valid pattern when appropriate (e.g. client reuse across callers, or when you prefer explicit dependencies), but it's not required to satisfy this rule.

```python
# Good — each side-effect isolated, tests patch helpers directly
def sync_user(user_id: str) -> None:
    profile = _fetch_profile(user_id)
    _write_to_db(profile)
    _notify_downstream(profile)

# Tests:
@patch("mymodule._notify_downstream")
@patch("mymodule._write_to_db")
@patch("mymodule._fetch_profile")
def test_sync_user(mock_fetch, mock_write, mock_notify):
    mock_fetch.return_value = Profile(name="Alice")
    sync_user("u123")
    mock_write.assert_called_once_with(Profile(name="Alice"))

# Bad — multiple side-effects in one function, tests need routing logic
def sync_user(user_id: str) -> None:
    resp = requests.get(f"/api/users/{user_id}")
    profile = resp.json()
    db.execute("INSERT INTO users ...", profile)
    requests.post("/events", json={"type": "user_synced", ...})

# Tests become:
@patch("requests.get")
@patch("requests.post")
@patch("mymodule.db")
def test_sync_user(mock_db, mock_post, mock_get):
    mock_get.return_value.json.return_value = {...}  # fragile chain
    ...
```

---

*Add new rules below this line. Number sequentially.*
