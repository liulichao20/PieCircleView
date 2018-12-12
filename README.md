### 如何使用
项目中使用情况：
![icon](https://github.com/liulichao20/PieCircleView/blob/master/WechatIMG2.png?raw=true)
demo实例
![icon](https://raw.githubusercontent.com/liulichao20/PieCircleView/master/video.gif)

思路介绍：
 ***
* 创建一个view，通过所占比例绘制不同比例的扇形（通过UIBezierPath + CAShapeLayer）添加到view的layer上
*创建一个CAShapeLayer 区域包含需要动画加载的区域 设置为view.layer.mask。通过基础动画修改strokeEnd达到动态加载的效果。

####注意lineWidth属性, 它有一半的宽度是超出path所包住的范围，作为mask的layer 需要设置strokeColor为不透明，则可以通过边框的绘制来显示整个视图 任意颜色，fillColor为透明，可以通过设置半径来设置中心透明范围
***

    
 