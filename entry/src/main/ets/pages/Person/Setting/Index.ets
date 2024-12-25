import { hilog } from "@kit.PerformanceAnalysisKit";

@Builder
export function SettingBuilder() {
  Index()
}

class ParamWithOp {
  operation: number = 1
  count: number = 10
}

@Component
export struct Index {
  @Consume pageStack: NavPathStack;
  @Builder
  item(msg: string, name: string){
    Flex({justifyContent:FlexAlign.SpaceBetween}){
      Text(msg).fontSize(20).fontWeight(500).lineHeight(24)
      Text(">").fontSize(14).lineHeight(24).onClick(()=>{
        hilog.info(0,"Journey","点击进入账号安全页面")
        this.pageStack.pushPathByName(name,new ParamWithOp(),(popInfo: PopInfo)=>{
          hilog.info(0,"Journey","返回至于设置页面了")
        },false);
      })
    }.padding(8)
  }
  build() {
    NavDestination() {
      Column(){
        Column(){
          Column({space: 4}){
            this.item("账号与安全","Account")
          }.backgroundColor(Color.White).borderRadius(8).padding({top:8,bottom:8,left:4})
        }.padding({top:16,bottom:16,right:12,left:12})
      }.width("100%").height("100%").backgroundColor($r("app.color.background_color"))
    }
    .title("设置")
  }
}