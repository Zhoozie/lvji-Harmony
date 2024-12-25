import CustomButton from '../components/common/CustomButton';
import TipDialog from '../components/dialog/TipDialog';
import { checkPasswordComplexity, isValidPhoneNumber } from '../utils/Index';
import { hilog } from '@kit.PerformanceAnalysisKit';
import cloud, { VerifyCodeAction } from '@hw-agconnect/cloud';
import { AddUserInterface } from '../api/interface/user';
import { AddResponseInterface } from '../api/interface/common';
import { addUser, queryExistUser } from '../api/services';
import PrivacyCheck from '../views/Login/PrivacyCheck';

@Builder
export function RegisterBuilder() {
  Register()
}

@Component
export struct Register {
  @Consume pageStack: NavPathStack
  @State phoneNum: string = "";
  @State codeText: string = "发送验证码"
  @State code: string = "";
  @State countDown: number = 60;
  @State password: string = "";
  @State passwordConfirm: string = "";
  @State tips: string = "";

  @State isCheck: boolean = false;
  @State isSending: boolean = false;
  @State enableClickSend: boolean = false;
  @State enableRegister: boolean = false;

  countDownTimer: number | null = null;
  timer: number | null = null;
  tipTimer: number | null = null;
  waitTimer: number | null = null;

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
    this.tipTimer = setTimeout(()=>{
      this.tipDialogController.close()
    },time)
  }

  waiting() {
    this.codeText = `${this.countDown}s后重发`;
    this.isSending = true;
    this.countDownTimer = setInterval(() => {
      if (this.countDown > 0) {
        this.countDown--;
        this.codeText = `${this.countDown}s后重发`;
      } else {
        clearInterval(this.countDownTimer);
        this.countDown = 60;
        this.codeText = "发送验证码";
        this.isSending = false;
      }
    }, 1000);
  }

  async sendCode(){
    this.waiting()
    try{
      await cloud.auth().requestVerifyCode({
        action: VerifyCodeAction.REGISTER_LOGIN,
        lang: 'zh_CN',
        sendInterval: 60,
        verifyCodeType: {
          phoneNumber: this.phoneNum,
          countryCode: '86',
          kind: "phone",
        }
      })
      hilog.info(0,"Login","SUCCESS");
    }catch (e){
      if(e.code == 203818048&&e.message=="verify code within send interval"){
        this.tipDialog("请于60s后再发送",3000)
        return;
      }
      this.tipDialog("验证码发送失败",3000);
      hilog.info(0,"Login",JSON.stringify(e))
    }
  }

  async register(){
    if(!this.isCheck){
      this.tipDialog("请勾选隐私协议",3000)
      return;
    }
    if(this.password!=this.passwordConfirm){
      this.tipDialog("请保持两次密码一致",3000);
      return;
    }
    if(!checkPasswordComplexity(this.password)){
      this.tipDialog("请提高密码复杂度",3000);
      return;
    }
    if(this.password==this.phoneNum){
      this.tipDialog("请不要以手机号作为密码",3000);
      return;
    }
    try{
      const res = await cloud.auth().createUser({
        kind: 'phone',
        countryCode: '86',
        phoneNumber: this.phoneNum,
        password: this.password,
        verifyCode: this.code
      })
      const user = res.getUser()
      const uuid: string = user.getUid()
      const phone_num = user.getPhone()
      const exist: AddResponseInterface = await queryExistUser({
        uuid,
        phone_num
      })
      if(exist.data.length===0){
        const records: AddUserInterface = {
          uuid,
          phone_num
        }
        await addUser(records);
      }
      hilog.info(0,"Login",this.phoneNum)
      hilog.info(0,"Login",this.password)
      this.tipDialog("注册成功",3000)
      this.waitTimer = setTimeout(() => {
        this.pageStack.replacePathByName("Index",null,false)
      },3000)
    } catch (e) {
      if(e.code == 203818130&&e.message=="The user has been registered"){
        this.tipDialog("此用户已存在",3000)
        return;
      }
      hilog.info(0,"Login",JSON.stringify(e))
    }
  }

  aboutToDisappear() {
    if (this.timer !== null) {
      clearTimeout(this.timer);
      this.timer = null;
    }
    if(this.tipTimer!==null){
      clearTimeout(this.tipTimer);
      this.tipTimer = null;
    }
    if(this.waitTimer!==null){
      clearTimeout(this.waitTimer);
      this.waitTimer = null;
    }
  }

  checkEnableRegister(){
    if(this.password.length>=6&&this.passwordConfirm.length>=6&&this.phoneNum!=""&&this.code!=""){
      this.enableRegister = true;
    }else{
      this.enableRegister = false;
    }
  }

  goLogin(){
    this.pageStack.replacePathByName("Login", null, false);
  }

  build() {
    NavDestination() {
      Column(){
        Column(){
          Text('注册').font({weight:500,size:32})
        }.margin({top:96,bottom:32})
        Column(){
          Column(){
            Column({space: 16}){
              TextInput({ placeholder: "手机号" })
                .height(50)
                .width('100%')
                .type(InputType.PhoneNumber)
                .borderRadius(8)
                .maxLength(11)
                .onChange((val: string)=>{
                  this.phoneNum = val;
                  if(isValidPhoneNumber(this.phoneNum)){
                    this.enableClickSend = true;
                  }
                  this.checkEnableRegister()
                })
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                TextInput({ placeholder: "验证码" })
                  .type(InputType.Number)
                  .width('45%')
                  .height('100%')
                  .borderRadius(8)
                  .maxLength(6)
                  .onChange((val: string)=>{
                    this.code = val;
                    this.checkEnableRegister()
                  })
                Row() {
                  CustomButton({text: this.codeText,enable: this.enableClickSend})
                    .width('100%')
                    .onClick(()=> {
                      if (!this.isSending&&this.enableClickSend) {
                        this.sendCode();
                      }else {
                        return
                      }
                    })
                }.width('50%').height('100%').backgroundColor('#388FDA').borderRadius(8)
              }.width('100%').height(50)

              TextInput({placeholder:"输入新的密码(6-12位)"})
                .maxLength(12)
                .height(50)
                .width('100%')
                .type(InputType.Password)
                .borderRadius(8)
                .onChange((val:string)=>{
                  this.password = val
                  this.checkEnableRegister()
                })
              TextInput({placeholder:"再次输入密码(6-12位)"})
                .maxLength(12)
                .height(50)
                .width('100%')
                .borderRadius(8)
                .type(InputType.Password)
                .onChange((val:string)=>{
                  this.passwordConfirm = val;
                  this.checkEnableRegister()
                  hilog.info(0,"Login",this.enableRegister.toString())
                })
              Text("至少需要包含2种字符类型（大写字母、小写字母、数字、符号）")
                .fontSize(12)
                .fontColor(Color.Red)
            }.padding({top:8,bottom:8,left:4})
          }
          CustomButton({text: "立即注册",buttonWidth: 228,enable: this.enableRegister})
            .margin({top:12})
            .onClick(()=>{
              if(this.enableRegister){
                this.register()
              }else{
                hilog.info(0,"Login",this.enableRegister.toString())
                return
              }
            })
          PrivacyCheck({isCheck: $isCheck}).margin({top:12})
        }.padding({top:24,bottom:24,left:24,right:24}).backgroundColor(Color.White).margin({right:16,left:16,top:12,bottom:12}).borderRadius(8)
        Column(){
          Text("已有账号，立即登录").onClick(()=>{
            this.goLogin()
          })
        }.margin({top: 12})
      }.backgroundColor($r('app.color.background_color')).width('100%').height('100%')
    }
    .hideTitleBar(true)

  }
}