import {
  AddJourneyInterface,
  AddJourneyRequestInterface,
  DeleteJourneyInterface,
  DeleteJourneyRequestInterface,
  QueryJourneyInfoInterface,
  QueryJourneyInfoRequestInterface,
  QueryJourneyInterface,
  QueryJourneyRequestInterface
} from './interface/journey'
import {
  AddUserInterface,
  AddUserRequestInterface, QueryUserInterface,
  QueryUserRequestInterface
}
from "./interface/user"
import cloud from '@hw-agconnect/cloud'
import {
  AddLuggageInterface,
  AddLuggageRequestInterface,
  QueryLuggageInterface,
  QueryLuggageRequestInterface
} from './interface/luggage'
import { AddTripInterface, AddTripRequestInterface, QueryTripInterface,
  QueryTripRequestInterface } from './interface/trip'

export const addUser = async (records: AddUserInterface) => {
  const request: AddUserRequestInterface = {
    operation: "add",
    records: records
  }
  const res = await cloud.callFunction({
    name: "add-user",
    version: '$latest',
    params: request
  })
  return res.getValue();
}

export const queryUserInfo = async (records: QueryUserInterface) => {
  const request: QueryUserRequestInterface = {
    operation: "query-info",
    records: records
  }
  const res = await cloud.callFunction({
    name: "add-user",
    version: '$latest',
    params: request
  })
  return res.getValue();
}

export const queryExistUser = async (records: AddUserInterface) => {
  const request: AddUserRequestInterface = {
    operation: "query-exist",
    records: records
  }
  const res = await cloud.callFunction({
    name: "add-user",
    version: '$latest',
    params: request
  })
  return res.getValue();
}

/*
 * 添加攻略
 * */
export const addJourney = async (payload:AddJourneyInterface) =>{
  const request: AddJourneyRequestInterface = {
    operation: "add",
    records: payload
  }
  const res = await cloud.callFunction({
    name: "add-journey",
    version: '$latest',
    params: request
  })
  return res.getValue();
}

/*
 * 查询攻略列表
 * */
export const getJourneyList = async (payload: QueryJourneyInterface) =>{
  const request: QueryJourneyRequestInterface = {
    operation: "query",
    records: payload
  }
  const res = await cloud.callFunction({
    name: "add-journey",
    version: '$latest',
    params: request
  })
  return res.getValue();
}

/*
 * 查询某个攻略信息
 * */
export const queryJourneyInfo = async (payload: QueryJourneyInfoInterface) =>{
  const request: QueryJourneyInfoRequestInterface = {
    operation: "query-info",
    records: payload
  }
  const res = await cloud.callFunction({
    name: "add-journey",
    version: '$latest',
    params: request
  })
  return res.getValue();
}

/*
 * 删除攻略
 * */
export const deleteJourney = async (payload: DeleteJourneyInterface) =>{
  const request: DeleteJourneyRequestInterface = {
    operation: "delete",
    records: payload
  }
  const res = await cloud.callFunction({
    name: "add-journey",
    version: '$latest',
    params: request
  })
  return res.getValue();
}

/*
 * 添加行李
 * */
export const addLuggage = async (records: AddLuggageInterface) =>{
  const request: AddLuggageRequestInterface = {
    operation: "add",
    records
  }
  const res = await cloud.callFunction({
    name: "add-luggage",
    version: '$latest',
    params: request
  })
  return res.getValue();
}

/*
 * 查询行李列表
 * */
export const getLuggageList = async (records: QueryLuggageInterface) =>{
  const request: QueryLuggageRequestInterface = {
    operation: "query",
    records
  }
  const res = await cloud.callFunction({
    name: "add-luggage",
    version: '$latest',
    params: request
  })
  return res.getValue();
}

/*
 * 添加行程
 * */
export const addTrip = async (records: AddTripInterface) =>{
  const request: AddTripRequestInterface = {
    operation: "add",
    records
  }
  const res = await cloud.callFunction({
    name: "add-trip",
    version: '$latest',
    params: request
  })
  return res.getValue();
}

/*
 * 查询行程列表
 * */
export const queryTripList = async (records: QueryTripInterface) =>{
  const request: QueryTripRequestInterface = {
    operation: "query",
    records
  }
  const res = await cloud.callFunction({
    name: "add-trip",
    version: '$latest',
    params: request
  })
  return res.getValue();
}