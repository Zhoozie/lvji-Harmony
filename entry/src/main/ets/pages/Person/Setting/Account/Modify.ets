import CustomButton from '../../../../components/common/CustomButton';
import TipDialog from '../../../../components/dialog/TipDialog';
import { hilog } from '@kit.PerformanceAnalysisKit';
import cloud, { AuthUser, VerifyCodeAction } from '@hw-agconnect/cloud';
import { getErrorMessage } from '../../../../utils/ErrorUtil';
import { checkPasswordComplexity } from '../../../../utils/Index';

@Builder
export function ModifyBuilder() {
  Modify()
}

@Component
export struct Modify {
  @Consume pageStack: NavPathStack;
  @State codeText: string = "";
  @State phoneNum: string = "";
  @State code: string = "";
  @State countDown: number = 60;
  @State password: string = "";
  @State passwordConfirm: string = "";
  @State tips: string = "";

  @State isSending: boolean = true;
  @State enableSubmit: boolean = false;

  countDownTimer: number | null = null;
  tipTimer: number | null = null;
  backTimer: number | null = null;

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
    this.countDownTimer = setInterval(() => {
      if (this.countDown > 0) {
        this.countDown--;
        this.codeText = `${this.countDown}s后重发`;
      } else {
        clearInterval(this.countDownTimer);
        this.countDown = 5;
        this.codeText = "重新发送";
        this.isSending = false;
      }
    }, 1000);
  }

  async sendCode(){
    this.waiting()
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
    } catch (e) {
      hilog.info(0,"Login",JSON.stringify(e))
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
    if(this.password==this.phoneNum){
      this.tipDialog("请不要以手机号作为密码",3000);
      return;
    }
    try{
      const user = await cloud.auth().getCurrentUser()
      if(user){
        await user.updatePassword({
          password: this.password,
          providerType: 'phone',
          verifyCode: this.code
        })
        this.tipDialog("修改成功",3000)
        this.backTimer = setTimeout(()=>{
          this.pageStack.pop()
        },3000)
      }
    } catch (e) {
      this.tipDialog(getErrorMessage(e.message),3000);
      hilog.info(0,"Login",JSON.stringify(e))
    }
  }

  aboutToAppear(){
    const auth_user: AuthUser = AppStorage.get('auth_user') as AuthUser
    this.phoneNum = auth_user.getPhone().split('-')[1]
    this.sendCode()
  }

  aboutToDisappear(){
    if (this.countDownTimer) {
      clearInterval(this.countDownTimer);
      this.countDownTimer = null;
    }
    if (this.tipTimer) {
      clearTimeout(this.tipTimer);
      this.tipTimer = null;
    }
    if (this.backTimer){
      clearTimeout(this.backTimer);
      this.backTimer = null;
    }
  }

  checkEnableSubmit(){
    if(this.password.length>=6&&this.passwordConfirm.length>=6&&this.code.length == 6){
      this.enableSubmit = true;
    }else {
      this.enableSubmit = false;
    }
  }

  build() {
    NavDestination(){
      Column(){
        Column(){
          Column({space: 12}){
            Text(`验证码已发送至 +86 ${this.phoneNum}`)
              .width("100%")
              .height(36)
              .margin({left: 18})
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              TextInput({ placeholder: "验证码" })
                .type(InputType.Number)
                .width("60%")
                .borderRadius(8)
                .height('100%')
                .maxLength(6)
                .onChange((val: string) => {
                  this.code = val;
                  this.checkEnableSubmit()
                })
              Row() {
                Text(this.codeText)
                  .width('100%')
                  .textAlign(TextAlign.Center)
                  .fontSize(16)
                  .onClick(() => {
                    if(this.isSending){
                      return;
                    }else{
                      this.sendCode()
                    }
                  })
              }.width('30%').height('100%')
            }.width('100%').height(50)
            TextInput({placeholder:"输入新的密码"})
              .maxLength(12)
              .height(50)
              .width('100%')
              .type(InputType.Password)
              .borderRadius(8)
              .onChange((val:string)=>{
                this.password = val
                this.checkEnableSubmit()
              })
            TextInput({placeholder:"再次输入密码"})
              .maxLength(12)
              .height(50)
              .width('100%')
              .borderRadius(8)
              .type(InputType.Password)
              .onChange((val:string)=>{
                this.passwordConfirm = val;
                this.checkEnableSubmit()
              })
          }.padding({top:12,bottom:12,right:12,left:12}).margin({top:24,bottom:12,right:12,left:12}).backgroundColor(Color.White).borderRadius(8)
          Column(){
            Text("密码设置规则：")
              .width("100%")
              .fontSize(20)
            Column({space: 4}){
              Text("长度为6-12个字符.")
              Text("至少需要包含2种字符类型（大写字母、小写字母、数字、符号）。")
              Text("不可与帐号名（手机号、邮箱地址）相同。")
            }.alignItems(HorizontalAlign.Start).margin({top:8})
          }.padding({top:12,bottom:12,right:12,left:12}).margin({top:12,bottom:12,right:12,left:12})
          CustomButton({text:"修改密码"})
            .opacity(this.enableSubmit?1:0.8)
            .margin({top:24,right:24,left:24})
            .onClick(()=>{
              if(!this.enableSubmit){
                return;
              }
              this.submit()
            })
        }.width("100%").height("100%").backgroundColor($r("app.color.background_color"))
      }
    }.title("修改密码")

  }
}