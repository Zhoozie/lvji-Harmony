import { it } from "@ohos/hypium";

@Extend(GridItem)
function btnStyle(){
  .backgroundColor('rgb(237, 237, 237)')
  .height(50)
  .borderRadius(15)
}
@Component
export default struct NumInput {

  @Prop title: string;
  @State val: string = '';
  @Link num: number;

  textInputController: TextInputController = new TextInputController()

  close(){
    this.num = Number(this.val);
    this.textInputController.stopEditing()
  }

  // 自定义键盘组件
  @Builder CustomKeyboardBuilder() {
    Column() {
      Grid() {
        ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9], (item:number|string) => {
          GridItem() {
            Text(item + "")
              .fontSize(20)
              .fontWeight(500)
              .onClick(() => {
                console.log(`${item}`)
                this.appendToText(item+'')
              })
          }.btnStyle()
        })
        GridItem() {
          Text('X')
            .fontSize(20)
            .fontWeight(500)
            .onClick(() => {
              this.close()
            })
        }.btnStyle();
        GridItem() {
          Text('0')
            .fontSize(20)
            .fontWeight(500)
            .onClick(() => this.appendToText('0'));
        }.btnStyle()
        GridItem() {
          Text('del')
            .fontSize(20)
            .fontWeight(500)
            .onClick(() => {
              if (this.val.length > 0) {
                this.val = this.val.slice(0, -1);
              }
            });
        }.btnStyle()
      }
      .columnsTemplate('1fr 1fr 1fr')
      .maxCount(3)
      .columnsGap(10)
      .rowsGap(10)
      .padding(5)

    }.backgroundColor('rgb(225, 225, 225)')
  }

  // 辅助方法：将字符追加到estimatedTime
  appendToText(char: string) {
    this.val += char;
  }

  build() {
    Column(){
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      TextInput({ controller: this.textInputController, text: this.val,placeholder: this.num.toString() })
        .showUnderline(true)
        .showError()
        .customKeyboard(this.CustomKeyboardBuilder(),{supportAvoidance:true})
        .height(40)
        .onBlur(()=>{
          this.close()
        })
    }.alignItems(HorizontalAlign.Start)
  }
}