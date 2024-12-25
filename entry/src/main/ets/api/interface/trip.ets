import { RequestInterface, ResponseInterface, TripInfoInterface } from "./common"

export interface AddTripInterface {
  trip_id: string,
  journey_id: string,
  spot: string,
  start_time: string,
  note: string,
  current_date: string,
  budget: number,
  minute: number
}

export interface AddTripRequestInterface extends RequestInterface{
  records: AddTripInterface
}

export interface QueryTripInterface {
  journey_id: string,
  current_date: string
}

export interface QueryTripRequestInterface extends RequestInterface{
  records: QueryTripInterface
}

export interface QueryTripResponseInterface extends ResponseInterface{
  data: Array<TripInfoInterface>
}