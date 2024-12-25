import { hilog } from '@kit.PerformanceAnalysisKit';
import { queryUserInfo } from '../api/services';
import { UserInfoInterface } from '../api/interface/common';
import cloud from '@hw-agconnect/cloud';
import { QueryUserResponseInterface } from '../api/interface/user';
import HomeContent from '../views/Home/HomeContent';
import PersonContent from '../views/Person/PersonContent';
import JourneyContent from '../views/Journey/JourneyContent';

@Builder
export function IndexBuilder() {
  Index()
}

@Component
export struct Index {
  @State message:string = "首页"
  // TabsController: TabsController = new TabsController();
  // onPageShow(): void {
  //   if(router.getParams()){
  //     let index = (router.getParams() as params).index;
  //     this.TabsController.changeIndex(index);
  //   }
  // }

  async getUserInfo() {
    try{
      /*
       * 华为认证
       * */
      const auth_user = await cloud.auth().getCurrentUser();
      AppStorage.setOrCreate("auth_user",auth_user);
      hilog.info(0,"Login","进入首页")
      /*
       * 本地数据库
       * */
      if(auth_user){
        const uuid = auth_user.getUid()
        const local_user_res: QueryUserResponseInterface = await queryUserInfo({
          uuid
        });
        hilog.info(0,"Login",JSON.stringify(local_user_res));
        const data = local_user_res.data;
        if(Object(data).length >= 1){
          const local_user: UserInfoInterface = Object(data)[0]
          AppStorage.setOrCreate("local_user",data);
        }
      }
    }catch (e){
      hilog.info(0,"Login","获取信息失败");
    }
  }

  async aboutToAppear(){
    this.getUserInfo()
    hilog.info(0,"Login","进入了首页")
  }

  build() {
    NavDestination() {
      Column(){
        Tabs({barPosition:BarPosition.End}) {
          TabContent() {
            HomeContent().height("100%")
          }.tabBar('首页')
          TabContent() {
            JourneyContent().height("100%")
          }.tabBar('攻略')
          TabContent() {
            PersonContent().height("100%")
          }.tabBar('个人')
        }
      }.width("100%").height("100%")
    }
    .hideTitleBar(true)
  }
}
