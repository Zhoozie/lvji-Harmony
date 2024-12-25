import { hilog } from '@kit.PerformanceAnalysisKit';
import StrategyList from './StrategyList';

@Component
export default  struct JourneyContent {
  @State message:string = "Yes"
  @State name:string = ""
  @State TabLists:Array<string> = ['全部','未执行','执行中','已执行'];
  aboutToAppear(): void {
    hilog.info(0,"Journey","进入攻略页面");
  }
  build() {
    Column(){
      Tabs({}){
        ForEach(this.TabLists,(tab:string,index: number)=>{
          TabContent(){
            StrategyList({
              state: index
            })
          }.tabBar(tab).backgroundColor($r('app.color.background_color'))
        })
      }
    }.width("100%").height("100%")
  }
}