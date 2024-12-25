@Component
export default struct PhonePassword {
  @Link phoneNum: string;
  @Link password: string;
  @Prop isPhoneCode: boolean;
  checkEnableLogin: () => void = () => {
  }
  build() {
    Column(){
      TextInput({ placeholder: "手机号" })
        .height(50)
        .width('100%')
        .type(InputType.PhoneNumber)
        .margin({ top: 16, bottom: 8 })
        .borderRadius(8)
        .maxLength(11)
        .onChange((val: string)=>{
          this.phoneNum = val;
          this.checkEnableLogin()
        })
      TextInput({ placeholder: "密码" })
        .height(50)
        .width('100%')
        .type(InputType.Password)
        .margin({ top: 16, bottom: 8 })
        .borderRadius(8)
        .onChange((val: string)=>{
          this.password = val;
          this.checkEnableLogin()
        })
    }
  }
}