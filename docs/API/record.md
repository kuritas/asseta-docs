# API: /record

- token 不存在：`code = 1, message = "invalid token"`
- token 超时：`code = 2, message = "token expired"`
- 权限不足：`code = 3, message = "no access"`

权限控制：超管可以任意搜索，系统管理员只能指定用户搜索，资产管理员只能指定资产搜索。任意管理员可以凭借记录的 uuid 获取记录的具体内容。

## /record/info

获取记录信息。

权限：任意管理员

```json
{
    "token": "",
    "uuid": ""
}
Success
{
    "code": 0,
    "info": "Succeed",
    "data": {
        res_dict = {
            "uuid": self.uuid.hex,
            "time": self.time.isoformat(),
            "caller": self.caller.username if self.caller else None,
            "event": self.event,
            "brief_template": self.brief_template,
            "brief_json": self.brief_json,
            // detail_json 只有 info 才会提供
            "detail_json": self.detail_json
        }
    }
}
Fault
{
    "code": *,
    "info": message
}
```

错误类型：
- uuid 无效：`code = 10, message = "invalid uuid"`
