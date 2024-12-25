@Entry
@Component
struct Reset {
  build() {
    Column(){
      Column(){
        Text("重置密码")
      }.width("100%").height("100%").backgroundColor($r("app.color.background_color"))
    }
  }
}