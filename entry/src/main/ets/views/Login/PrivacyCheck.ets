import { common } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { CommonConstant } from '../../constant/CommonConstant';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Component
export default  struct PrivacyCheck {
  @Consume pageStack: NavPathStack
  @Link isCheck: boolean;
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  async getPreference(){
    try{
      let data_preferences = await preferences.getPreferences(this.context,CommonConstant.PREFERENCES_NAME)
      const isPrivacy = await data_preferences.get(CommonConstant.IS_PRIVACY_NAME,false) as boolean;
      hilog.info(0,"Login","isPrivacy-->"+isPrivacy)
      if(isPrivacy){
        this.isCheck = isPrivacy;
      }
    } catch (e) {
      hilog.info(0,"Login","获取失败"+JSON.stringify(e))
    }
  }

  async putPreference(){
    try{
      const data_preferences = await preferences.getPreferences(this.context,CommonConstant.PREFERENCES_NAME)
      data_preferences.put(CommonConstant.IS_PRIVACY_NAME,this.isCheck)
      data_preferences.flush();
      hilog.info(0,"Login","写入成功")
    } catch (e) {
      hilog.info(0,"Login","clickPrivacy---"+JSON.stringify(e))
    }
  }

  aboutToAppear(){
    this.getPreference()
  }

  async clickPrivacy(value: boolean){
    this.isCheck = value;
    this.putPreference()
  }

  build() {
    Flex({alignItems:ItemAlign.Center}){
      Checkbox({ name: 'checkbox2' })
        .select(this.isCheck)
        .selectedColor(0x39a2db)
        .shape(CheckBoxShape.ROUNDED_SQUARE)
        .onChange((value: boolean) => {
          this.clickPrivacy(value)
        }).margin({right:8})
      Flex({wrap:FlexWrap.Wrap}){
        Text('我已经阅读并同意')
        Text('《隐私政策》')
          .fontColor($r("app.color.link_text_color"))
          .onClick(()=>{
            this.pageStack.pushPathByName("Privacy",null,false)
          })
        Text('和')
        Text('《用户协议》')
          .fontColor($r("app.color.link_text_color"))
          .onClick(()=>{
            this.pageStack.pushPathByName("Protocol",null,false)
          })
      }
    }
  }
}