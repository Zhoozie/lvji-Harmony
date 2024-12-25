import date from '../../../utils/DateUtil'
import { hilog } from "@kit.PerformanceAnalysisKit"
import TripList from "./TripList"
import { JourneyEditParamsInterface } from "../../../api/interface/params"

@Component
export default struct Trip {
  @Styles item(){
    .width('100%')
    .margin({top:8})
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(8)
  }

  @Consume pageStack: NavPathStack;
  @State journey_id: string = "";
  @State start_date: string = "";
  @State end_date: string = "";
  @State dateList: string[] = []

  aboutToAppear(){
    if(Object(this.pageStack.getParamByName('JourneyEdit')).length>=1){
      const params: JourneyEditParamsInterface = Object(this.pageStack.getParamByName('JourneyEdit'))[0]
      this.journey_id = params.journey_id;
      this.start_date = params.start_date;
      this.end_date = params.end_date;
      hilog.info(0,"Journey",`JourneyEdit:params---${this.start_date}--${this.end_date}`)
    }
    hilog.info(0,"Journey","Trip页面")
    this.dateList = date.getDatesBetween(this.start_date,this.end_date)
  }

  build() {
    Scroll(){
      Flex({direction:FlexDirection.Column}){
        ForEach(this.dateList,(current_date: string,index: number)=>{
          TripList({
            current_date,
            index,
            journey_id: this.journey_id
          })
        })
      }.width("100%").padding({bottom:32})
    }.scrollBar(BarState.Off)
  }
}