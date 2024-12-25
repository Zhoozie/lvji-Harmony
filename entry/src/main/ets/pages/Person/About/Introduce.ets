@Builder
export function IntroduceBuilder() {
  Introduce()
}
@Component
export struct Introduce {
  build() {
    NavDestination() {
      Column(){
        Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.SpaceAround}){
          Blank()
          Column(){
            Text("旅迹").fontSize(44).fontWeight(600).letterSpacing(4)
          }
          Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.Center}){
            Text("版本号")
            Text("备案号")
          }
        }
      }.width("100%").height("100%").backgroundColor("#f0f0f0")
    }.title("关于旅迹")

  }
}