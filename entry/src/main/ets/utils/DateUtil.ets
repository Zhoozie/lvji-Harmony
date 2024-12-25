class DateUtil {

  private doubleNum(num: number) {
    return num < 10 ? '0' + num : num;
  }

  formatDate(val: Date){
    let year = val.getFullYear();
    let month = this.doubleNum(val.getMonth() + 1);
    let day = this.doubleNum(val.getDate());
    return `${year}-${month}-${day}`
  }

  formatTime(val: Date){
    let hour = this.doubleNum(val.getHours());
    let minute = this.doubleNum(val.getMinutes());
    return `${hour}:${minute}`;
  }

  /*
   * 两日期间有多少天
   * */
  calculateDaysBetweenDates(startDate: Date,endDate: Date){
    if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
      throw new Error('Invalid date string');
    }
    const timeDifference = endDate.getTime() - startDate.getTime();
    return timeDifference / (1000 * 60 * 60 * 24);
  }

  beginDateOfDay(date: Date){
    let d = new Date(date.getFullYear(),date.getMonth(),date.getDate());
    return d.getTime()
  }

  /*
   * 两日期间的日期
   * */
  getDatesBetween(startDate: string, endDate: string): string[] {
    const dates: string[] = [];
    const start = new Date(startDate);
    const endOfDay = new Date(endDate);
    endOfDay.setHours(23, 59, 59, 999);

    if (isNaN(start.getTime()) || isNaN(endOfDay.getTime())) {
      throw new Error('Invalid date string');
    }

    let currentDate = new Date(start);
    while (currentDate <= endOfDay) {
      dates.push(this.formatDate(currentDate));
      currentDate.setDate(currentDate.getDate() + 1);
    }

    return dates;
  }

  /*
   * 获取星期几
   * */
  getDayOfWeek(val: Date): string {
    const daysOfWeek = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
    const dayOfWeek = val.getDay();
    return daysOfWeek[dayOfWeek];
  }

  /*
   * 时间戳转换成日期
   * */
  timestampToDate(timestamp: number): string {
    const date = new Date(timestamp);
    return this.formatDate(date); // 使用您已经实现的formatDate方法来格式化日期
  }


  /*
   * 获取指定日期指定天数后的日期
   */
  getDateAfterDays(val: string,days: number): string {
    let newDate = new Date(val);
    newDate.setDate(newDate.getDate() + days);
    return this.formatDate(newDate);
  }

}

const dateUtil = new DateUtil();

export default dateUtil as DateUtil;