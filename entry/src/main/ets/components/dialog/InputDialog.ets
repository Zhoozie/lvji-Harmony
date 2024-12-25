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
export default struct InputDialog {
  controller?: CustomDialogController
  title: string = "标题";
  onConfirm?: (value: string) => void = (value) => {};
  placeholder?: string = "请在此输入内容";
  private inputValue: string = "";
  confirmFontColor: string = '#E84026';
  cancelFontColor: string = '#0A59F7';

  cancel: () => void = () => {
    this.controller?.close()
  }
  confirm: () => void = () => {
    if(this.onConfirm != undefined){
      this.onConfirm(this.inputValue);
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
      this.TipTextStyle(this.title,24)
      TextInput({
        placeholder: this.placeholder,
        text: this.inputValue
      }).margin({top:8,bottom:16}).borderRadius(8)
        .onChange((value: string) => {
          this.inputValue = value;
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