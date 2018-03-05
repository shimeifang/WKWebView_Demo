# DrivePP git init ...

H5调原生接口方法-JS与原生OC交互


前言：JS端调OC方法并传参数给OC，会执行方法：
window.webkit.messageHandlers.<name>.postMessage(<messageBody>)

//其中<name>，就是上面方法里的第二个参数“name”。
//例如OC调用API的时候第二个参数填@"Share"，那么在JS里就是:
window.webkit.messageHandlers.Share.postMessage(<messageBody>)
//<messageBody>是一个键值对，键是body，值可以有多种类型的参数。
body 的类型：NSNumber, NSString, NSDate, NSArray, NSDictionary, and NSNull.

一、 跳转扫描页接口：
window.webkit.messageHandlers.scan.postMessage(<messageBody>);
参数：字典 ,键值key: isRepeat,值value:“true”/“false” —连扫 / 单扫
请求成功返回 调用 sendOrder方法并返回参数:单号

案例：
window.webkit.messageHandlers.scan.postMessage(<messageBody>);

返回参数类型： 单扫:参数-字符串，直接返回一个单号"92389001864"
连扫：参数以json格式返回，如{"orders" : ["92389001864","92389001863"]}
//单扫
function scanOrder(orderStr){
alert(orderStr);
}

//连扫
var obj = new object;
function scanOrder(orderStr){
obj = orderStr;
alert(obj.orders);

}

二、语音报读接口
window.webkit.messageHandlers.playVoice.postMessage(<messageBody>);
参数：字符串， #--成功  *--失败  ‘内容’--语音读报内容

三、打开通讯录接口

window.webkit.messageHandlers.openContact.postMessage(null);
参数：空
请求成功返回 调用 callBackContactPhone方法并返回参数:手机号码


案例：
window.webkit.messageHandlers.openContact.postMessage(null);
function  callBackContactPhone(phone)
{
alert(phone);
}

四、缓存
4-1：保存缓存数据接口

window.webkit.messageHandlers.setLocalStorage.postMessage(<messageBody>);
参数：数组，第一个参数是字符串-表示字典的键值，第二个参数是泛型即一切类型均可以-表示存的数据内容


4-2、取缓存数据接口
window.webkit.messageHandlers.getLocalStorage.postMessage('key');
参数：字符串（键值），根据键值来获取存取的内容

4-3、移除缓存接口

window.webkit.messageHandlers.removeLocalStorage.postMessage('key');
参数为字符串（键值），根据键值来移除缓存


案例：
var arr = ['a',{'a1':'aa','b1':'bb'}];
window.webkit.messageHandlers.setLocalStorage.postMessage(arr);
window.webkit.messageHandlers.getLocalStorage.postMessage('a');
function getCallBackValue(agr){
var callobj = JSON.stringify(agr);
alert(callobj)
}
window.webkit.messageHandlers.removeLocalStorage.postMessage('a');



五、网络请求接口

window.webkit.messageHandlers.AFNetWorking.postMessage(<messageBody>);
参数：字典-请求发送的参数
请求成功返回 调用 netCallBack方法并返回参数

案例：
var callInfo = {'ServiceName':'RequestGetCompany','Data':{'WorkingId':'KF'}};
window.webkit.messageHandlers.AFNetWorking.postMessage(callInfo);
//网络请求成功后返回业务参数 netCallBack
function netCallBack(obj)
{
var callobj = JSON.stringify(obj);
alert(callobj);
}


六、高德定位接口
参数：空
window.webkit.messageHandlers.getLocation.postMessage(null);
请求成功返回 调用 callBackGetLocation方法并返回参数

案例：

//------------------调用高德获取定位
window.webkit.messageHandlers.getLocation.postMessage(null);
//成功返回
function callBackGetLocation(log,lat) {
alert("经度:"+log+"纬度:"+lat);
document.getElementById("returnValue").value = "经度:"+log+"纬度:"+lat;
}

页面加载之前获取参数方法
七、获取缓存的头像  sessionStorage.getItem('headImage')
案例：

//头像
var imgStr =   sessionStorage.getItem('headImage');
document.getElementById("imgr").src=imgStr;


八、获取登入接口返回业务参数   sessionStorage["Rtn_Data"]

案例：
//获取登录返回缓存值
var token = sessionStorage["Rtn_Data"];
//后续要操作该JSON对象，要将之前存储的JSON字符串先转成JSON对象再进行操作
var  obj=JSON.parse(sessionStorage.getItem("Rtn_Data"));
alert(JSON.stringify(obj));


九、图片预览并支持缩放 接口

window.webkit.messageHandlers.viewPictrue.postMessage(<messageBody>);
参数：字符串，可以是图片也可以是base64字符串

案例：
<img src="head2.jpg" style="width: 30%; height: 30%;" onclick="getIOSImage()">
function getIOSImage(){
//预览图片
window.webkit.messageHandlers.viewPictrue.postMessage('head2.jpg');
// 参数：字符串，可以是图片也可以是base64字符串
}


十、选择相册或相机拍照

参数：空
window.webkit.messageHandlers.camera.postMessage(null);
请求成功返回 调用 callBackPhoto方法并返回参数

案例：
var imgStr;
function takeCamera(){
//相机拍照
window.webkit.messageHandlers.camera.postMessage(null);
}
//相机拍照后传图片
function callBackPhoto(encodedImageStr){
imgStr = encodedImageStr;
document.getElementById("imgr").src="data:image/jpeg;base64,"+encodedImageStr;
}
function getIOSImage(){
//预览图片
window.webkit.messageHandlers.viewPictrue.postMessage(imgStr);
// 参数：字符串，可以是图片也可以是base64字符串
}
# WKWebView_Demo
