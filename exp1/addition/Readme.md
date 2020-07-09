基本思路是，建立一个0~9位乘法表如下

```assembly
SQTAB DB 00H, 01H, 04H, 09H, 10H, 19H, 24H, 31H, 40H, 51H, 64H
```

不难发现，该表的偏移地址的乘方该偏移地址的内的数据，所以我们利用基址变址寻址方式（乘法表的首位偏移地址送入DI，变址就是我们要求乘方的数，送入BX，就完成了对乘法表的寻址工作，下面是其核心部分：

```assembly
SUB AL, 30H 

  LEA DI, SQTAB

  AND AX, 007FH

  MOV BX, AX

  MOV AL, [DI]BX
```

通过上述工作，由ASCII码格式的`AL`，经处理化为16进制格式（对应于`SUB AL, 30H \\ AND AX, 007FH`）,再经上述处理`AL`存数就是原乘方值

本代码中还有较大的篇幅用于格式转换，包括ASCII码（十进制）转十六进制，十六进制数转ASCII码（十进制），具体实现就不赘述了，其转换关系参考如下的ASCII码表

 

 

 

![img](file:///C:/Users/admin/AppData/Local/Temp/msohtmlclip1/01/clip_image002.gif)

 

最后，我们对整程序进行运行检测，程序首先提示我们要输入一个字符，这里输入3作测试，屏幕最后打印出



![img](file:///C:/Users/admin/AppData/Local/Temp/msohtmlclip1/01/clip_image004.jpg)

其中*号和=的显示通过实现中断`21H`并置功能字`02H`实现，`09`是以字符串格式存储，通过实现中断`21H`并置功能字`09H`完成字符串的打印，我们再测试一下输入4的程序运行结果。

 ![img](file:///C:/Users/admin/AppData/Local/Temp/msohtmlclip1/01/clip_image006.jpg)

工作顺利，符合我们的预期！