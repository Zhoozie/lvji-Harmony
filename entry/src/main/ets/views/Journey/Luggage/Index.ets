import InputDialog from "../../../components/dialog/InputDialog"
import {AddLuggageInterface,
  QueryLuggageResponseInterface} from "../../../api/interface/luggage";
import { generateRandomIdWithPrefix } from "../../../utils/Index";
import { addLuggage, getLuggageList } from "../../../api/services";
import { AddResponseInterface, LuggageInfoInterface } from "../../../api/interface/common";
import { hilog } from "@kit.PerformanceAnalysisKit";
import { JourneyEditParamsInterface } from "../../../api/interface/params";

@Component
export default struct Luggage {
  @Consume pageStack: NavPathStack;
  @State journey_id: string = ""
  @State records: AddLuggageInterface = {
    luggage_id: "",
    journey_id: "",
    name: ""
  }
  @State luggageList: Array<LuggageInfoInterface> = []

  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: InputDialog({
      title: "添加行李",
      onConfirm: (val: string) => {
        this.addLuggage(val)
      }
    }),
  })
  aboutToAppear() {
    if(Object(this.pageStack.getParamByName('JourneyEdit')).length>=1){
      const params: JourneyEditParamsInterface = Object(this.pageStack.getParamByName('JourneyEdit'))[0]
      this.journey_id = params.journey_id;
    }
    this.getLuggage()
  }

  // 在自定义组件即将析构销毁时将dialogController置空
  aboutToDisappear() {
    this.dialogController = null // 将dialogController置空
  }

  async getLuggage(){
    const query_res: QueryLuggageResponseInterface = await getLuggageList({
      journey_id: this.journey_id
    });
    this.luggageList = query_res.data;
  }

  async addLuggage(val: string) {
    this.records.journey_id = this.journey_id;
    this.records.luggage_id = generateRandomIdWithPrefix('lug',10);
    this.records.name = val;
    const res: AddResponseInterface = await addLuggage(this.records);
    this.getLuggage()
  }

  build() {
    Scroll(){
      Flex({direction:FlexDirection.Column}){
        Column(){
          if(this.luggageList.length === 0){
            Text("还未添加行李")
              .width('100%')
              .height(36)
              .textAlign(TextAlign.Center)
          }
          else{
            Flex({wrap: FlexWrap.Wrap}){
              ForEach(this.luggageList,(item: LuggageInfoInterface)=>{
                Text(item.name)
                  .height(36)
                  .textAlign(TextAlign.Center)
                  .borderWidth(1)
                  .borderColor('#000')
                  .borderRadius(8)
                  .padding({top:4,bottom:4,right:8,left:8})
                  .margin({top:4,bottom:4,right:8,left:8})
              })
            }

          }
        }.backgroundColor(Color.White).width('100%').borderRadius(8).padding(8).margin({top: 8})
        Column(){
          Text('添加行李')
            .backgroundColor(Color.White)
            .width('100%')
            .borderRadius(8)
            .padding({top:8,bottom:8})
            .font({size:20,weight:500})
            .textAlign(TextAlign.Center)
            .letterSpacing(4)
            .onClick(()=>{
              this.dialogController?.open()
            })
        }
        .width('100%')
        .margin({top: 16})
      }
    }.width('100%')
  }
}