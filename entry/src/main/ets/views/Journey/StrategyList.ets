import { hilog } from '@kit.PerformanceAnalysisKit';
import { deleteJourney, getJourneyList } from "../../api/services";
import { DeleteJourneyInterface, QueryJourneyInterface,
  QueryJourneyResponseInterface } from "../../api/interface/journey";
import { AuthUser } from '@hw-agconnect/cloud';
import { DeleteResponseInterface, JourneyInfoInterface } from '../../api/interface/common';
import { JourneyEditParamsInterface } from '../../api/interface/params';
import dateUtil from '../../utils/DateUtil';

interface paramsInterface {
  journey_id: string,
  start_date: string,
  end_date: string,
  journeyDetail: JourneyInfoInterface
}

@Component
export default struct StrategyList {
  @Consume pageStack: NavPathStack;
  @State TabLists:Array<string> = ['全部','未执行','执行中','已执行'];
  @Prop state: number;
  @State journeyInfoList: Array<JourneyInfoInterface> = [];
  @State queryJourney: QueryJourneyInterface= {
    uuid: "",
    status: 0
  }
  @State refreshing: boolean = false;
  @State refreshOffset: number = 0;
  @State refreshState: RefreshStatus = RefreshStatus.Inactive;
  @State canLoad: boolean = false;
  @State isLoading: boolean = false;
  @State isRequestOver: boolean = false;
  @Builder
  refreshBuilder() {
    Stack({ alignContent: Alignment.Bottom }) {
      if (this.refreshState != RefreshStatus.Inactive && this.refreshState != RefreshStatus.Done) {
        Progress({ value: this.refreshOffset, total: 64, type: ProgressType.Ring })
          .width(32).height(32)
          .style({ status: this.refreshing ? ProgressStatus.LOADING : ProgressStatus.PROGRESSING })
          .margin(10)
      }
    }
    .clip(true)
    .height("100%")
    .width("100%")
  }

  @Builder
  footer() {
    Row() {
      LoadingProgress().height(32).width(48)
      Text("加载中")
    }.width("100%")
    .height(64)
    .justifyContent(FlexAlign.Center)
    .visibility(this.isLoading ? Visibility.Visible : Visibility.Hidden)
    if(this.isRequestOver){
      Row() {
        Text("已经到底了")
      }
      .width("100%")
      .height(64)
      .justifyContent(FlexAlign.Center)
    }
  }

  aboutToAppear(): void {
    hilog.info(0,"Journey","攻略列表渲染");
    this.getUserInfo()
    this.getJourneyList()
  }

  async getJourneyList(){
    this.queryJourney.status = this.state
    const res: QueryJourneyResponseInterface = await getJourneyList(this.queryJourney);
    this.journeyInfoList = res.data;
    this.isRequestOver = true;
  }

  async getUserInfo(){
    const auth_user: AuthUser = AppStorage.get('auth_user') as AuthUser
    if(auth_user){
      this.queryJourney.uuid = auth_user.getUid()
    }
  }

  async delete(id: string){
    const records: DeleteJourneyInterface = {
      id
    }
    const res: DeleteResponseInterface = await deleteJourney(records)
    this.getJourneyList();
  }

  async edit(journey_id: string,start_date: string,end_date: string){
    const params: JourneyEditParamsInterface = {
      journey_id,
      start_date,
      end_date
    }
    this.pageStack.pushPathByName("JourneyEdit",params,false)
  }


  build() {
    Refresh({ refreshing: $$this.refreshing, builder: this.refreshBuilder() }) {
      List() {
        ForEach(this.journeyInfoList,(item:JourneyInfoInterface)=>{
          ListItem(){
            Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.SpaceAround}){
              Flex({justifyContent: FlexAlign.SpaceBetween}){
                Text(item.name).fontSize(24).fontWeight(500)
              }.height(36)
              Column({space:4}){
                Text(`目的地：${item.destination}`)
                  .height(24)
                Flex({justifyContent: FlexAlign.SpaceBetween}){
                  Row(){
                    Text(`预算：${item.budget}`)
                  }.width("50%")
                  Row(){
                    Text(`人数：${item.num}`)
                  }.width("50%")
                }.height(24)
              }
              .alignItems(HorizontalAlign.Start)

              Flex({justifyContent: FlexAlign.SpaceBetween,alignItems: ItemAlign.Center}){
                Text(`更新于${dateUtil.timestampToDate(Number(item.update_timestamp))}`).lineHeight(36)
                Text("编辑").onClick(()=>{
                  this.edit(item.journey_id,item.start_date,item.end_date)
                }).lineHeight(36)
                Text("删除").onClick(()=>{
                  this.delete(item.journey_id)
                }).lineHeight(36)
              }.height(36)
            }
          }.backgroundColor('#709FC4').width('100%').padding(8).borderRadius(8).margin({bottom:12})
        })
        ListItem() {
          this.footer();
        }.margin({bottom:32})
      }
      .scrollBar(BarState.Off)
      // 开启边缘滑动效果
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .padding({top:16,bottom:16,right:12,left:12})
    }
    .width("100%")
    .height("100%")
    .onOffsetChange((offset: number) => {
      this.refreshOffset = offset;
    })
    .onStateChange((state: RefreshStatus) => {
      this.refreshState = state;
    })
    .onRefreshing(() => {
      setTimeout(() => {
        this.isRequestOver = false;
        this.refreshing = false;
        this.getUserInfo()
        this.getJourneyList()
      }, 2000)
    })

  }

}