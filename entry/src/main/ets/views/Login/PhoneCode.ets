import cloud, { VerifyCodeAction } from '@hw-agconnect/cloud';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { isValidPhoneNumber } from '../../utils/Index';
import TipDialog from '../../components/dialog/TipDialog';
import CustomButton from '../../components/common/CustomButton';

@Component
export default struct PhoneCode {
  @State countDown: number = 60;
  @State codeText: string = "发送验证码";
  @State codeEnable: boolean = false;
  @State isSending: boolean = false;
  @State tips: string = ""
  @Link phoneNum: string;
  @Link code: string;
  @Prop isPhoneCode: boolean;
  checkEnableLogin: () => void = () => {
  }

  countDownTimer?: number;
  tipTimer: number | null = null

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

  aboutToAppear() {
    if (this.countDownTimer) {
      clearInterval(this.countDownTimer);
      this.countDownTimer = undefined;
    }
    if(this.tipTimer){
      clearInterval(this.tipTimer);
      this.tipTimer =null;
    }
  }

  waiting() {
    this.codeText = `${this.countDown}s后重发`;
    this.codeEnable = false;
    this.isSending = true;
    this.countDownTimer = setInterval(() => {
      if (this.countDown > 0) {
        this.countDown--;
        this.codeText = `${this.countDown}s后重发`;
      } else {
        clearInterval(this.countDownTimer);
        this.countDown = 60;
        this.codeText = "发送验证码";
        this.codeEnable = true;
        this.isSending = false;
      }
    }, 1000);
  }

  async sendCode(){
    if (!this.isSending && isValidPhoneNumber(this.phoneNum)) {
      this.waiting();
      try {
        await cloud.auth().requestVerifyCode({
          verifyCodeType: {
            kind: "phone",
            phoneNumber: this.phoneNum,
            countryCode: '86'
          },
          action: VerifyCodeAction.REGISTER_LOGIN,
          lang: 'zh_CN',
          sendInterval: this.countDown
        });
        hilog.info(0,"VerifyCode","SUCCESS");
      }catch (e){
        this.tipDialog("验证码发送失败",3000);
        hilog.error(0,"VerifyCode",JSON.stringify(e));
      }
    }else{
      this.tipDialog("请输入正确的手机号",3000);
    }
  }

  build() {
    Column() {
      TextInput({ placeholder: "手机号" })
        .height(50)
        .width('100%')
        .type(InputType.PhoneNumber)
        .margin({ top: 16, bottom: 8 })
        .borderRadius(8)
        .maxLength(11)
        .onChange((val: string)=>{
          this.phoneNum = val;
          if (!isValidPhoneNumber(val)) {
            this.codeEnable = false;
          } else {
            this.codeEnable= true;
          }
          this.checkEnableLogin()
        })
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        TextInput({ placeholder: "验证码" })
          .type(InputType.Number)
          .width('45%')
          .height("100%")
          .borderRadius(8)
          .maxLength(6)
          .onChange((val: string)=>{
            this.code = val;
            this.checkEnableLogin()
          })
        Row() {
          CustomButton({text: this.codeText,enable: this.codeEnable})
            .width('100%')
            .onClick(()=> {
              if (this.codeEnable && !this.isSending) {
                this.sendCode();
              }else {
                return
              }
            })
        }.width('50%').height('100%').backgroundColor('#388FDA').borderRadius(8)
      }.margin({ top: 8, bottom: 16 }).width('100%').height(50)
    }
  }
}