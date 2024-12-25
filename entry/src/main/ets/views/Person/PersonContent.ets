import { common } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { CommonConstant } from '../../constant/CommonConstant';
import cloud, { AuthUser } from '@hw-agconnect/cloud';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Component
export default struct PersonContent {
  @Consume pageStack: NavPathStack
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  @State avatar: string = "";
  @State userName: string = "";
  @StorageLink('auth_user')auth_user: AuthUser | null = null;

  @Builder
  item(msg: string,name: string){
    Flex({justifyContent:FlexAlign.SpaceBetween}){
      Text(msg).fontSize(20).fontWeight(500).lineHeight(24)
      Text(">").fontSize(14).lineHeight(24).onClick(()=>{
        this.pageStack.pushPathByName(name,null,false);
      })
    }.padding(8)
  }

  aboutToAppear(): void {
    hilog.info(0,"Login",JSON.stringify(this.auth_user).toString())
    this.getUserInfo()
  }

  getUserInfo(){
    this.userName = this.auth_user?.getDisplayName() ?this.auth_user?.getDisplayName():"旅迹";
    this.avatar = this.auth_user?.getPhotoUrl()?this.auth_user?.getPhotoUrl():"";
  }

  async deletePreference(){
    try{
      let data_preferences = await preferences.getPreferences(this.context,CommonConstant.PREFERENCES_NAME)
      data_preferences.delete(CommonConstant.IS_PRIVACY_NAME)
      hilog.info(0,"Login","删除成功")
    } catch (e) {
      hilog.info(0,"Login","删除失败"+JSON.stringify(e))
    }
  }

  async signOut(){
    await cloud.auth().signOut()
    this.pageStack.clear()
    AppStorage.clear();
    this.pageStack.pushPathByName("Login",null,false);
    this.deletePreference()
  }

  build() {
    Column(){
      Column({space: 5}){
        Image(this.avatar!=""?this.avatar:$r("app.media.avatar")).width(100).height(100).borderRadius(100)
        Text(this.userName).fontSize(32)
      }.width("100%").backgroundColor(Color.White).justifyContent(FlexAlign.Center).height(200)
      Column(){
        Column({space: 4}){
          this.item("个人资料","Info")
          this.item("设置","Setting")
        }.width("100%").backgroundColor(Color.White).borderRadius(8).padding({top:8,bottom:8,left:4})
        // Column({space: 4}){
        //   this.item("关于旅迹","Introduce")
        //   this.item("隐私政策","Privacy")
        // }.width("100%").backgroundColor(Color.White).borderRadius(8).margin({top:16}).padding({top:8,bottom:8,left:4})
        Button("退出登录",{type: ButtonType.Normal})
          .fontSize(20).borderRadius(5).margin({top:24}).width("80%").backgroundColor(Color.Red)
          .onClick(()=>{
            this.signOut()
          })
      }.padding({bottom:16,top:16,right:12,left:12})
    }.width("100%").height("100%").backgroundColor($r("app.color.background_color"))
  }
}
