@Component
export default struct CustomButton {
  @Prop text: string = "点击"
  @Prop icon: string = ""
  @Prop buttonWidth: number | string = '100%'
  @Prop buttonHeight: number = 48
  @Prop buttonBgColor: string = '#388FDA'
  @Prop fontColor: string = "#ffffff"
  @Prop fontSize: number = 24
  @Prop enable: boolean = true;

  build() {
    Flex({alignItems:ItemAlign.Center,justifyContent:FlexAlign.Center}){
      if(this.icon){
        Image(this.icon)
          .width(48)
          .height(48)
      }
      Text(this.text)
        .textAlign(TextAlign.Center)
        .fontColor(this.fontColor)
        .letterSpacing(1)
        .fontWeight(500)
        .fontSize(this.fontSize)
    }
    .borderRadius(8)
    .width(this.buttonWidth)
    .height(this.buttonHeight)
    .backgroundColor(this.buttonBgColor)
    .opacity(this.enable?1:0.8)
  }
}