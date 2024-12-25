import CustomButton from '../../../components/common/CustomButton';
import NumInput from '../../../components/common/NumInput';
import TimePickerDialog from '../../../components/dialog/TimePickerDialog';
import TipDialog from '../../../components/dialog/TipDialog'
import date from '../../../utils/DateUtil'
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AddTripInterface } from '../../../api/interface/trip';
import { generateRandomIdWithPrefix } from '../../../utils/Index';
import { TripAddParamsInterface } from '../../../api/interface/params';
import { PageInfo } from '@kit.ArkUI';
import { addTrip } from '../../../api/services';
import { AddResponseInterface } from '../../../api/interface/common';

class resultClass {
  constructor(code: number) {
    this.code = code;
  }
  code: number = 200
}


@Builder
export function TripAddBuilder() {
  TripAdd()
}

@Component
export struct TripAdd {
  @Styles titleStyle(){
    .height(24)
  }

  @Consume pageStack: NavPathStack;
  @State journey_id: string = '';
  @State current_date: string = '';
  @State spot:string = '';
  @State startTime: string = '08:00';
  @State note: string = ''
  @State minute: number = 0;
  @State budget: number = 0;
  @State tips: string = "";
  timer: number | null = null;

  timeDialogController: CustomDialogController | null = new CustomDialogController({
    builder: TimePickerDialog({
      title: "开始时间",
      selectedTime: new Date(this.current_date),
      onConfirm: (val: string) => {
        this.startTime = date.formatTime(new Date(val));
      }
    })
  })

  textAreaController: TextAreaController = new TextAreaController()

  tipDialogController: CustomDialogController | null= new CustomDialogController({
    builder: TipDialog({
      content: this.tips
    }),
    alignment: DialogAlignment.Center,
    customStyle: false,
    cornerRadius: 12,
    width: 228,
    height: 64,
  })

  tipDialog(content: string,time: number){
    this.tips = content
    this.tipDialogController?.open()
    this.timer = setTimeout(()=>{
      this.tipDialogController?.close()
    },time)
  }


  aboutToAppear(): void {
    hilog.info(0,"Journey",`进入了TripAdd页面`)
    if(Object(this.pageStack.getParamByName('TripAdd')).length>=1){
      const params: TripAddParamsInterface = Object(this.pageStack.getParamByName('TripAdd'))[0]
      this.journey_id = params.journey_id;
      this.current_date = params.current_date;
      hilog.info(0,"Journey",`JourneyEdit:params---${JSON.stringify(params)}`)
    }
  }

  aboutToDisappear() {
    if (this.timer !== null) {
      clearTimeout(this.timer);
      this.timer = null; // 可选，清除引用
    }
  }


  build() {
    NavDestination(){
      Column(){
        Flex({direction:FlexDirection.Column}){
          Column(){
            Column(){
              Text('地点')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
              TextInput({ placeholder: '请输入地点' })
                .showUnderline(true)
                .height(40)
                .onChange((val: string)=>{
                  this.spot = val;
                })
            }.alignItems(HorizontalAlign.Start).margin({top: 8,bottom:8})
            Column(){
              Text('开始时间').fontSize(20).fontWeight(FontWeight.Bold)
              Text(this.startTime)
                .height(40)
                .onClick(()=>{
                  this.timeDialogController?.open()
                })
            }.alignItems(HorizontalAlign.Start).margin({top: 8,bottom:8})
            NumInput({title:'预计用时（分钟）',num: this.minute})
              .margin({top:8,bottom:8})
          }.backgroundColor(Color.White).width('100%').alignItems(HorizontalAlign.Start).padding(16).margin({top:8,bottom:8}).borderRadius(8)

          Column(){
            NumInput({title:'预算（元）',num: this.budget})
              .margin({top:8,bottom:8})
            Column(){
              Text('备注')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
              TextArea({
                text: this.note,
                placeholder: '还有什么需要补充的...',
                controller: this.textAreaController
              }).borderRadius(8)
                .margin({top:8})
                .height(96)
                .fontSize(16)
                .fontColor(Color.Black)
                .maxLength(100)
                .showCounter(true, { thresholdPercentage: 50, highlightBorder: true })
                .onChange((val: string) => {
                  this.note = val
                })
            }.alignItems(HorizontalAlign.Start).margin({top: 8,bottom:8})

          }.backgroundColor(Color.White).width('100%').alignItems(HorizontalAlign.Start).padding(16).margin({top:8,bottom:8}).borderRadius(8)
          CustomButton({text:"立即添加",buttonWidth: 228})
            .margin({top:16,bottom:16})
            .alignSelf(ItemAlign.Center)
            .onClick(()=>this.addTrip())
        }.padding({top:8,left:12,right:12})
      }.width('100%').height('100%').backgroundColor($r('app.color.background_color'))
    }.title("添加行程")

  }
  async addTrip(){
    const records: AddTripInterface = {
      trip_id: generateRandomIdWithPrefix("trip",10),
      spot: this.spot,
      minute: this.minute,
      note: this.note,
      budget: this.budget,
      start_time: this.startTime,
      journey_id: this.journey_id,
      current_date: this.current_date
    }
    hilog.info(0,"Journey",`${this.spot}--${this.startTime}--${this.minute}--${this.budget}--${this.note}`)
    try{
      const res: AddResponseInterface = await addTrip(records);
      this.tips = "创建成功"
      this.tipDialogController?.open()
      this.timer = setTimeout(()=>{
        this.tipDialogController?.close()
        this.pageStack.pop(res)
      },3000)
    } catch (e) {
      hilog.info(0,"Journey",JSON.stringify(e));

    }
  }
}