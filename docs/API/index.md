# API

对所有非法方式请求，返回：

```json
{
    "code": -3,
    "info": "Bad method"
}

```

请求体错误，返回：

```json
{
    "code": -2,
    "info": "Bad request"
}

```

URL 解析错误，返回：

```json
{
    "code": -1,
    "info": "URL parsing error"
}

```

API 全部采用 POST + json 的格式进行通信。

常见错误：

- token验证错误
    - token不存在：`code = 1, message = "invalid token"`
    - token超时：`code = 2, message = "token expired"`
- username非法 \[to be completed]
- 操作部门树根节点 \[当作不存在部门]