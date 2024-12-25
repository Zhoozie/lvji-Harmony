import { hilog } from "@kit.PerformanceAnalysisKit";

@Extend(Text)function dialogBtn(){
  .backgroundColor(0xffffff)
  .width(188)
  .height(30)
  .fontSize(22)
  .textAlign(TextAlign.Center)
}
@Extend(Text) function dialogFontSize(fontSize:number){
  .fontSize(fontSize)
  .width('100%')
  .fontColor('rgba(0,0,0,0.86)')
  .textAlign(TextAlign.Center)
  .alignSelf(ItemAlign.Center)
}
@CustomDialog
export default struct DatePickerDialog {
  controller: CustomDialogController
  title: string = "标题";
  onConfirm?: (value: string) => void = (value) => {};
  startDate: string = '2024-12-03';
  endDate: string = '2030-01-01';
  // selectedDate: string = '';
  isLunar: boolean = false;
  @Link isCLickDate: boolean | undefined;
  private selectedTime: Date = new Date(this.startDate)

  cancel: () => void = () => {
    hilog.info(0,"Journey",this.selectedTime.toString())
    this.controller?.close()
  }
  confirm: () => void = () => {
    if(this.onConfirm != undefined){
      if (this.isCLickDate !== undefined) {
        this.isCLickDate = true;
      }
      this.onConfirm(this.selectedTime.toString());
      this.controller?.close();
    }
  }
  //标题、正文文案样式
  @Builder TipTextStyle(tip:string,fontSize:number){
    Text(tip)
      .dialogFontSize(fontSize)
      .margin({top:8,bottom:16})
      .visibility(tip.length>0?Visibility.Visible:Visibility.None)
  }
  build() {
    Column() {
      this.TipTextStyle(this.title,28)
      DatePicker({
        start: new Date(this.startDate),
        end: new Date(this.endDate),
        selected: this.selectedTime
      })
        .disappearTextStyle({color: Color.Gray, font: {size: '16fp', weight: FontWeight.Bold}})
        .textStyle({color: '#ff182431', font: {size: '18fp', weight: FontWeight.Normal}})
        .selectedTextStyle({color: '#ff0000FF', font: {size: '26fp', weight: FontWeight.Regular}})
        .lunar(this.isLunar)
        .onDateChange((value: Date) => {
          this.selectedTime = value
        })
      Flex({justifyContent:FlexAlign.SpaceAround}){
        Text('取消')
          .dialogBtn()
          .fontColor($r('app.color.cancel_font_color'))
          .onClick(()=>{
            this.cancel()
          })
        Text('确定')
          .dialogBtn()
          .fontColor($r('app.color.confirm_font_color'))
          .onClick(()=>{
            this.confirm()
          })
      }.margin({top:16})

    }.padding(16)
  }
}