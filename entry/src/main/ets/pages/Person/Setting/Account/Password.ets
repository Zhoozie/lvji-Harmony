import CustomButton from '../../../../components/common/CustomButton'
import TipDialog from '../../../../components/dialog/TipDialog';
import cloud, { AuthUser, VerifyCodeAction } from '@hw-agconnect/cloud';
import { UserInfoInterface } from '../../../../api/interface/common';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { router } from '@kit.ArkUI';
import { checkPasswordComplexity } from '../../../../utils/Index';

@Entry
@Component
struct Account {
  @State password: string = "";
  @State passwordConfirm: string = "";
  @State phoneNum: string = "";
  @State code: string = "";
  @State isClick: boolean = false;
  @State tips: string = "";
  @State codeText: string = "发送验证码";
  @State codeEnable: boolean = false;
  @State isSending: boolean = false;
  @State countDown: number = 60;

  @StorageLink('auth_user')auth_user: AuthUser | null = null;
  @StorageLink('local_user')local_user: UserInfoInterface | null = null;

  countDownTimer: number | null = null
  tipTimer: number | null = null
  backTimer: number | null = null

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
    if (!this.isSending) {
      if(this.auth_user){
        this.phoneNum = this.auth_user.getPhone().split("-")[1]
      }
      hilog.info(0,"Login",this.auth_user?.getPhone());
      this.waiting();
      try {
        await cloud.auth().requestVerifyCode({
          action: VerifyCodeAction.RESET_PASSWORD,
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
        this.tipDialog("验证码发送失败",3000);
        hilog.error(0,"Login",JSON.stringify(e));
      }
    }
  }

  async submit(){
    if(this.password!=this.passwordConfirm){
      this.tipDialog("请保持两次密码一致",3000);
      return;
    }
    if(!checkPasswordComplexity(this.password)){
      this.tipDialog("请提高密码复杂度",3000);
      return;
    }
    try{
      const user = await cloud.auth().getCurrentUser()
      if(user){
        user.userReauthenticate({
          credentialInfo: {
            kind: 'phone',
            password: this.password,
            phoneNumber: this.phoneNum,
            countryCode: '86',
            verifyCode: this.code
          }
        });
        user.updatePassword({
          password: this.password,
          providerType: 'phone',
          verifyCode: this.code
        })
        hilog.info(0,"Login",this.phoneNum)
        hilog.info(0,"Login",this.password)
        this.tipDialog("修改成功",3000)
        this.backTimer = setTimeout(() => {
          router.back()
        },3000)
      }
    }catch (e){
      hilog.info(0,"Login",JSON.stringify(e))
    }

  }


  aboutToDisappear() {
    if (this.countDownTimer) {
      clearInterval(this.countDownTimer);
      this.countDownTimer = null;
    }
    if(this.backTimer){
      clearTimeout(this.backTimer);
      this.backTimer = null;
    }
    if(this.tipTimer){
      clearTimeout(this.tipTimer);
      this.tipTimer = null;
    }
  }

  build() {
    Column(){
      Column(){
        Column({space: 12}){
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            TextInput({ placeholder: "验证码" })
              .type(InputType.Number)
              .width('45%')
              .height('100%')
              .backgroundColor(Color.White)
              .borderRadius(8)
              .maxLength(6)
              .onChange((val: string)=>{
                this.code = val;
              })
            Row() {
              Text(this.codeText)
                .width('100%')
                .textAlign(TextAlign.Center)
                .fontColor(Color.White)
                .fontSize(20)
                .onClick(()=> {
                  if (!this.isSending) {
                    this.sendCode();
                  }else {
                    return
                  }
                })
            }.width('50%').height('100%').backgroundColor('#388FDA').borderRadius(8)
          }.width('100%').height(50)

          TextInput({placeholder:"输入新的密码"})
            .maxLength(12)
            .height(50)
            .width('100%')
            .type(InputType.Password)
            .backgroundColor(Color.White)
            .borderRadius(8)
            .onChange((val:string)=>{
              this.password = val
            })
          TextInput({placeholder:"再次输入密码"})
            .maxLength(12)
            .height(50)
            .width('100%')
            .backgroundColor(Color.White)
            .borderRadius(8)
            .type(InputType.Password)
            .onChange((val:string)=>{
              this.passwordConfirm = val;
              if(this.password.length>=6&&this.passwordConfirm.length>=6&&this.code!=""){
                this.isClick = true;
              }
            })
        }.padding({top:8,bottom:8,left:4})
        Text("密码长度请保持在6-12位，至少需要包含2种字符类型（大写字母、小写字母、数字、符号）").margin({top:12}).width("100%").textAlign(TextAlign.Start)
        CustomButton({text:"完成"}).margin({top:16})
          .opacity(this.isClick?1:0.8)
          .onClick(()=>{
          if(this.isClick){
            this.submit()
          }else{
            return
          }
        })
      }.padding({top:16,bottom:16,right:12,left:12})
    }.width("100%").height("100%").backgroundColor($r("app.color.background_color"))
  }
}