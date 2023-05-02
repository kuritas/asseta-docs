# record的实现

record 支持：按时间范围 filter，按其中包含的各种域 filter。返回的 record 支持 paginator。

## record的设计

record 包含几个 field：

- uuid
- time
- 事务类型
- 事务内容（简短，包含唯一标识符）
- 事务内容（长，包含所有信息）
例如，登录成功的 record 可以是：

```python
uuid
time
type = "success: /user/login"
brief: "{user} at {ip} successfully loginin at {time}"
brief_json = '{"user": "admin", "ip": "1.2.3.4", time: "2023-01-02T14:13:11.302226"}'
# searchable with substring, iso time format
detail_json = '{"user": user.detail(), ...}'
```
