import { LuggageInfoInterface, RequestInterface, ResponseInterface} from  './common'
export interface AddLuggageInterface {
  luggage_id: string,
  journey_id: string,
  name: string
}

export interface AddLuggageRequestInterface extends RequestInterface {
  records: AddLuggageInterface
}

export interface  QueryLuggageInterface {
  journey_id: string
}

export interface QueryLuggageRequestInterface extends RequestInterface {
  records: QueryLuggageInterface
}

export interface QueryLuggageResponseInterface extends ResponseInterface{
  data: Array<LuggageInfoInterface>
}