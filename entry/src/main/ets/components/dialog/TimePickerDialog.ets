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
export default struct TimePickerDialog {
  controller?: CustomDialogController
  title: string = "标题";
  onConfirm?: (value: string) => void = (value) => {};
  isMilitaryTime: boolean = true
  private  selectedTime: Date = new Date("2023-01-01");

  cancel: () => void = () => {
    this.controller?.close()
  }
  confirm: () => void = () => {
    if(this.onConfirm != undefined){
      const res = this.selectedTime.toString()
      this.onConfirm(res);
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
      TimePicker({
        selected: this.selectedTime,
      })
        .useMilitaryTime(this.isMilitaryTime)
        .onChange((value: TimePickerResult) => {
          if(value.hour >= 0) {
            this.selectedTime.setHours(value.hour, value.minute)
          }
        })
        .disappearTextStyle({color: Color.Red, font: {size: 15, weight: FontWeight.Lighter}})
        .textStyle({color: Color.Black, font: {size: 20, weight: FontWeight.Normal}})
        .selectedTextStyle({color: Color.Blue, font: {size: 30, weight: FontWeight.Bolder}})
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