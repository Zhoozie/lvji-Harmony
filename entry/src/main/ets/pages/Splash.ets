import cloud from '@hw-agconnect/cloud';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Splash {
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack()

  @State opacityValue: number = 0.3;
  async goNext(){
    const user = await cloud.auth().getCurrentUser()
    hilog.info(0,"Login",JSON.stringify(user).toString())
    if(user == null){
      this.pageStack.replacePathByName("Login", null, false);
    }else{
      this.pageStack.replacePathByName("Index",null,false);
    }
  }

  onPageShow(): void {
    hilog.info(0,"Login","进入启动页")
    this.opacityValue = 1
  }
  build() {
    Navigation(this.pageStack) {
      Column(){
        Blank()
        Column(){
          Text("你的").fontSize("#fff").fontSize(36).fontWeight(600).letterSpacing(2)
          Text("专属旅游搭子").fontSize("#fff").fontSize(36).fontWeight(600).letterSpacing(2)
        }.alignItems(HorizontalAlign.Start).opacity(this.opacityValue).animation({
          duration: 1500,
          iterations: 3,
          onFinish: ()=>{
            this.goNext()
          }
        })
        Blank()
        Blank()
        Text("旅迹").fontSize("#fff").fontSize(44).fontWeight(600).margin({bottom:36}).letterSpacing(4)
      }
      .width("100%")
      .height("100%")
      .linearGradient({
        colors: [
          ["#d7bde2",0],
          ["#aaadda",0.4],
          ["#739fcc",1],
        ]
      })
    }
    .mode(NavigationMode.Stack)
    .hideToolBar(true)
  }
}