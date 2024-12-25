// 定义一个对象字面量来存储错误消息和翻译
const errorMessages: Record<string, string> = {
  "account or verification code is incorrect.": "账号或验证码错误",
  "The password is same as before, please enter a new password": "密码与之前相同，请输入新密码"
  // ... 其他错误消息和翻译
};

// 导出 getErrorMessage 函数，该函数使用逻辑或运算符来处理可能的 undefined 情况
export const getErrorMessage = (message: string): string => {
  return (errorMessages[message] as string) || message;
};