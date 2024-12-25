import cloud, { AuthUser } from '@hw-agconnect/cloud';
import { hilog } from '@kit.PerformanceAnalysisKit';
import CustomButton from '../../../components/common/CustomButton';

@Builder
export function InfoBuilder() {
  Index()
}

@Component
export struct Index {
  @Consume pageStack: NavPathStack;
  @State avatar: string = "";
  @State userName: string = "";
  @StorageLink('user')user: AuthUser | null = null;

  aboutToAppear(): void {
    this.userName = this.user?.getDisplayName()?this.user?.getDisplayName():"旅迹";
    this.avatar = this.user?.getPhotoUrl()?this.user?.getPhotoUrl():"";
  }

  build() {
    NavDestination() {
      Column(){
        Column(){
          Column(){
            Flex({justifyContent:FlexAlign.SpaceBetween}){
              Text("头像").fontSize(20).fontWeight(500).lineHeight(24)
              Image(this.avatar!=""?this.avatar:$r("app.media.avatar"))
                .width(64).height(64).borderRadius("100%")
            }.padding(8)
            Divider()
            Flex({justifyContent:FlexAlign.SpaceBetween}){
              Text("昵称").fontSize(20).fontWeight(500).lineHeight(24)
              Text(this.userName)
            }.padding(8)
          }.backgroundColor(Color.White).borderRadius(8).padding({top:8,bottom:8,left:4})
        }.padding({top:16,bottom:16,right:12,left:12})

      }.width("100%").height("100%").backgroundColor("#f0f0f0")
    }.title("个人资料").onReady((ctx)=>{
      const config: RouteMapConfig | undefined = ctx.getConfigInRouteMap()
      if (config) {
        let value : string = config.data['title']
        hilog.info(0,"Journey",value)
      }
    })
  }
}