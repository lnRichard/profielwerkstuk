# ProjectileEntity

Create an Inherited ProjectileEntity scene. Create a folder for the Subclass (inherited ProjectileEntity) scene. 
Attach a (new) script to the Subclass. Make the script extend ProjectileEntity.

3 variables must be passed into init() in the following manner.

```
func _init().(_speed: float, _lifetime: int, _damage: float):
    pass
```