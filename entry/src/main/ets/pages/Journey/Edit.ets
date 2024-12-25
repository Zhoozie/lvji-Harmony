import Trip from '../../views/Journey/Trip/Index'
import { hilog } from '@kit.PerformanceAnalysisKit';
import { JourneyInfoInterface } from '../../api/interface/common';
import { queryJourneyInfo } from '../../api/services';
import { QueryJourneyInfoResponseInterface } from '../../api/interface/journey';
import { JourneyEditParamsInterface } from '../../api/interface/params';
import Luggage from '../../views/Journey/Luggage/Index';

@Builder
export function JourneyEditBuilder() {
  JourneyEdit()
}

@Component
export struct JourneyEdit {
  @Consume pageStack: NavPathStack;
  @State time: string = "";
  @State journey_id: string = "";
  @State start_date: string = "";
  @State end_date: string = "";
  @State journeyInfo: JourneyInfoInterface | undefined = undefined;
  @State journeyDetail: JourneyInfoInterface | undefined = undefined;


  async getJourneyInfo(){
    const res: QueryJourneyInfoResponseInterface = await queryJourneyInfo({
      journey_id: this.journey_id
    })
    if(Object(res.data).length >= 0){
      this.journeyInfo = Object(res.data)[0]
    }
  }

  aboutToAppear(){
    hilog.info(0,"Journey","进入了编辑页面---aboutToAppear")
    hilog.info(0,"Journey",`${this.journey_id}--${this.start_date}--${this.end_date}`)
    hilog.info(0,"Journey",`Index:params---${JSON.stringify(this.pageStack.getParamByName('Index'))}`)
    if(Object(this.pageStack.getParamByName('JourneyEdit')).length>=1){
      const params: JourneyEditParamsInterface = Object(this.pageStack.getParamByName('JourneyEdit'))[0]
      this.journey_id = params.journey_id;
      hilog.info(0,"Journey",`JourneyEdit:params---${JSON.stringify(params)}`)
      hilog.info(0,"Journey",`JourneyEdit:params---${this.journey_id}`)
    }
    this.getJourneyInfo()
  }

  private tabsController:TabsController = new TabsController();
  @State currentIndex:number = 0;

  @Builder TabsBuilder(title:string,targetIndex:number){
    Column(){
      Text(title).fontColor(this.currentIndex == targetIndex?'#1698CE':Color.Black).fontSize(20)
    }
    .onClick(()=>{
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(this.currentIndex)
    })
  }

  build() {
    NavDestination(){
      Column(){
        Flex({direction:FlexDirection.Column}){
          Column({space:16}){
            Text(this.journeyInfo?.name).font({size:24,weight:600})
            Flex(){
              Text("目的地：").margin({right:4})
              Text(this.journeyInfo?.destination)
            }
            Flex(){
              Text("旅行天数：").margin({right:4})
              Text(`${this.journeyInfo?.budget}天`)
            }
            Flex(){
              Text("预算：").margin({right:4})
              Text(`${this.journeyInfo?.budget}元`)
            }
            Text(this.time).fontSize(24).margin({ top: 20 });
          }.width('100%').backgroundColor(Color.White).padding({right:8,left:8,bottom:16,top:16}).borderRadius(8).alignItems(HorizontalAlign.Start)
          Column(){
            Tabs({controller:this.tabsController}){
              TabContent(){
                Trip().height('100%')
              }.tabBar(this.TabsBuilder('行程规划',0))
              TabContent(){
                Luggage().height('100%')
              }.tabBar(this.TabsBuilder('行李清单',1))
            }
            .barWidth(196)
            .scrollable(false)

          }.width('100%').height('100%').padding(8).borderRadius(8).alignItems(HorizontalAlign.Start).margin({top:12})
        }.padding({top:8,left:12,right:12})
      }.width('100%').height('100%').backgroundColor($r('app.color.background_color'))
    }.title("行程编辑")
  }
}