import { AuthUser } from '@hw-agconnect/cloud'
import { hilog } from '@kit.PerformanceAnalysisKit';
import CustomButton from '../../../../components/common/CustomButton';

@Builder
export function AccountBuilder() {
  Index()
}

class resultClass {
  constructor(count: number) {
    this.count = count;
  }
  count: number = 10
}

@Component
export struct Index {
  @Consume pageStack: NavPathStack;
  @State phoneNum: string = ""
  @Builder
  item(key: string,val: string){
    Flex({justifyContent:FlexAlign.SpaceBetween}){
      Text(key).fontSize(20).lineHeight(24)
      Text(val).fontSize(14).lineHeight(24)
    }.padding(8)
  }

  aboutToAppear(){
    const auth_user: AuthUser = AppStorage.get('auth_user') as AuthUser
    this.phoneNum = auth_user.getPhone()
    hilog.info(0,"Login",`Account--->--${this.phoneNum}`)
  }

  build(){
    NavDestination(){
      Column(){
        Column(){
          Column(){
            this.item("手机号",this.phoneNum)
            Divider()
            Flex({justifyContent:FlexAlign.SpaceBetween}){
              Text("修改密码").fontSize(20).lineHeight(24)
              Text(">").fontSize(14).lineHeight(24).onClick(()=>{
                this.pageStack.pushPathByName("VerifyPhone",null,false);
              })
            }.padding(8)
            Divider()
            Flex({justifyContent:FlexAlign.SpaceBetween}){
              Text("注销账号").fontSize(20).lineHeight(24)
              Text(">").fontSize(14).lineHeight(24).onClick(()=>{
                this.pageStack.pushPathByName("Delete",null,false);
              })
            }.padding(8)
          }.backgroundColor(Color.White).borderRadius(8).padding({top:8,bottom:8,left:4})
        }.padding({top:16,bottom:16,right:12,left:12})
      }.width("100%").height("100%").backgroundColor("#f0f0f0")
    }.title("账号与安全")
  }
}