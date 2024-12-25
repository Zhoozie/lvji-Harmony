import {
  RequestInterface, ResponseInterface, UserInfoInterface
}
from './common';
export interface AddUserInterface {
  uuid: string,
  phone_num: string
}

export interface AddUserRequestInterface extends RequestInterface{
  records: AddUserInterface
}

export interface QueryUserInterface {
  uuid: string
}

export interface QueryUserRequestInterface extends RequestInterface{
  records: QueryUserInterface
}

export interface  QueryUserResponseInterface extends ResponseInterface {
  data: UserInfoInterface
}