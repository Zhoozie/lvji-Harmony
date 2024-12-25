import CustomButton from '../../../../components/common/CustomButton'
import { AuthUser } from '@hw-agconnect/cloud';

@Builder
export function VerifyPhoneBuilder() {
  VerifyPhone()
}

@Component
export struct VerifyPhone {
  @Consume pageStack: NavPathStack;
  @State phoneNum: string = ""

  submit(){
    this.pageStack.replacePathByName("Modify",null,false)
  }

  aboutToAppear(){
    const auth_user: AuthUser = AppStorage.get('auth_user') as AuthUser
    this.phoneNum = auth_user.getPhone()
  }

  build() {
    NavDestination(){
      Column(){
        Column({space:24}){
          Column(){
            Text("注册手机号")
              .fontSize(24)
              .fontWeight(500)
          }.width("100%").alignItems(HorizontalAlign.Start)
          TextInput({text:this.phoneNum})
            .enabled(false)
            .showUnderline(true)
          CustomButton({text: "获取验证码"})
            .onClick(()=>{
              this.submit()
            })
            .margin({top: 8})
        }.padding({top:64,bottom:8,right:32,left:32})
      }.width("100%").height("100%").backgroundColor($r("app.color.background_color"))
    }

  }
}