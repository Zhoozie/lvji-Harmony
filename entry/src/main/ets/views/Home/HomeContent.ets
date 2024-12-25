import CustomButton from "../../components/common/CustomButton";
import DateUtil from "../../utils/DateUtil";

@Component
export default struct HomeContent {
  @Consume pageStack: NavPathStack;
  @State day: string = "";
  @State week: string = "";
  @State year_Month: string = ""
  aboutToAppear(): void {
    this.getCurrentTime()
  }

  getCurrentTime(){
    const date = new Date()
    this.day = date.getDate().toString()
    this.week = DateUtil.getDayOfWeek(date)
    this.year_Month = `${date.getFullYear()}年${date.getMonth()+1}月`
  }

  build() {
    Column(){
      Column(){
        Column(){
          Flex({justifyContent:FlexAlign.SpaceBetween,alignItems:ItemAlign.Center}) {
            Row() {
              Text(this.day)
                .fontWeight(700)
                .fontSize(48)
                .margin({right: 8})
              Column({space: 8}){
                Text(this.year_Month)
                  .fontSize(20)
                Text(this.week)
                  .fontSize(32)
                  .fontWeight(400)
              }
            }
            Image($r('app.media.smile'))
              .objectFit(ImageFit.Cover)
              .width(172)
              .height(172)
          }.padding({right: 16,left: 16,top: 24,bottom: 24})
        }
        CustomButton({text: "创建攻略"})
          .onClick(()=>{
            this.pageStack.pushPathByName("JourneyAdd",null,false)
          })

      }.padding({top:16,bottom:16,right:12,left:12})
    }.width("100%").height("100%").backgroundColor($r('app.color.background_color'))
  }
}

