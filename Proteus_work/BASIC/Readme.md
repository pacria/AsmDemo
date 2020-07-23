![](.\media\main_circuit.bmp)

# 基于Proteus的简单综合实验平台（自建）

> 8086, 8255, 8253与 8259
>
> Source Project :https://github.com/pacria/AsmDemo/tree/homework/Proteus_work/BASIC/source
>
> Author: Pacr



### Write Ahead

由于这个简单的实验平台是自己设计搭建的，难免出现不少问题，欢迎大家通过提issues或者pull request完善！





### 基本使用

目前该平台有8个按钮可供选择做哪个实验，也就是说利用此平台可以做的实验数的上限是8个（*TODO: Expansion it*)

具体的做法是，点击Proteus的播放按钮进行仿真，第一步就是选择要做的实验（从`exp0`~`exp7`)进行选择

<img src=".\media\repo0.png" style="zoom:60%;" />

例如，我们点击EXP0对应的按钮（*BUTTON*)，将会进行实验0`exp0`，已经预置为是8255的基本输入输出实验——PA端口的LED灯亮灭取决于PB端口的拨动开关输入（更多可见[exp5-1][https://github.com/pacria/AsmDemo/tree/homework/exp5_1]。然后点击proteus的终止仿真键，再次开始时将重新进入实验选择步骤，这一次我们再点击EXP1对应的按钮，将执行`exp1`——同样已经被预置了，这是一个流水灯实验(更多可见[exp5-2][https://github.com/pacria/AsmDemo/tree/homework/exp5_2])

事实上，这里的`exp0`~`exp4`都已经被预置了。关于这些实验分别表示何种内容，更详细的内容分别在[exp5-1][https://github.com/pacria/AsmDemo/tree/homework/exp5_1], [exp5-2][https://github.com/pacria/AsmDemo/tree/homework/exp5_2], [exp6-2][https://github.com/pacria/AsmDemo/tree/homework/exp6_2], [exp6-3][https://github.com/pacria/AsmDemo/tree/homework/exp6_3]可以见到。下面来看一下如何利用此平台编写自己的实验程序。

由于还有`exp5`, `exp6`,`exp7`没有被预置，假设我们希望写一个新的流水灯程序，并将其固定到EXP5,首先打开Proteus工程文件的Source Code界面，定位到如下代码

```assembly
EXP5:
	; Write you code here
   JMP TEND
```

然后在中间添加流水灯部分的代码

```assembly
EXP5:
	
   MOV DX, MCU8255MODE
   MOV AL, 10000010B       ; A - Output(Method0) B - Input(Method0)
   OUT DX, AL

   MOV DX, MCU8255A
   MOV AL, 01H

EXP1_ENDLESS:
   CALL DELAY

   OUT DX, AL
   ROL AL, 1   
   JMP EXP1_ENDLESS
   
   JMP TEND
```

随后，选择“Build"$\rightarrow$"Build Project"，查看是否编译正常（显示`Compiled Successfully`）

![check](.\media\repo1.png)

> 关于如何设置*Masm32*的编译环境，查看[这里][https://github.com/pacria/AsmDemo/tree/homework/how_to/About Masm]



### 译码常量

在该实验平台（自建）上，共有8个译码地址段（供片间寻址）可供使用，它们分别是

<img src=".\media\repo2.png" style="zoom:52%;" />

在硬件电路上, 8255的片选端#CS接IOY0，8255副片接IOY1， 8253接IOY2（8259目前没有做）。其中A1, A2两根地址线用于片内寻址，源代码已经设置了基本的地址如

```assembly
      IOY0 EQU 8000H    ; IOY0-8255
      MCU8255A    EQU IOY0+00H     ; Output
      MCU8255B    EQU IOY0+02H     ; Input
      MCU8255C    EQU IOY0+04H     ; For more
      MCU8255MODE EQU IOY0+06H     ; Mode Control
      IOY1 EQU 9000H    ; IOY1-8255_affiliated
      MCU8255NA   EQU IOY1+00H
      MCU8255NB   EQU IOY1+02H
      MCU8255NC   EQU IOY1+04H
      MCU8255NMODE EQU IOY1+06H
      IOY2 EQU 0A000H   ; IOY2-8253
      MCU8253CNT0 EQU IOY2+00H     ; CNT0
      MCU8253CNT1 EQU IOY2+02H     ; CNT1
      MCU8253CNT2 EQU IOY2+04H     ; CNT2
      MCU8253MODE EQU IOY2+06H     ; Mode Control
      IOY3 EQU 0B000H   ; IOY3-8259
```

其余地址可供扩展用，当然你也可以自己重新设置这些地址规则。



### BUGS

> 这一部分摘录了目前遇到的一些问题已经对应的解决办法，我随意地设置了`warning`, `fatal`两个等级
>
> 最后希望bug没事



+ **仿真过载** `warning`

  Proteus这款仿真工具的仿真用时与整体的元器件复杂度有很大关联，如果组件过多会很卡以至于线程被强制终止。这一现象在完成有关8253定时计数实验时尤其明显——因为”过高“的时钟频率带来的仿真的延时。所以在这个平台上，我把外部信号源接了一根空线，就是为了避免不必要的仿真延时。

  <img src=".\media\repo3.png" style="zoom:38%;" />

  就像上面这个处理，在有关8253的实验时，需要把信号源接到SW上去；不用时则像上图中悬置即可，算是一种不得已的折中了

  *解决办法*：无（至于提升电脑性能的办法不在讨论之内）

+ **开关阵列异常**`fatal`

  <img src="D:\Personal\Learning\CLASS\微机原理\exp\asm_ground\AsmDemo\Proteus_work\BASIC\media\bug1.png" style="zoom:33%;" />

  有时你可能会遇到这样的情景...

  *解决办法*：

  无。目前同样采用的是一种折中的办法——减少开关器件的使用，在有关8253的实验中，我大幅度缩减了不必要的开关器件使用，关于那个Proteus工程文件，可以看[这里][https://github.com/pacria/AsmDemo/tree/homework/Proteus_work/Timer/source]

  当然了，还有一种”不是解决办法的解决办法“，那就是重复仿真几次。不过这么做并不保证一定成功

+ **Program Stick** `fatal`

  这个名字是我自己起的，意思是当你更新了自己的SOURCE CODE并重新编译并已经通过后，再次仿真看到的却是前一次的程序的执行结果，就像程序被粘滞了一样，无法再改变了。

  *解决办法*：

  首先，查看你的Proteus 源代码界面，确定是在`Debug`模式而非`Release`模式下

  ![](.\media\bug2.png)

  其次，保险起见，再次编译一遍（快捷键：Ctrl + F7)

  如果到这一步仍然出现了程序粘滞的现象，不要泄气，检查一下硬件，将新改动的硬件部分恢复原样（有开关器件的，删除后改为硬连接——毕竟这只是测试）

  如果问题还没有得到解决的话，可以首先使用Proteus的VSM Debug功能。

  如果实在没有办法，下面这个终极方案或许可以一看

  *终极方案*：

  新建一个Proteus工程文件，”原封不动“地将原电路重新组建一遍，然后把代码重新粘贴过去。

  > 这个做法或许令人沮丧，但确实有效

+ **VSM 执行行”错乱“**  `warning`

  Proteus自带的VSM Debug是一个不错的工具，可以单步执行，设置断点，查看工作情况。但不幸的是，这个工具本身也存在瑕疵（首先说明：这是对8086系列在Proteus8版本下的测试）

  ![](.\media\bug3.png)

  上图是利用Proteus工具对某个工程进行Debug的起始过程截图（”Debug" $\rightarrow$ "Start VSM Debugging")

  你可能会奇怪，这个程序是“刚刚开始执行”(`IP`值是0004），为什么执行的指示行却跑到了`0014`的位置呢。再仔细看，当前执行的命令是`dec cx`，与`0014` 行对应的`mov dx, 0013H`也有出入

  原因是：Proteus的debug程序将指示行的位置错误地按照物理地址`LA`（`00014`）处理，而符合人们观察习惯的是，它应该是与当前的`IP`值对应起来的

  > 不过，好消息是，如果你换用51单片机（也就是写的是C程序的话），这个“不一致”的问题将不会出现

  *解决办法*：

  无（当然，如果代码段前面“空空如也”，就不会出现`IP`与`LA`不一致的问题，不过，实际中很少出现既不需要数据段也不需要堆栈段的场景；另外一个曲线的办法是，设置数据段或堆栈段的段地址在“后面”，比如`DATAS SEGMENT AT 0080H`，但是这种做法事实上非常麻烦）



你可能发现，上面列举的bug，你可能会遇到，但是很难将其解决掉，所以，通常的策略是，避开这种bug。也就是说，对于这类BUG，最好的做法或许不是解决它，而是避开它。