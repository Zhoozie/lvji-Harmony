@Entry
@Preview
@Component
struct Test {
  build() {
    Column(){
      Scroll(){
        Column(){
          Text("隐私声明")
            .fontSize(36)
            .fontWeight(600)
            .letterSpacing(4)
            .alignSelf(ItemAlign.Center)
          Text("旅迹 是由 张博 （以下简称“我们”）为您提供的，用于制作旅行攻略的应用。本隐私声明由我们为处理您的个人信息而制定。")
          Text("我们非常重视您的个人信息和隐私保护，将会按照法律要求和业界成熟的安全标准，为您提供相应的安全保护措施。")
          Text("1. 我们如何收集和使用您的个人信息")
            .fontWeight(600)
          Text("我们仅在有合法性基础的情形下才会使用您的个人信息。根据适用的法律，我们可能会基于您的同意、为履行/订立您与我们的合同所必需、履行法定义务所必需等合法性基础，使用您的个人信息。")
          Text("1.1 基于履行法定义务或其他法律法规规定的情形，我们可能会处理您的以下个人信息：")
          Text("为了实现应用功能，基于履行我们的合同义务我们需要收集您的账号信息 。")
          Text("2. 管理您的个人信息")
            .fontWeight(600)
          Text("如您对您的数据主体权利有进一步要求或存在任何疑问、意见或建议，可通过本声明中“如何联系我们”章节中所述方式与我们取得联系，并行使您的相关权利。")
          Text("3. 信息存储地点及期限")
            .fontWeight(600)
          Text("3.1 固定存储期限：3年")
          Text("3.2 上述信息将会传输并保存至中国境内的服务器。")
          Text("4. 如何联系我们")
            .fontWeight(600)
          Text("您可通过以下方式联系我们，并行使您的相关权利，我们会尽快回复。")
          Text("邮箱：zhguzibo@163.com")
          Text("如果您对我们的回复不满意, 特别是当个人信息处理行为损害了您的合法权益时您还可以通过向有管辖权的人民法院提起诉讼、向行业自律协会或政府相关管理机构投诉等外部途径进行解决。 您也可以向我们了解可能适用的相关投诉途径的信息。")
          Text("生效日期：2024.12.19")
            .alignSelf(ItemAlign.End)
        }.alignItems(HorizontalAlign.Start)
      }
      .padding({top:16,bottom:16,right:12,left:12})
      .scrollBar(BarState.Off)
    }.width("100%").height("100%").backgroundColor("#f0f0f0")
  }
}