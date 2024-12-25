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
export default struct ConfirmDialog {
  title: string = '';
  content: string = '';
  controller: CustomDialogController

  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }
  //标题、正文文案样式
  @Builder TipTextStyle(tip:string,fontSize:number){
    Text(tip)
      .dialogFontSize(fontSize)
      .margin({top:8,bottom:16})
      .visibility(tip.length>0?Visibility.Visible:Visibility.None)
  }

  build(){
    Column(){
      this.TipTextStyle(this.title,28)
      this.TipTextStyle(this.content,22)
      Flex({justifyContent:FlexAlign.SpaceAround}){
        Text('取消')
          .dialogBtn()
          .fontColor($r('app.color.cancel_font_color'))
          .onClick(()=>{
            this.controller?.close()
            this.cancel()
          })
        Text('确定')
          .dialogBtn()
          .fontColor($r('app.color.confirm_font_color'))
          .onClick(()=>{
            this.controller?.close()
            this.confirm()
          })
      }.margin({top:16})
    }.padding(16)
  }
}