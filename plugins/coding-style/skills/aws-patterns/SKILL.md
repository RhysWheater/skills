---
name: aws-patterns
description: "AWS coding patterns and idioms for this project. Covers CloudWatch metrics, dimensions, and observability conventions that linters cannot enforce. Use when writing or reviewing AWS infrastructure code, creating CloudWatch metrics, or working with CDK/Terraform/CloudFormation that involves metrics or alarms."
---

# AWS Patterns

Apply these rules when writing AWS infrastructure or application code. This is an extensible ruleset — follow every rule listed below.

## Rules

### 1. CloudWatch dimensions must add information

**Do:** Only add a dimension when it partitions the metric data in a way that isn't already implied by the deployment context.

**Don't:** Add dimensions that are constant for the entire AWS account or deployment unit — they add cardinality cost without providing queryable differentiation.

**Key case — environment dimension:**
- If each environment (dev, staging, prod) deploys to its own AWS account: **do not** add an environment dimension. The account boundary already separates the data.
- If multiple environments share an account: an environment dimension **is** appropriate because it provides necessary differentiation.

**Rule of thumb:** Before adding a dimension, ask: "Within this account, can this dimension have more than one value at the same time?" If no, omit it.

```python
# Good — environments in separate accounts, no environment dimension
cloudwatch.put_metric_data(
    Namespace="MyApp/Orders",
    MetricData=[{
        "MetricName": "OrdersPlaced",
        "Value": 1,
        "Dimensions": [
            {"Name": "Service", "Value": "checkout"},
        ],
    }],
)

# Bad — environment dimension is redundant when account = environment
cloudwatch.put_metric_data(
    Namespace="MyApp/Orders",
    MetricData=[{
        "MetricName": "OrdersPlaced",
        "Value": 1,
        "Dimensions": [
            {"Name": "Service", "Value": "checkout"},
            {"Name": "Environment", "Value": "prod"},  # redundant
        ],
    }],
)
```

---

*Add new rules below this line. Number sequentially.*
