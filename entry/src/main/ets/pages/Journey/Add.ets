import DatePickerDialog from '../../components/dialog/DatePickerDialog'
import NumInput from '../../components/common/NumInput';
import CustomButton from '../../components/common/CustomButton';
import {AddJourneyInterface } from '../../api/interface/journey'
import cloud from '@hw-agconnect/cloud';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { addJourney } from '../../api/services';
import TipDialog from '../../components/dialog/TipDialog';
import { generateRandomIdWithPrefix } from '../../utils/Index'
import { AddResponseInterface } from '../../api/interface/common';
import dateUtil from '../../utils/DateUtil';

@Builder
export function JourneyAddBuilder() {
  JourneyAdd()
}

@Component
export struct JourneyAdd {
  @Consume pageStack: NavPathStack;
  @State currentDate: string = dateUtil.formatDate(new Date());
  @State isClickStartDate: boolean = false;
  @State isCLickEndDate: boolean = false;
  @State num: number = 1;
  @State budget: number = 0;
  @State tips: string = "";
  @State endDate: string = "";
  timer: number | null = null;
  @State payload: AddJourneyInterface = {
    name: '',
    id: "",
    uuid: "",
    num: 1,
    destination: '',
    budget: 0,
    start_date: this.currentDate,
    end_date: this.currentDate,
  }

  startDateDialogController: CustomDialogController | null = new CustomDialogController({
    builder: DatePickerDialog({
      title: "开始时间",
      startDate: this.currentDate,
      selectedTime: this.payload.start_date?new Date(this.payload.start_date):new Date(this.currentDate),
      isCLickDate: this.isClickStartDate,
      onConfirm: (val: string) => {
        console.log(`${this.isClickStartDate}`)
        this.payload.start_date = dateUtil.formatDate(new Date(val));
        this.endDate = dateUtil.getDateAfterDays(val,7);
        hilog.info(0,"Journey",this.endDate);
      }
    })
  })

  endDateDialogController: CustomDialogController | null = new CustomDialogController({
    builder: DatePickerDialog({
      title: "结束时间",
      startDate: this.payload.start_date,
      selectedTime: this.payload.end_date? new Date(this.payload.end_date): new Date(this.payload.start_date),
      endDate: this.endDate,
      isCLickDate: this.isCLickEndDate,
      onConfirm: (val: string) => {
        this.payload.end_date = dateUtil.formatDate(new Date(val));
      }
    })
  })

  tipDialogController: CustomDialogController = new CustomDialogController({
    builder: TipDialog({
      content: this.tips
    }),
    alignment: DialogAlignment.Center,
    customStyle: false,
    cornerRadius: 12,
    width: 228,
    height: 64,
  })

  build() {
    NavDestination(){
      Flex({wrap:FlexWrap.Wrap,justifyContent:FlexAlign.Center}){
        Flex({justifyContent:FlexAlign.Start,direction:FlexDirection.Column}){
          Text('请填写基本信息').fontColor('#969799').fontSize(16).margin({top:16}).padding({left:8,right:8})
          Column({space:16}){
            Column(){
              Text('旅行主题')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
              TextInput({ placeholder: '请输入旅行主题' })
                .showUnderline(true)
                .height(40)
                .onChange((val:string)=>{
                  this.payload.name = val
                })
            }.alignItems(HorizontalAlign.Start).margin({top: 8,bottom:8})
            Column(){
              Text('旅行目的地')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
              TextInput({ placeholder: '请输入旅行目的地' })
                .showUnderline(true)
                .height(40)
                .onChange((val:string)=>{
                  this.payload.destination = val
                })
            }.alignItems(HorizontalAlign.Start).margin({top: 8,bottom:8})
            NumInput({title:'成员人数',num:this.num})
              .margin({top:8,bottom:8})
            Flex({}){
              Column(){
                Text('开始时间').fontSize(20).fontWeight(FontWeight.Bold)
                Text(this.payload.start_date)
                  .height(40)
                  .onClick(()=>{
                    this.startDateDialogController?.open()
                  })
              }.alignItems(HorizontalAlign.Start).width('50%')
              Column(){
                Text('结束时间').fontSize(20).fontWeight(FontWeight.Bold)
                Text(this.payload.end_date)
                  .height(40)
                  .onClick(()=>{
                    if(this.isClickStartDate){
                      this.endDateDialogController?.open()
                    }else {
                      this.tipDialog("请先选择开始时间",3000)
                    }
                  })
              }.alignItems(HorizontalAlign.Start).width('50%')
            }.margin({top:8,bottom:8})
            NumInput({title:'预算（元）',num:this.budget})
              .margin({top:8,bottom:8})
          }.padding(16).margin({top:16,bottom:16}).width('100%').backgroundColor(Color.White).borderRadius(8)
          CustomButton({ text:"立即创建", buttonWidth: 228})
            .margin({top:16,bottom:16})
            .alignSelf(ItemAlign.Center)
            .onClick(()=>{
              this.createJourney()
            })
        }.padding({top:8,left:12,right:12})

      }.backgroundColor($r('app.color.background_color')).width("100%").height("100%")
    }.title("创建攻略")

  }

  tipDialog(content: string,time: number){
    this.tips = content
    this.tipDialogController.open()
    this.timer = setTimeout(()=>{
      this.tipDialogController.close()
    },time)
  }

  aboutToDisappear() {
    if (this.timer !== null) {
      clearTimeout(this.timer);
      this.timer = null;
    }
  }

  async createJourney(){
    try {
      const user = await cloud.auth().getCurrentUser()
      if(!user){
        return
      }
      if(this.payload.name==""||this.payload.destination==""){
        this.tipDialog("请将信息填写完整",3000)
        return ;
      }
      this.payload.id = generateRandomIdWithPrefix("jou",10);
      this.payload.budget = this.budget
      this.payload.num = this.num
      this.payload.uuid = user.getUid();
      const res: AddResponseInterface = await addJourney(this.payload);
      this.tips = "创建成功"
      this.tipDialogController.open()
      this.timer = setTimeout(()=>{
        this.pageStack.pop()
        this.tipDialogController.close()
      },3000)
    }catch (e){
      hilog.info(0,"Journey",JSON.stringify(e))
      this.tipDialog("创建失败",3000)
    }

  }
}