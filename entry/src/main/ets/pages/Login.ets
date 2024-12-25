import CustomButton from '../components/common/CustomButton'
import PhoneCode from '../views/Login/PhoneCode'
import cloud from '@hw-agconnect/cloud';
import { hilog } from '@kit.PerformanceAnalysisKit';
import TipDialog from '../components/dialog/TipDialog';
import { addUser, queryExistUser } from '../api/services';
import { AddUserInterface } from '../api/interface/user';
import { AddResponseInterface } from '../api/interface/common';
import PhonePassword from '../views/Login/PhonePassword';
import { isValidPhoneNumber } from '../utils/Index';
import PrivacyCheck from '../views/Login/PrivacyCheck';

@Builder
export function LoginBuilder() {
  Login()
}

@Component
export struct Login {
  @Consume pageStack: NavPathStack
  @State phoneNum: string = '';
  @State code: string = '';
  @State password: string = '';
  @State isCheck: boolean = false;
  @State isPhoneCode: boolean = true;
  @State tips: string = "";
  timer: number | null = null;

  tipDialogController: CustomDialogController = new CustomDialogController({
    builder: TipDialog({
      content: this.tips
    }),
    alignment: DialogAlignment.Center,
    customStyle: false,
    cornerRadius: 12,
    width: 228,
    height: 64,
  })

  tipDialog(content: string,time: number){
    this.tips = content
    this.tipDialogController.open()
    this.timer = setTimeout(()=>{
      this.tipDialogController.close()
    },time)
  }

  aboutToDisappear(){
    if (this.timer !== null) {
      clearInterval(this.timer);
      this.timer = null; // 可选，清除引用
    }
  }

  async login() {
    if(!isValidPhoneNumber(this.phoneNum)){
      this.tipDialog("请输入正确的手机号",3000)
      return;
    }
    if(!this.isCheck){
      this.tipDialog("请勾选隐私协议",3000)
      return;
    }
    hilog.info(0,"Login","进行了登录");
    try {
      const res = await cloud.auth().signIn({
        credentialInfo: {
          kind: "phone",
          countryCode: "86",
          phoneNumber: this.phoneNum,
          verifyCode: this.code
        },
        autoCreateUser: true
      });
      const user = res.getUser();
      const uuid: string = user.getUid().toString()
      const phone_num = user.getPhone().toString()
      const exist: AddResponseInterface = await queryExistUser({
        uuid,
        phone_num
      })
      hilog.info(0,"Login",JSON.stringify(exist))
      if(exist.data.length===0){
        const records: AddUserInterface = {
          uuid,
          phone_num
        }
        await addUser(records);
      }
      hilog.info(0,"Login","SUCCESS");
      this.goIndex();
    }catch (e) {
      this.tipDialog("登录失败",3000);
      hilog.error(0,"Login",JSON.stringify(e));
    }
  }

  async loginByPassword(){
    if(!isValidPhoneNumber(this.phoneNum)){
      this.tipDialog("请输入正确的手机号",3000)
      return;
    }
    if(!this.isCheck){
      this.tipDialog("请勾选隐私协议",3000)
      return;
    }
    hilog.info(0,"Login",this.phoneNum)
    hilog.info(0,"Login",this.password)
    try{
      await cloud.auth().signIn({
        credentialInfo: {
          kind: 'phone',
          phoneNumber: this.phoneNum,
          countryCode: '86',
          password: this.password
        }
      })
      this.goIndex()
    }catch (e){
      hilog.info(0,"Login",JSON.stringify(e))
    }
  }

  goIndex(){
    this.pageStack.replacePathByName("Index", null, false)
  }

  goRegister(){
    this.pageStack.replacePathByName("Register", null, false);
  }

  checkEnableLogin(){
    if(this.isPhoneCode){
      if(this.phoneNum!=""&&this.code.length==6){
        return true;
      }else {
        return false;
      }
    }else{
      if(isValidPhoneNumber(this.phoneNum)&&this.password.length>=6){
        return true;
      }else {
        return false;
      }
    }
  }

  build() {
    NavDestination() {
      Column(){
        Column(){
          Text('旅迹').font({weight:500,size:32})
        }.margin({top:96,bottom:32})
        Column(){
          Column(){
            if(this.isPhoneCode){
              Text("账号密码登录").onClick(()=>{
                hilog.info(0,"Login","切换至PhonePassword")
                this.isPhoneCode = false;
                this.phoneNum = "";
                this.password = "";
              })
            }
            else {
              Text("短信验证码登录").onClick(()=>{
                hilog.info(0,"Login","切换至PhoneCode")
                this.isPhoneCode = true;
                this.phoneNum = "";
                this.code = "";
              })
            }
          }
          .width("100%")
          .alignItems(HorizontalAlign.End)
          if(this.isPhoneCode){
            PhoneCode({code:$code,phoneNum:$phoneNum,isPhoneCode: this.isPhoneCode,checkEnableLogin: this.checkEnableLogin})
          }else{
            PhonePassword({phoneNum: $phoneNum,password:$password,checkEnableLogin: this.checkEnableLogin})
          }
          CustomButton({text: "立即登录",buttonWidth: 228,enable: this.checkEnableLogin()})
            .margin({top:12})
            .onClick(()=>{
              if(this.isPhoneCode){
                if(this.phoneNum!=""&&this.code!=""){
                  this.login()
                }else{
                  this.tipDialog("请输入补全信息",3000)
                  return;
                }
              }else{
                if(this.phoneNum!=""&&this.password!=""){
                  this.loginByPassword()
                }else{
                  this.tipDialog("请输入补全信息",3000)
                  return;
                }
              }
            })
          PrivacyCheck({isCheck:$isCheck}).margin({top:12})
        }.padding({top:24,bottom:24,left:24,right:24}).backgroundColor(Color.White).margin({right:16,left:16,top:12,bottom:12}).borderRadius(8)
        Column(){
          Text("暂无账号，立即注册").onClick(()=>{
            this.goRegister()
          })
        }.margin({top: 12})
      }.backgroundColor($r('app.color.background_color')).width('100%').height('100%')
    }
    .hideTitleBar(true)

  }
}
