![](.\media\title.jpg)

# 配置*Masm*运行环境



安装*Masm32*编译环境，是完成汇编程序的基本前提，事实上*Masm32*是十分轻量的，安装起来并不复杂



1. 下载*Masm32*源

   来到官网http://www.masm32.com/download.htm， 你会看到一个下载的图标，选择最近的站点进行下载即可

   

2. 解压并安装

   2. 下载完成后，你将得到一个名类似为masm32v11r.zip的压缩文件，解压之后是一个Install的应用程序，在管理员权限下，执行这个文件。

      随后将出现的，是如标题图展示的Install对话框，点选Install，程序将会提示选择安装路径

      <img src=".\media\repo0.png" style="zoom: 67%;" />

      由于程序占用空间不大，所以安装至C盘也是可以的。再接下来就是一路选择Next即可。

      <img src=".\media\repo1.png" style="zoom: 50%;" />

   安装完毕后，会继续弹出下面的对话框，大意是本*Masm32*程序的*ml.exe*组件过于老旧了，如果可以的话，从VisualStudio的安装渠道（或是Microsoft其他的Masm分发渠道）下覆盖现有的*ml.exe*是可以的，当如，我们也可以忽视这一点

   ![](.\media\indicate.png)

3. 设置环境变量

   随后是环境变量的设置

![](.\media\repo2.png)

像图中给出的一样，我们需要设置三个环境变量，分别是①PATH 要把安装目录下的`/bin`加入到这里;②LIB 对应加入的是安装目录下的`/lib`；③INCLUDE 对应加入`/include`

4. 检测环境

   最后，我们需要检测一下环境是否已经配置正常，为此，打开命令行工具，键入`ml`并回车

   ![](.\media\repo3.png)

   如果没有问题，应当像上图一样显示提示信息。否则，检查一下前面几步是否均已完成。

   最后，我们看一下用*Masm32*编译程序的完整*workflow*，以一段完整`helloworld`汇编程序为例

   ```assembly
   .386
   .model flat,stdcall
   option casemap:none
   
   include windows.inc
   include user32.inc
   includelib user32.lib
   include kernel32.inc
   includelib kernel32.lib
   
   .data
   szCaption db 'A MessageBox!',0
   szText db 'Hello World!',0
   
   .code
   start:
   	invoke MessageBox,NULL,offset szText,offset szCaption,MB_OK
   	invoke ExitProcess,NULL
   end start
   
   ```

   复制上述程序并在你喜欢的任意地方保存它为`helloworld.asm`，随后在此位置打开命令行。和正常情形一样，我们首先编译为`.obj`文件，然后使用`link`工具生成`.exe`文件

   这里用到的完整的命令为

   ```D
   > ml /c /coff helloworld.asm
   > link /subsystem:windows helloworld.obj
   ```

   

   执行结果如下图所示

   ![](.\media\repo4.png)













--end--

