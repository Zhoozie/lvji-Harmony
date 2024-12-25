@CustomDialog
export default struct userPrivacyDialog {
  controller: CustomDialogController = new CustomDialogController({'builder': ''});
  // 不同意按钮回调
  cancel: Function = () => {};
  // 同意按钮回调
  confirm: Function = () => {};
  build() {
    Column() {
      Text("用户隐私协议")
    }
  }
}
