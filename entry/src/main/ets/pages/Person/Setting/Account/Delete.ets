import cloud from '@hw-agconnect/cloud'
import CustomButton from '../../../../components/common/CustomButton'
import ConfirmDialog from '../../../../components/dialog/ConfirmDialog'
import { hilog } from '@kit.PerformanceAnalysisKit'


@Builder
export function DeleteBuilder() {
  Delete()
}

@Component
export struct Delete {
  @Consume pageStack: NavPathStack;
  confirmDialogController: CustomDialogController | null = new CustomDialogController({
    builder: ConfirmDialog({
      content: "确定要删除吗？",
      confirm: ()=>{
        this.submit()
      }
    })
  })

  async submit(){
    try{
      await cloud.auth().deleteUser();
      this.pageStack.replacePathByName("Login",null,false)
    }catch (e){
      hilog.info(0,"Login","验证结果")
    }

  }

  build() {
    NavDestination(){
      Column(){
        Column(){
          CustomButton({text: "注销"})
            .margin({top:24,right:24,left:24})
            .onClick(()=>{
              console.log("删除成功")
              this.confirmDialogController?.open()
            })
        }.width("100%").height("100%").backgroundColor($r("app.color.background_color"))
      }
    }.title("注销账号")

  }
}