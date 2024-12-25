/*
 * 验证手机号是否合法
 * */
export const isValidPhoneNumber = (phoneNumber: string) => {
  const regex = /^1[3-9]\d{9}$/;
  return regex.test(phoneNumber);
}

/*
 * 随机生成带有前缀的字符串
 * */
export const generateRandomIdWithPrefix = (prefix: string = '', length: number = 10) => {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let result = '';
  for (let i = 0; i < length; i++) {
    result += characters.charAt(Math.floor(Math.random() * characters.length));
  }
  return prefix + '_' + result;
}

/*
 * 密码复杂度检验
 * */
export const checkPasswordComplexity = (password: string) => {
  const hasUpper = /[A-Z]/.test(password);
  const hasLower = /[a-z]/.test(password);
  const hasDigit = /[0-9]/.test(password);
  const hasSymbol = /[!@#$%^&*(),.?":{}|<>]/.test(password);

  let charTypesCount = 0;
  if (hasUpper) charTypesCount++;
  if (hasLower) charTypesCount++;
  if (hasDigit) charTypesCount++;
  if (hasSymbol) charTypesCount++;

  return charTypesCount >= 2;
}