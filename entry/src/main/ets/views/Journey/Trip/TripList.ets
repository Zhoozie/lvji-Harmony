import { hilog } from "@kit.PerformanceAnalysisKit"
import { TripInfoInterface } from "../../../api/interface/common"
import { TripAddParamsInterface } from "../../../api/interface/params";
import { QueryTripResponseInterface } from "../../../api/interface/trip"
import { queryTripList } from "../../../api/services"
// 在UIAbility中使用
import observer from '@ohos.arkui.observer';
import { UIContext } from '@ohos.arkui.UIContext';


@Component
export default struct TripList {
  @Consume pageStack: NavPathStack;
  @Builder
  TripMenu() {
    Menu() {
      MenuItem({ content: "编辑"})
      MenuItem({ content: "删除"})
    }
  }
  @Prop current_date: string;
  @Prop journey_id: string;
  @Prop index: number;
  @State trip_list: Array<TripInfoInterface> = []

  async getTripList(){
    const query_res: QueryTripResponseInterface = await queryTripList({
      journey_id: this.journey_id,
      current_date: this.current_date
    });
    this.trip_list = query_res.data
    hilog.info(0,"Journey",`${this.current_date}--${JSON.stringify(this.trip_list)}`)
  }

  aboutToAppear(){
    hilog.info(0,"Journey","TripList--AboutToAppear")
    this.getTripList()
  }

  onPageShow(): void {
    hilog.info(0,"Journey","TripList--PageShow")
  }

  addTrip(){
    const params: TripAddParamsInterface = {
      journey_id: this.journey_id,
      current_date: this.current_date
    }
    this.pageStack.pushPathByName("TripAdd",params,(popInfo: PopInfo)=>{
      this.getTripList()
      hilog.info(0,"Journey","返回的结果为----"+JSON.stringify(popInfo))
    })
  }

  build() {
      Column(){
        Flex({alignItems:ItemAlign.End}){
          Text(`Day${this.index+1}`)
            .fontWeight(FontWeight.Bold)
            .fontSize(24)
            .height(24)
            .margin({right:8})
          Text(this.current_date)
            .fontSize(16)
        }
        Divider().margin({top:16,bottom:16})
        Flex({direction:FlexDirection.Column}){
          Column({space:16}){
            if(this.trip_list.length === 0){
              Text("暂未添加行程")
                .width("100%")
                .textAlign(TextAlign.Center)
            }else{
              ForEach(this.trip_list,(item: TripInfoInterface,index: number)=>{
                Flex({justifyContent:FlexAlign.SpaceBetween}){
                  Row({space:4}){
                    Text(`${index+1}`).margin({right: 4})
                    Text(item.spot)
                  }
                  // Row(){
                  //   Text('操作').bindMenu(this.TripMenu)
                  // }
                }
              })
            }
          }
          Divider().margin({top:8})
          Column(){
            Text('点我添加')
              .onClick(()=>{
                this.addTrip()
              })
          }.margin({top:16})
        }
      }
      .width('100%')
      .margin({top:16})
      .padding(16)
      .backgroundColor(Color.White)
      .borderRadius(8)
  }

}