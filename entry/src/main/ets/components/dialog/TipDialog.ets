@CustomDialog
export default struct TipDialog {
  content: string = '';
  controller: CustomDialogController
  build(){
    Flex({justifyContent:FlexAlign.Center,alignItems:ItemAlign.Center}){
      Text(this.content)
        .fontColor(Color.White)
        .textOverflow({overflow:TextOverflow.Clip})
    }
    .width('100%')
    .height('100%')
    .backgroundColor('rgb(35, 41, 51)')
  }
}