# models

#### Department

```python
name    : CharField(max_length=128, blank=False)
uuid    : UUIDField(primary_key=True, default=uuid.uuid4, unique=True, editable=False)
father  : ForeignKey('self', on_delete=models.PROTECT, null=True)
is_root : BooleanField(default=False)

```

#### User

```python
username       : CharField (max_length=20, unique=True, blank=False)
password       : CharField (max_length=64, blank=False)
department     : ForeignKey(Department, on_delete=models.PROTECT, null=True)
is_superadmin  : BooleanField(default=False)
is_useradmin   : BooleanField(default=False)
is_assetadmin  : BooleanField(default=False)
is_locked      : BooleanField(default=False)

```

#### Token

```python
key     : CharField(max_length=64)
user    : ForeignKey(User, on_delete=models.CASCADE)
created : DateTimeField(auto_now_add=True)
expires : DateTimeField(default=timezone.now() + timedelta(days=1))

```

#### Asset(MPTTModel)

```
uuid       :
name       : 
parent = TreeForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name='children')
description:
status : enum { IDLE, IN_USE, IN_MAINTAIN, RETIRED, DELETED }
username  : nullable, foreignfield
department: foreignfield
count: number 如果is_distinct，只能是1；否则是>=0的整数
is_distinct: boolean 是否是数量限定为1的资产
category: foreignfield
custom_attributes: JSONfield

```

#### Category(MPTTModel):

<https://django-mptt.readthedocs.io/en/latest/tutorial.html> 

```python
    name        = models.CharField(max_length=MAX_CATEGORY_NAME_LEN, unique=False)
    parent      = TreeForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name='children')
    # 请注意，这里的parent是这个库要求的，不能改成father
    uuid        = models.UUIDField(primary_key=True, default=uuid.uuid4, unique=True, editable=False)
    modified_by = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True, default=None)
    modified_at = models.DateTimeField(auto_now=True)
    #重命名、创建会更新这两个字段
    company     = models.ForeignKey(Department, on_delete=models.CASCADE)   
    
    class MPTTMeta:
        order_insertion_by = ['name']

```


